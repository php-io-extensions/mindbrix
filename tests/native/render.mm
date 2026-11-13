/*
 * The pixel check PHP cannot make: appkit binds no way to read a CGImage's or a Metal
 * drawable's bytes. tests/NativeRenderTest.php compiles this with the extension's own
 * sources (lib/Rasterizer, src/prelude.h, src/shaders.m, src/shaders.inc) and runs it.
 *
 * It draws a 32x32 red square at (16, 16) on white in a 64x64 RasterizerView at scale 1,
 * through the Metal layer and through Core Graphics, off-screen (the view is never in a
 * window), and prints one line per path: "<path> <x>,<y>=<r>,<g>,<b>,<a> ...".
 *
 * The Metal drawable is kept by replacing -[CAMetalLayer nextDrawable] for this process
 * only, with framebufferOnly off so its texture can be read.
 */

#import <Cocoa/Cocoa.h>
#import <Metal/Metal.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "RasterizerView.h"

static id<CAMetalDrawable> lastDrawable;
static IMP originalNextDrawable;

static id keepNextDrawable(id self, SEL _cmd)
{
	lastDrawable = ((id (*)(id, SEL)) originalNextDrawable)(self, _cmd);
	return lastDrawable;
}

@interface SquareList : NSObject <RASceneListDelegate>
@end

@implementation SquareList
- (BOOL)shouldRedrawAtTime:(double)time scale:(double)scale width:(double)width height:(double)height
{
	return YES;
}

- (RASceneList *)getListAtTime:(double)time scale:(double)scale width:(double)width height:(double)height
{
	RAScene *scene = [RAScene new];
	[scene addFill:[[RAPath alloc] initWithRect:CGRectMake(16, 16, 32, 32)]
		ctm:CGAffineTransformIdentity
		color:[[RAPaint alloc] initWithRed:1 green:0 blue:0 alpha:1]
		evenOdd:NO
		clip:CGRectNull
		clipPath:nil
		blendMode:kRABlendNormal];
	RASceneList *list = [[RASceneList alloc] initWithScene:scene];
	list.clearColor = [[RAPaint alloc] initWithGray:1 alpha:1];
	return list;
}
@end

static const int samples[][2] = { {2, 2}, {17, 17}, {32, 32}, {47, 47}, {50, 50}, {61, 2} };

/* RGBA at (x, y), y down from the top, from 64x64 BGRA rows. */
static void print_bgra(const char *name, const uint8_t *px)
{
	printf("%s", name);
	for (auto &s : samples) {
		const uint8_t *p = px + (s[1] * 64 + s[0]) * 4;
		printf(" %d,%d=%d,%d,%d,%d", s[0], s[1], p[2], p[1], p[0], p[3]);
	}
	printf("\n");
}

int main()
{
	@autoreleasepool {
		Method next = class_getInstanceMethod(objc_getClass("CAMetalLayer"), @selector(nextDrawable));
		originalNextDrawable = method_setImplementation(next, (IMP) keepNextDrawable);
		SquareList *delegate = [SquareList new];

		/* Metal. */
		RasterizerView *metal = [[RasterizerView alloc] initWithFrame:NSMakeRect(0, 0, 64, 64)];
		metal.listDelegate = delegate;
		CAMetalLayer *layer = (CAMetalLayer *) metal.layer;
		layer.framebufferOnly = NO;
		layer.contentsScale = 1;
		layer.bounds = CGRectMake(0, 0, 64, 64);
		[layer display];
		[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.3]];
		if (lastDrawable == nil) {
			printf("metal no-drawable\n");
			return 1;
		}
		static uint8_t px[64 * 64 * 4];
		[lastDrawable.texture getBytes:px bytesPerRow:64 * 4 fromRegion:MTLRegionMake2D(0, 0, 64, 64) mipmapLevel:0];
		print_bgra("metal", px);

		/* Core Graphics: the view's layer contents, a CGImage, drawn into a 64x64 BGRA bitmap. */
		RasterizerView *cg = [[RasterizerView alloc] initWithFrame:NSMakeRect(0, 0, 64, 64)];
		cg.useCG = YES;
		cg.listDelegate = delegate;
		cg.layer.contentsScale = 1;
		[cg.layer display];
		CGImageRef image = (__bridge CGImageRef) cg.layer.contents;
		if (image == NULL) {
			printf("cg no-contents\n");
			return 1;
		}
		CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
		CGContextRef ctx = CGBitmapContextCreate(px, 64, 64, 8, 64 * 4, rgb, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
		CGContextDrawImage(ctx, CGRectMake(0, 0, 64, 64), image);
		CGContextRelease(ctx);
		CGColorSpaceRelease(rgb);
		print_bgra("cg", px);
	}
	return 0;
}

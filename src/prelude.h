/*
 * Force-included into lib/Rasterizer's RasterizerLayer.mm alone (config.m4).
 *
 * Upstream's layer makes its shader library with -[MTLDevice newDefaultLibrary]
 * outside SwiftPM, which reads default.metallib from the main bundle; PHP's main
 * bundle has none. Metal is imported first, so its own declaration of
 * newDefaultLibrary is already read when the macro is defined: only upstream's
 * call site is rewritten, into newLibraryWithSource:options:error: over the
 * shader source this extension carries (src/shaders.inc). Both are "new" family
 * methods returning +1, so the layer's ARC ownership is unchanged.
 */
#ifdef __OBJC__
#import <Metal/Metal.h>
#ifdef __cplusplus
extern "C"
#endif
NSString *mindbrix_shader_source(void);
#define newDefaultLibrary newLibraryWithSource:mindbrix_shader_source() options:nil error:nil
#endif

/*
 * The shader source RasterizerLayer compiles at run time (see src/prelude.h).
 * Metal caches what it compiles, so only the first layer a machine makes after
 * the source changes pays the full compile.
 */
#import <Foundation/Foundation.h>
#include "shaders.inc"

NSString *mindbrix_shader_source(void)
{
	return [NSString stringWithUTF8String:mindbrix_shader_text];
}

/*
 * mindbrix's classes are ext-appkit objects: appkit_object_setup gives them
 * appkit's object model (one PHP object per native object, retained while PHP
 * holds it), appkit_map_objc_class lets appkit's boxing find them, and
 * APPKIT_BEGIN / APPKIT_END turn an NSException into AppKitException.
 */

#ifndef MINDBRIX_RUNTIME_H
#define MINDBRIX_RUNTIME_H

#include "php_appkit_api.h"
#include "php_mindbrix.h"

#import "RasterizerAPI.h"
#import "RasterizerView.h"

void mindbrix_register_RasterizerAPI(int module_number);
void mindbrix_register_RasterizerView(int module_number);

#endif

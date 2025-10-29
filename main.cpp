
#include "flutter_embedder.h"
#include <wayland-client.h>
#include <EGL/egl.h>
#include <GLES2/gl2.h>
#include <iostream>

// Callback stub cho EGL/Wayland (cần hoàn thiện cho project thực tế)
static bool MakeCurrent(void* user_data) { return true; }
static bool ClearCurrent(void* user_data) { return true; }
static bool Present(void* user_data) { return true; }
static uint32_t FBOCallback(void* user_data) { return 0; }
static bool MakeResourceCurrent(void* user_data) { return true; }
static void* GLProcResolver(void* user_data, const char* name) {
    return (void*)eglGetProcAddress(name);
}

int main() {
    std::cout << "Starting IVI Home Screen Application (Wayland+OpenGL)..." << std::endl;

    FlutterRendererConfig config = {};
    config.type = kOpenGL;
    config.open_gl.struct_size = sizeof(FlutterOpenGLRendererConfig);
    config.open_gl.make_current = MakeCurrent;
    config.open_gl.clear_current = ClearCurrent;
    config.open_gl.present = Present;
    config.open_gl.fbo_callback = FBOCallback;
    config.open_gl.make_resource_current = MakeResourceCurrent;
    config.open_gl.gl_proc_resolver = GLProcResolver;

    FlutterProjectArgs args = {};
    args.struct_size = sizeof(FlutterProjectArgs);
    args.assets_path = "engine_arm64/flutter_assets";
    args.icu_data_path = "engine_arm64/icudtl.dat";

    FlutterEngine engine;
    FlutterEngineResult result = FlutterEngineRun(FLUTTER_ENGINE_VERSION, &config, &args, nullptr, &engine);

    if (result != kSuccess) {
        std::cerr << "Failed to run Flutter engine: " << result << std::endl;
        return 1;
    }

    std::cout << "Flutter engine initialized successfully!" << std::endl;
    std::cout << "IVI Home Screen is running..." << std::endl;
    std::cout << "Press Enter to exit..." << std::endl;
    std::cin.get();

    FlutterEngineShutdown(engine);
    std::cout << "Flutter engine shutdown complete." << std::endl;
    return 0;
}

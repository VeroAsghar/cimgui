const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "cimgui",
        .target = target,
        .optimize = optimize,
    });

    lib.defineCMacro("CIMGUI_USE_GLFW", "");
    lib.defineCMacro("IMGUI_IMPL_API", "extern \"C\"");
    lib.addIncludePath(.{ .path = "imgui" });
    lib.addIncludePath(.{ .path = "imgui/backends" });
    lib.addIncludePath(.{ .path = "generator/output" });

    lib.linkLibrary(b.dependency("glfw", .{
        .target = target,
        .optimize = optimize,
    }).artifact("glfw"));

    lib.linkLibC();
    lib.linkLibCpp();
    lib.addCSourceFiles(&src_files, &.{
        "-fno-exceptions",
        "-fno-rtti",
        "-Wall",
    });

    b.installArtifact(lib);
}

const src_files = [_][]const u8{
    "cimgui.cpp",
    "imgui/imgui.cpp",
    "imgui/imgui_draw.cpp",
    "imgui/imgui_demo.cpp",
    "imgui/imgui_tables.cpp",
    "imgui/imgui_widgets.cpp",
    "imgui/backends/imgui_impl_glfw.cpp",
};

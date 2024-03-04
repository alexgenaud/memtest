const std = @import("std");
const print = std.debug.print;
const toBytes = std.mem.toBytes;
const eql = std.mem.eql;

var SUBTRACT: u64 = 9900;

fn adr(ptr: *u32) u64 {
    return @intFromPtr(ptr) - SUBTRACT;
}

fn adrc(ptr: *const *u32) u64 {
    return @intFromPtr(ptr) - SUBTRACT;
}

fn lev3(ptr0: *u32, ptr1: *u32, ptr2: *u32) void {
    var val3: u32 = 553;
    var ptr3: *u32 = &val3;
    print("lev3(ptr0: *u32, ptr1: *u32, ptr2: *u32) {{\n", .{});
    print("  val3: u32 = {d}; // (&val3 = {d})\n", .{ val3, adr(&val3) });
    print("  ptr3: *u32 = &val3; // (ptr3 = {d})\n", .{adr(ptr3)});
    print("  if(@intFromPtr(ptr0)={} > @intFromPtr(ptr1)={} >\n", .{ adr(ptr0), adr(ptr1) });
    print("     @intFromPtr(ptr2)={} > @intFromPtr(ptr3)={}) {{\n\n", .{ adr(ptr2), adr(ptr3) });
    print("    stack addresses ", .{});

    if (adr(ptr0) < adr(ptr1) and adr(ptr1) < adr(ptr2) and adr(ptr2) < adr(&val3)) {
        print("increase ptr0 < ptr1 < ptr2 < ptr3\n", .{});
    } else if (adr(ptr0) > adr(ptr1) and adr(ptr1) > adr(ptr2) and adr(ptr2) > adr(&val3)) {
        print("decrease ptr0 > ptr1 > ptr2 > ptr3\n", .{});
    } else print("neither increase nor decrease\n", .{});

    print("  }}\n}}\n", .{});

    print("ptr0.* {d}   ptr0 {d}   &ptr0 {d}\n", .{ ptr0.*, adr(ptr0), adrc(&ptr0) });
    print("ptr1.* {d}   ptr1 {d}   &ptr1 {d}\n", .{ ptr1.*, adr(ptr1), adrc(&ptr1) });
    print("ptr2.* {d}   ptr2 {d}   &ptr2 {d}\n", .{ ptr2.*, adr(ptr2), adrc(&ptr2) });
    print("val3   {d}               &val3 {d}\n", .{ val3, adr(&val3) });
    print("ptr3.* {d}   ptr3 {d}   &ptr3 {d}\n", .{ ptr3.*, adr(ptr3), adrc(&ptr3) });
}

fn lev2(ptr0: *u32, ptr1: *u32) void {
    var val2: u32 = 552;
    print("lev2(ptr0: *u32, ptr1: *u32) {{\n", .{});
    print("  val2: u32 = {d};\n", .{val2});
    print("  lev3(ptr0 = {d}, ptr1 = {d}, &val2 = {d});\n", .{ adr(ptr0), adr(ptr1), adr(&val2) });
    print("}}\n", .{});
    lev3(ptr0, ptr1, &val2);
}

fn lev1(ptr0: *u32) void {
    var val1: u32 = 551;
    print("lev1(ptr0: *u32) {{\n", .{});
    print("  val1: u32 = {d};\n", .{val1});
    print("  lev2(ptr0 = {d}, &val1 = {d});\n", .{ adr(ptr0), adr(&val1) });
    print("}}\n", .{});
    lev2(ptr0, &val1);
}

fn unrelated() void {
    const Num = struct { i: u32 };
    var val9 = Num{ .i = 5 };
    print("val9 = {};\n", .{val9});
    print("&val9 = {d};\n", .{@intFromPtr(&val9) - SUBTRACT});
    print("val9.i = {d};\n", .{val9.i});
    print("&val9.i = {d};\n", .{adr(&val9.i)});
}

fn endian() void {
    const val: u32 = 67305985; // 01 02 03 04 little endian
    var strBytes: [4]u8 = toBytes(val);

    var i: u8 = 0;
    while (i < strBytes.len) : (i += 1) {
        strBytes[i] = strBytes[i] + 48;
    }

    print("\nstrBytes {s} is ", .{strBytes});
    if (eql(u8, &strBytes, "1234")) {
        print("little endian\n", .{});
    } else if (eql(u8, &strBytes, "4321")) {
        print("big endian\n", .{});
    } else print("neither 1234 nor 4321\n", .{});
}

pub fn main() !void {
    var val0: u32 = 550;
    SUBTRACT = @intFromPtr(&val0) - SUBTRACT;
    print("main() {{\n", .{});
    print("  val0: u32 = {d};\n", .{val0});
    print("  lev1(&val0 = {d});\n", .{adr(&val0)});
    print("}}\n", .{});
    lev1(&val0);

    endian();
}

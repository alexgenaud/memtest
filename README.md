`% zig run main.zig`

```
main() {
  val0: u32 = 550;
  lev1(&val0 = 9900);
}
lev1(ptr0: *u32) {
  val1: u32 = 551;
  lev2(ptr0 = 9900, &val1 = 9828);
}
lev2(ptr0: *u32, ptr1: *u32) {
  val2: u32 = 552;
  lev3(ptr0 = 9900, ptr1 = 9828, &val2 = 9740);
}
lev3(ptr0: *u32, ptr1: *u32, ptr2: *u32) {
  val3: u32 = 553; // (&val3 = 9440)
  ptr3: *u32 = &val3; // (ptr3 = 9440)
  if(@intFromPtr(ptr0)=9900 > @intFromPtr(ptr1)=9828 >
     @intFromPtr(ptr2)=9740 > @intFromPtr(ptr3)=9440) {

    stack addresses decrease ptr0 > ptr1 > ptr2 > ptr3
  }
}
ptr0.* 550   ptr0 9900   &ptr0 9492
ptr1.* 551   ptr1 9828   &ptr1 9500
ptr2.* 552   ptr2 9740   &ptr2 9508
val3   553               &val3 9440
ptr3.* 553   ptr3 9440   &ptr3 9444

strBytes 1234 is little endian
```

; Adds an adjustable frame limiter similar to U7SI's. Delays calling drawWorld
;     until the 60 Hz timer has fired N times since the last call, limiting the
;     the maximum update rate to 60/N fps.

%include "include/u7bg-all-includes.asm"

defineAddress   30, 0x018A, drawWorldCall
defineAddress   30, 0x018F, drawWorldCall_end
defineAddress   118, 0x0783, unusedMT32WaitLoop
defineAddress   118, 0x07B2, unusedMT32WaitLoop_end

[bits 16]

startPatch EXE_LENGTH, eop-frameLimiter
	startBlockAt addr_unusedMT32WaitLoop
		check:
			mov ax, [dseg_time]
			mov dx, [dseg_time+2]
			sub ax, [dseg_prevFrameTime]
			sbb dx, [dseg_prevFrameTime+2]
			cmp ax, [dseg_frameLimiterAdjust]
			jc check
		mov ax, [dseg_time]
		mov dx, [dseg_time+2]
		mov [dseg_prevFrameTime], ax
		mov [dseg_prevFrameTime+2], dx
		callFromLoadModule drawWorld
		jmpFromLoadModule drawWorldCall_end

		times 2 nop
	endBlockAt off_unusedMT32WaitLoop_end

	startBlockAt addr_drawWorldCall
		; jmp instead of call to preserve the position of drawWorld's stack args
		jmpFromLoadModule unusedMT32WaitLoop
	endBlockOfLength off_drawWorldCall_end
endPatch

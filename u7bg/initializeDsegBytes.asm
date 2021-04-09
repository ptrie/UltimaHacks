%include "include/u7bg-all-includes.asm"

%macro gameSpecificInitializations 0
	startBlockAt seg_dseg, dseg_frameLimiterEnabled
		db 1
	endBlock

	startBlockAt seg_dseg, dseg_prevFrameTime
		dd 0
	endBlock

	startBlockAt seg_dseg, dseg_frameLimiterAdjust
		dw 6
	endBlock

	startBlockAt seg_dseg, dseg_frameLimiterAdjustString
		db 'Delay? current=--', 0
	endBlockOfLength 18

	startBlockAt seg_dseg, dseg_frameLimiterAdjustStringFormat
		db '%02d', 0
	endBlockOfLength 5
%endmacro

%include "../u7-common/patch-initializeDsegBytes.asm"

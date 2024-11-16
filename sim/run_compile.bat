if exist ..\object_mem.mif (
    copy /Y ..\object_mem.mif .
)
if exist ..\object_mem_bb.v (
    del ..\object_mem_bb.v
)
if exist ..\blocks.mif (
    copy /Y ..\blocks.mif .
)
if exist ..\blocks_bb.v (
    del ..\blocks_bb.v
)
if exist ..\black.mif (
    copy /Y ..\black.mif .
)
if exist ..\black_bb.v (
    del ..\black_bb.v
)
if exist work rmdir /S /Q work

vlib work
vlog ../tb/*.v
vlog ../*.v
@REM vlog ../vga_adapter/*.v
@REM vlog ../PS2_Controller/*.v
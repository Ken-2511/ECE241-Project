if exist ..\canvas.mif (
    copy /Y ..\canvas.mif .
)
if exist ..\canvas_bb.v (
    del ..\canvas_bb.v
)
if exist work rmdir /S /Q work

vlib work
vlog ../tb/*.v
vlog ../*.v
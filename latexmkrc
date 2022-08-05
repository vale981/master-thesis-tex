$pdf_mode = 4;
@default_files = ('index.tex');
$out_dir = 'output';
set_tex_cmds( '--shell-escape %O %S' );
$pdf_update_method = 4;
$pdf_update_command = 'cp output/index.pdf output/index_preview.pdf';
$pdf_previewer = 'start okular output/index_preview.pdf'

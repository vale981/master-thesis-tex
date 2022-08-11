$pdf_mode = 4;
@default_files = ('index.tex');
$out_dir = 'output';
set_tex_cmds( '--shell-escape %O %S' );
$pdf_previewer = 'start zathura output/index.pdf'

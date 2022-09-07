$pdf_mode = 4;
@default_files = ('index.tex');
$out_dir = 'output';
set_tex_cmds( '-lua=mybatchmode.lua --shell-escape %O %S' );
$pdf_previewer = "zathura %O %S";

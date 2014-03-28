set terminal pdf font graph_font fontscale 1.0
set datafile separator ","
set output outfile
set size ratio 0.3
set border 3 front linetype -1 linewidth 1.000 lc rgb "#3d90c8"
set boxwidth 1 absolute
set style fill solid 1.00 noborder
set nokey
# inside top right horizontal Left reverse noenhanced autotitles columnhead nobox
set style histogram clustered gap 1 title offset character 2, 0.25, 0
set style data histograms

set xtics border in scale 0,0 nomirror  offset character 0, 0, 0 autojustify
set xtics norangelimit font ",10"
set xtics ()
set ytics border in scale 0,0 mirror norotate  offset character 0, 0, 0 autojustify

set label 1 category
set label 1 at graph 0.02, 1.1 tc rgb "#000000" font ",14" front
set label 2 disparity
set label 2 at graph 0.7, 1.1 tc rgb "#000000" font ",10" front
set yrange [ 0.0 : * ] noreverse nowriteback

plot file using 4:xtic(1) ti col lc rgb "#3479b9", '' u 5 ti col lc rgb "#4cb748"
# , '' u 4 ti col lc rgb "#92d9f5", '' u 5 ti col lc rgb "#fff200"
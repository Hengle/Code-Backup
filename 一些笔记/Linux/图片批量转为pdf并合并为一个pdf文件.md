最近需要将一些漫画从各种格式的图片合并为一个pdf文件并整理

```shell
#!/bin/sh

cd work

for dir in ls

do

 cd ${dir}

 echo "Now working on ${dir}.........."

 for each in ls

 do

 echo "Processing ${each}.............."

 convert -quality 100 -units pixelsperinch -density 60x60 -depth 16 -colorspace RGB -interlace none -verbose {each} {each%.*}.pdf

 done

 echo "${dir} is finished!"

 echo "======"

 cd ..

done
```

上面这段将每个图片转为单个的pdf

```shell
#!/bin/sh

cd work

for dir in ls

do

 echo "Now working on ${dir}.........."

 allfiles=(ls {dir} | sed "s:^:pwd/${dir}/: " | grep ".pdf")

 gs -q -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE={dir}.pdf -dBATCH {allfiles}

 echo "${dir} is finished!"

done
```

上面这段将每卷漫画下面所有已经转好的pdf合并为一个

这里分成了两段，但其实也可以合并为一个脚本，然后利用之前shell脚本并行的技巧加快处理速度。
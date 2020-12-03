Section: [[Re-encoding & Transcoding]]

The built-in video transcoding function in the LBRY desktop application starts the
FFMPEG utility process with the following parameters:

```ffmpeg
ffmpeg -i "$(path_to_original_file).ext" -y -c:s copy -c:d copy \
          -c:v libx264 -crf 24 -preset faster -pix_fmt yuv420p \
          -vf "scale=if(gte(iw\,ih)\,min(1920\,iw)\,-2):if(lt(iw\,ih)\,min(1920\,ih)\,-2)" \
          -maxrate 5500K -bufsize 5000K -movflags +faststart \
          -c:a aac -b:a 160k "$(path_to_original_file)_fixed.mp4"
```

The meanings of the passed parameters:

- ```ffmpeg -c:s copy``` and ```ffmpeg -c:d copy``` tell FFMPEG to copy subtitles and data,
  respectively.
- ```ffmpeg -c:v libx264 -crf 24 -preset faster -pix_fmt yuv420p``` tells FFMPEG to
  transcode the video using the `H.264` codec with constant rate factor equal to 24, with
  the `faster` preset and using the YUV color space with the `4:2:0` scheme for chroma
  subsampling.
- ```ffmpeg -vf "scale=if(gte(iw\,ih)\,min(1920\,iw)\,-2):if(lt(iw\,ih)\,min(1920\,ih)\,-2)"```
  specifies that the height and width of the video cannot be greater than 1920 pixels,
  and both values must be a multiple of two.
- ```ffmpeg -maxrate 5500K -bufsize 5000K``` specifies the maximum bitrate to be 5500 Kb/s
  with a buffer equal to 5000 Kb/s.
- ```ffmpeg -movflags +faststart``` tells FFMPEG to move the «moov atom» (the metadata)
  from the end of the file to its beginning to improve playback in browsers.
- ```ffmpeg -c:a aac -b:a 160k``` tells FFMPEG to transcode the audio with bitrate equal to
  160 kb/s.

An alternative option for transcoding a horizontal video with increased bitrate and quality
and better compression:

```ffmpeg
ffmpeg -i "$(path_to_original_file).ext" -y -c:s copy -c:d copy \
          -c:v libx264 -crf 17 -preset slower -pix_fmt yuv420p \
          -maxrate 8M -bufsize 8M -movflags +faststart \
          -c:a aac -b:a 160k "$(path_to_original_file) (Transcoded).mp4"
```

One may select optimal CRF values by performing tests on a sample of the target file with a
faster preset. The average bitrate of the transcoded test file should be close (on the left
side) to the target bitrate. The CRF value of 17 is sufficient to produce a video with
indistinguishable quality (using a slow preset). Note that with a fixed CRF value, the
target bitrate may not always be reached, and the encoder will use more bits if necessary.

A sample can be cut from the source file like this:

```ffmpeg
ffmpeg -i input.ext -ss 00:01:00 -to 00:02:00 -c copy sample.ext
```

References:
- [Guide for encoding video using FFMPEG](https://trac.ffmpeg.org/wiki/Encode/H.264)
- [Guide for encoding audio using FFMPEG](https://trac.ffmpeg.org/wiki/Encode/AAC)
- [Guide for scaling using FFMPEG](https://trac.ffmpeg.org/wiki/Scaling)
- [Guide for limiting bitrate using FFMPEG](https://trac.ffmpeg.org/wiki/Limiting%20the%20output%20bitrate)
- [Options for MP4 containers](https://ffmpeg.org/ffmpeg-formats.html#Options-9)
- [Article about rate control modes](https://slhck.info/articles/rate-control)
- [Article about CRF](https://slhck.info/articles/crf)

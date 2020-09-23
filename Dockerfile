FROM alpine:latest as compile
# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
WORKDIR /app
RUN apk add git automake autoconf make ca-certificates g++ libtool pkgconfig leptonica-dev
RUN git clone --depth 1  https://github.com/tesseract-ocr/tesseract.git
WORKDIR /app/tesseract
RUN ./autogen.sh
RUN mkdir -p bin/release
WORKDIR /app/tesseract/bin/release
RUN ../../configure --disable-openmp --disable-shared 'CXXFLAGS=-g -O2 -fno-math-errno -Wall -Wextra -Wpedantic'
RUN make -j4 
RUN make install

FROM alpine:latest as download
# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
WORKDIR /app
RUN apk add curl
RUN curl https://raw.githubusercontent.com/tesseract-ocr/tessdata_best/master/eng.traineddata -o /app/eng.traineddata

FROM alpine:latest as release
# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add g++ leptonica
COPY --from=download /app/eng.traineddata /usr/local/share/tessdata/
COPY --from=compile /app/tesseract/bin/release/tesseract /bin
RUN chmod +x /bin/tesseract
ENTRYPOINT ["tesseract"]
CMD ["--help-extra"]
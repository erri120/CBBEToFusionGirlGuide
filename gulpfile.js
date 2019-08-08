const gulp = require('gulp');
const zip = require('gulp-zip');
const imagemin = require('gulp-imagemin');
const run = require('gulp-run');
const change = require('gulp-change');
const rename = require('gulp-rename');
const del = require('del');
const {series} = gulp;

let dark = false;

function setDark(){
    return new Promise(function(resolve,reject){
        dark = true;
        resolve();
    });
}
function setLight(){
    return new Promise(function(resolve,reject){
        dark = false;
        resolve();
    });
}

function cleanWorkspace(cb){
    if(dark){
        return del('guideDark.pdf');
    }else{
        return del('guideLight.pdf');
    }
}

function optimizeImages(cb){
    return gulp.src('src/res/images/*')
        .pipe(imagemin())
        .pipe(gulp.dest('src/res/images'));
}

function backup(cb){
    return gulp.src('src/guide.tex')
        .pipe(gulp.dest('backup'));
}

function loadBackup(cb){
    return gulp.src('backup/guide.tex')
        .pipe(gulp.dest('src'));
}

function packagePdf(cb){
    if(dark){
        return gulp.src('guideDark.pdf')
        .pipe(zip('guideDarkPdf.zip'))
        .pipe(gulp.dest('dist'))
    }else{
        return gulp.src('guideLight.pdf')
        .pipe(zip('guideLightPdf.zip'))
        .pipe(gulp.dest('dist'))
    }
}

function packageImages(cb){
    return gulp.src('src/res/images/*')
        .pipe(zip('guideImages.zip'))
        .pipe(gulp.dest('dist'))
}

function replaceStr(content){
    let str = dark ? '%$DARK:' : '%$LIGHT:';
    str = str.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
    return content.replace(new RegExp(str,'g'),'');
}

function makeDarkTex(cb){
    return gulp.src('src/guide.tex')
        .pipe(change(replaceStr))
        .pipe(rename('guideDark.tex'))
        .pipe(gulp.dest('src/'));
}

function makeLightTex(cb){
    return gulp.src('src/guide.tex')
        .pipe(change(replaceStr))
        .pipe(rename('guideLight.tex'))
        .pipe(gulp.dest('src/'));    
}

function buildGuide(cb){
    if(dark){
        return run('xelatex -interaction=nonstopmode -file-line-error -aux-directory=src -include-directory=src/res/sections/ src/guideDark.tex').exec();
    }else{
        return run('xelatex -interaction=nonstopmode -file-line-error -aux-directory=src -include-directory=src/res/sections/ src/guideLight.tex').exec();
    }
}

exports.buildDark = series(setDark,backup,optimizeImages,makeDarkTex,buildGuide,loadBackup,packagePdf,cleanWorkspace);
exports.buildLight = series(setLight,backup,optimizeImages,makeLightTex,buildGuide,loadBackup,packagePdf,cleanWorkspace);
exports.packageImages = series(optimizeImages,packageImages);
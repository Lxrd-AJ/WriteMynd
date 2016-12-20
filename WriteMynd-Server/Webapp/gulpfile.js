var gulp = require("gulp");
var ts = require("gulp-typescript");
var watch = require('gulp-watch');
var path = require('path');

gulp.task("default", ["build","watch-webapp"]);

gulp.task("deploy", () => {
    gulp.start("build");
    gulp.start("move-node_modules");
})

gulp.task("watch-webapp", () => {
    watch('./**/*', () => {
        gulp.start("build");
    })
})

gulp.task("build", () => {
    //1. Move all non-typescript files
    gulp.src([
        "./**/*.html",
        "./**/*.css",
        "./**/*.js",
        "!./node_modules/**",
        "!./typings/**"
    ]).pipe(gulp.dest('./../.build/Webapp'));

    //2. Compile the typescript files
    var projectConfig = ts.createProject(path.resolve('./tsconfig.json'));
    var result = gulp.src([
        "./**/*.ts",
        "!./node_modules/**/*",
        "!./typings/**/*"
    ]).pipe(ts(projectConfig));

    return result.js.pipe(gulp.dest('./../.build/Webapp'));
});

gulp.task("move-node_modules", () => {
    console.info("Moving Node modules to build folder ...")
    return gulp.src([
        "./node_modules/**/*"
    ]).pipe(gulp.dest('./../.build/Webapp/node_modules'))
})
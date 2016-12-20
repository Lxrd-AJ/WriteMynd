var gulp = require("gulp");

gulp.task("move-node_modules", () => {
    console.info("Moving Node modules to build folder ...")
    return gulp.src([
        "./node_modules/**/*"
    ]).pipe(gulp.dest('./../.build/node_modules'))
});

gulp.task("move-files", () => {
    console.info("Moving non typescript files into the build folder");
    gulp.src([
        "./**/*.html",
        "./**/*.css",
        "./**/*.js",
        "!./node_modules/**",
        "!./typings/**"
    ]).pipe(gulp.dest('./.build'));
})
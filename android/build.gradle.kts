// android/build.gradle.kts
buildscript {
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:8.3.0")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
    // 빌드 디렉터리 설정
    val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
    rootProject.layout.buildDirectory.value(newBuildDir)

    // 서브프로젝트에 대한 빌드 디렉터리 설정
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // 앱 프로젝트에 의존성 설정
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
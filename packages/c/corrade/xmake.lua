package("corrade")

    set_homepage("https://magnum.graphics/corrade/")
    set_description("Cor­rade is a mul­ti­plat­form util­i­ty li­brary writ­ten in C++11/C++14.")
    set_license("MIT")

    add_urls("https://github.com/mosra/corrade/archive/refs/tags/$(version).zip",
             "https://github.com/mosra/corrade.git")
    add_versions("v2020.06", "d89a06128c334920d91fecf23cc1df48fd6be26543dc0ed81b2f819a92d70e72")

    if is_plat("windows") then
        add_syslinks("shell32")
    elseif is_plat("linux") then
        add_syslinks("dl")
    end
    add_deps("cmake")
    on_install("windows", "linux", "macosx", function (package)
        local configs = {"-DBUILD_TESTS=OFF", "-DLIB_SUFFIX=", "-DCMAKE_CXX_STANDARD=14"}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_STATIC=" .. (package:config("shared") and "OFF" or "ON"))
        --[[
        io.replace("src/Corrade/Utility/TweakableParser.cpp", "{value + 2, 16}", "{value.data() + 2, 16}", {plain = true})
        io.replace("src/Corrade/Utility/TweakableParser.cpp", "{value + 2, 2}", "{value.data() + 2, 2}", {plain = true})
        io.replace("src/Corrade/Utility/TweakableParser.cpp", "{value + 1, 8}", "{value.data() + 1, 8}", {plain = true})
        io.replace("src/Corrade/Utility/TweakableParser.cpp", "{value, 10}", "{value.data(), 10}", {plain = true})
        ]]
        import("package.tools.cmake").install(package, configs)
        package:addenv("PATH", "bin")
    end)

    on_test(function (package)
        os.vrun("corrade-rc --help")
        assert(package:check_cxxsnippets({test = [[
            #include <string>
            void test() {
                Corrade::Utility::Resource rs{"data"};
                rs.get(std::string("license.txt"));
            }
        ]]}, {configs = {languages = "c++14"}, includes = "Corrade/Utility/Resource.h"}))
    end)

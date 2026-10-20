function runc
    set cpp_files *.cpp

    # 1. Проверка на наличие файлов
    if not set -q cpp_files[1]
        set_color red
        echo "Error: The folder has no .cpp files!"
        set_color normal
        return 1
    end

    set -l file ""

    # 2. Логика выбора файла
    if test (count $argv) -eq 1
        set file $argv[1]
    else if test (count $cpp_files) -eq 1
        set file $cpp_files[1]
    else
        set_color yellow
        echo "Found several .cpp files. Select one from the list below: "
        set_color normal

        # Ручной выбор вместо отсутствующего select
        for i in (seq (count $cpp_files))
            echo "$i) $cpp_files[$i]"
        end
        echo "q) Cancel"

        read -l choice -p "echo '> '"

        if test "$choice" = q
            return 0
        else if test "$choice" -gt 0; and test "$choice" -le (count $cpp_files)
            set file $cpp_files[$choice]
        else
            set_color red
            echo "Invalid option!"
            set_color normal
            return 1
        end
    end

    # 3. Компиляция и запуск
    set_color blue
    echo "Compiling $file..." \n
    set_color normal

    if clang++ -std=c++17 -Wall -Wextra -O3 $file -o output.bin
        set_color green
        echo "Launching..." \n
        set_color normal
        echo --------------------------------\n
        ./output.bin
        echo
        echo --------------------------------\n
    else
        set_color red
        echo "An error occured while compiling the following files: $file"
        set_color normal
    end
end

option casemap:none


; ============================================================
; Libraries
; ============================================================

includelib kernel32.lib
includelib shell32.lib


; ============================================================
; Windows API
; ============================================================

EXTERN GetStdHandle:PROC
EXTERN WriteConsoleW:PROC
EXTERN ReadConsoleW:PROC
EXTERN GetFileAttributesW:PROC
EXTERN Sleep:PROC
EXTERN ExitProcess:PROC
EXTERN ShellExecuteW:PROC


; ============================================================
; Constants
; ============================================================

STD_INPUT_HANDLE  EQU -10
STD_OUTPUT_HANDLE EQU -11

INVALID_FILE_ATTRIBUTES EQU 0FFFFFFFFh

FILE_ATTRIBUTE_DIRECTORY EQU 10h

SW_HIDE EQU 0

MAX_INPUT_CHARS EQU 1024

; 520 WCHAR

MAX_PATH_CHARS EQU 520


; ============================================================
; .data
; ============================================================

.data


; ------------------------------------------------------------
; Please enter the Blender output folder path:
; ------------------------------------------------------------

promptPath \
    dw 'P','l','e','a','s','e',' ','e','n','t','e','r',' '
    dw 't','h','e',' ','B','l','e','n','d','e','r',' '
    dw 'o','u','t','p','u','t',' ','f','o','l','d','e','r',' '
    dw 'p','a','t','h',':'
    dw 000Dh
    dw 000Ah
    dw 0000h


; ------------------------------------------------------------
; Please enter the target filename:
; ------------------------------------------------------------

promptFile \
    dw 'P','l','e','a','s','e',' ','e','n','t','e','r',' '
    dw 't','h','e',' ','t','a','r','g','e','t',' '
    dw 'f','i','l','e','n','a','m','e',':'
    dw 000Dh
    dw 000Ah
    dw 0000h


; ------------------------------------------------------------
; Path cannot be empty!
; ------------------------------------------------------------

invalidPathText \
    dw 000Dh
    dw 000Ah
    dw 'P','a','t','h',' ','c','a','n','n','o','t',' '
    dw 'b','e',' ','e','m','p','t','y','!'
    dw 000Dh
    dw 000Ah
    dw 0000h


; ------------------------------------------------------------
; Filename cannot be empty!
; ------------------------------------------------------------

invalidFileText \
    dw 000Dh
    dw 000Ah
    dw 'F','i','l','e','n','a','m','e',' ','c','a','n','n','o','t',' '
    dw 'b','e',' ','e','m','p','t','y','!'
    dw 000Dh
    dw 000Ah
    dw 0000h


; ------------------------------------------------------------
; Input too long, please try again!
; ------------------------------------------------------------

tooLongText \
    dw 000Dh
    dw 000Ah
    dw 'I','n','p','u','t',' ','t','o','o',' ','l','o','n','g',',',' '
    dw 'p','l','e','a','s','e',' ','t','r','y',' ','a','g','a','i','n','!'
    dw 000Dh
    dw 000Ah
    dw 0000h


; ------------------------------------------------------------
; Output folder does not exist or is not accessible.
; ------------------------------------------------------------

folderInvalidText \
    dw 000Dh
    dw 000Ah
    dw 'O','u','t','p','u','t',' ','f','o','l','d','e','r',' '
    dw 'd','o','e','s',' ','n','o','t',' ','e','x','i','s','t',' '
    dw 'o','r',' ','i','s',' ','n','o','t',' ','a','c','c','e','s','s','i','b','l','e','.'
    dw 000Dh
    dw 000Ah
    dw 0000h


; ------------------------------------------------------------
; The specified path is not a folder.
; ------------------------------------------------------------

notFolderText \
    dw 000Dh
    dw 000Ah
    dw 'T','h','e',' ','s','p','e','c','i','f','i','e','d',' '
    dw 'p','a','t','h',' ','i','s',' ','n','o','t',' '
    dw 'a',' ','f','o','l','d','e','r','.'
    dw 000Dh
    dw 000Ah
    dw 0000h


; ------------------------------------------------------------
; Target path is a directory, not a file.
; ------------------------------------------------------------

directoryText \
    dw 000Dh
    dw 000Ah
    dw 'T','a','r','g','e','t',' ','p','a','t','h',' '
    dw 'i','s',' ','a',' ','d','i','r','e','c','t','o','r','y',',',' '
    dw 'n','o','t',' ','a',' ','f','i','l','e','.'
    dw 000Dh
    dw 000Ah
    dw 0000h


; ------------------------------------------------------------
; Checking:
; ------------------------------------------------------------

checkingText \
    dw 000Dh
    dw 000Ah
    dw 'C','h','e','c','k','i','n','g',':'
    dw 0000h


; ------------------------------------------------------------
; File not found yet, checking again in 60 seconds...
; ------------------------------------------------------------

notFoundText \
    dw 000Dh
    dw 000Ah
    dw 'F','i','l','e',' ','n','o','t',' ','f','o','u','n','d',' ','y','e','t',',',' '
    dw 'c','h','e','c','k','i','n','g',' ','a','g','a','i','n',' '
    dw 'i','n',' ','6','0',' ','s','e','c','o','n','d','s','.','.','.'
    dw 000Dh
    dw 000Ah
    dw 0000h


; ------------------------------------------------------------
; Target file found, shutting down in 60 seconds...
; ------------------------------------------------------------

foundText \
    dw 000Dh
    dw 000Ah
    dw 'T','a','r','g','e','t',' ','f','i','l','e',' ','f','o','u','n','d',',',' '
    dw 's','h','u','t','t','i','n','g',' ','d','o','w','n',' '
    dw 'i','n',' ','6','0',' ','s','e','c','o','n','d','s','.','.','.'
    dw 000Dh
    dw 000Ah
    dw 0000h
; ------------------------------------------------------------
; Press Enter to exit...
; ------------------------------------------------------------

exitText \
    dw 000Dh
    dw 000Ah

    dw 0050h       ; P
    dw 0072h       ; r
    dw 0065h       ; e
    dw 0073h       ; s
    dw 0073h       ; s
    dw 0020h
    dw 0045h       ; E
    dw 006Eh       ; n
    dw 0074h       ; t
    dw 0065h       ; e
    dw 0072h       ; r
    dw 0020h
    dw 0074h       ; t
    dw 006Fh       ; o
    dw 0020h
    dw 0065h       ; e
    dw 0078h       ; x
    dw 0069h       ; i
    dw 0074h       ; t
    dw 002Eh
    dw 002Eh
    dw 002Eh

    dw 000Dh
    dw 000Ah
    dw 0000h


; ------------------------------------------------------------
; shutdown.exe
; ------------------------------------------------------------

shellOpen \
    dw 006Fh       ; o
    dw 0070h       ; p
    dw 0065h       ; e
    dw 006Eh       ; n
    dw 0000h


shutdownExe \
    dw 0073h       ; s
    dw 0068h       ; h
    dw 0075h       ; u
    dw 0074h       ; t
    dw 0064h       ; d
    dw 006Fh       ; o
    dw 0077h       ; w
    dw 006Eh       ; n
    dw 002Eh       ; .
    dw 0065h       ; e
    dw 0078h       ; x
    dw 0065h       ; e
    dw 0000h


; ------------------------------------------------------------
; shutdown.exe /a
; ------------------------------------------------------------

cancelParams \
    dw 0020h
    dw 002Fh       ; /
    dw 0061h       ; a
    dw 0000h


; ------------------------------------------------------------
; shutdown.exe /s /t 60
; ------------------------------------------------------------

shutdownParams \
    dw 0020h
    dw 002Fh       ; /
    dw 0073h       ; s
    dw 0020h
    dw 002Fh       ; /
    dw 0074h       ; t
    dw 0020h
    dw 0036h       ; 6
    dw 0030h       ; 0
    dw 0000h


; ------------------------------------------------------------
; CRLF
; ------------------------------------------------------------

crlfText \
    dw 000Dh
    dw 000Ah
    dw 0000h


; ============================================================
; .data?
; ============================================================

.data?

oneChar         dw ?

hInput          dq ?
hOutput         dq ?

inputBuffer     dw MAX_INPUT_CHARS dup(?)

path            dw MAX_PATH_CHARS dup(?)
filename        dw MAX_PATH_CHARS dup(?)
fullpath        dw MAX_PATH_CHARS dup(?)

pathLength      dq ?
filenameLength  dq ?


; ============================================================
; .code
; ============================================================

.code


; ============================================================
; WriteString
; ============================================================

WriteString PROC

    push rbx

    mov rbx, rcx

    ; --------------------------------------------------------
    ; 计算 UTF-16 字符数量
    ; --------------------------------------------------------

    xor r8d, r8d

write_count_loop:

    cmp word ptr [rbx + r8*2], 0
    je write_count_done

    inc r8
    jmp write_count_loop


write_count_done:

    ; --------------------------------------------------------
    ; WriteConsoleW(
    ; --------------------------------------------------------

    mov rcx, hOutput
    mov rdx, rbx

    sub rsp, 30h

    lea r9, [rsp + 20h]

    mov qword ptr [rsp + 20h], 0

    call WriteConsoleW

    add rsp, 30h

    pop rbx

    ret

WriteString ENDP


; ============================================================
; ReadLineW
; ============================================================

ReadLineW PROC

    push rbx
    push rsi
    push rdi

    mov rbx, rcx
    mov rsi, rdx



    sub rsp, 30h


    ; --------------------------------------------------------
    ; ReadConsoleW(
    ;
    ;   hInput,
    ;   buffer,
    ;   capacity - 1,
    ;   &charsRead,
    ;   NULL
    ;
    ; )
    ; --------------------------------------------------------

    mov rcx, hInput
    mov rdx, rbx

    mov r8, rsi
    dec r8

    lea r9, [rsp + 20h]

    mov qword ptr [rsp + 20h], 0

    call ReadConsoleW




    test eax, eax
    jz readline_failed




    mov rdi, qword ptr [rsp + 20h]

    add rsp, 30h




    mov word ptr [rbx + rdi*2], 0




    xor edx, edx



    mov rcx, rsi
    dec rcx

    cmp rdi, rcx
    jne readline_trim




    test rdi, rdi
    jz readline_trim

    movzx eax, word ptr [rbx + rdi*2 - 2]

    cmp ax, 000Dh
    je readline_trim

    cmp ax, 000Ah
    je readline_trim




    call FlushConsoleLine

    mov edx, 1


readline_trim:


    mov rax, rdi


trim_loop:

    test rax, rax
    jz trim_done

    dec rax

    movzx ecx, word ptr [rbx + rax*2]

    cmp cx, 000Dh
    je trim_loop

    cmp cx, 000Ah
    je trim_loop

    inc rax


trim_done:



    mov word ptr [rbx + rax*2], 0

    jmp readline_done


readline_failed:

    add rsp, 30h

    xor eax, eax

    mov edx, 2


readline_done:

    pop rdi
    pop rsi
    pop rbx

    ret

ReadLineW ENDP


; ============================================================
; FlushConsoleLine
; ============================================================

FlushConsoleLine PROC

flush_loop:



    sub rsp, 28h

    mov rcx, hInput

    lea rdx, oneChar

    mov r8d, 1

    lea r9, [rsp + 20h]

    mov qword ptr [rsp + 20h], 0

    call ReadConsoleW

    add rsp, 28h




    test eax, eax
    jz flush_done



    movzx eax, word ptr [oneChar]

    cmp ax, 000Dh
    je flush_done

    cmp ax, 000Ah
    je flush_done

    jmp flush_loop


flush_done:

    ret

FlushConsoleLine ENDP


; ============================================================
; CopyStringW
; ============================================================

CopyStringW PROC

    push rbx
    push rsi

    mov rbx, rcx
    mov rsi, rdx

    xor rax, rax


copy_loop:

    mov cx, word ptr [rsi + rax*2]

    mov word ptr [rbx + rax*2], cx

    test cx, cx
    jz copy_done

    inc rax

    jmp copy_loop


copy_done:

    pop rsi
    pop rbx

    ret

CopyStringW ENDP


; ============================================================
; AppendStringW
; ============================================================

AppendStringW PROC

    push rbx
    push rsi
    push rdi

    mov rbx, rcx
    mov rsi, rdx

    ; --------------------------------------------------------
    ; destination 
    ; --------------------------------------------------------

    xor rax, rax


append_find_end:

    cmp word ptr [rbx + rax*2], 0
    je append_found_end

    inc rax

    jmp append_find_end


append_found_end:

    lea rdi, [rbx + rax*2]

    xor rdx, rdx


append_loop:

    mov cx, word ptr [rsi + rdx*2]

    mov word ptr [rdi + rdx*2], cx

    test cx, cx
    jz append_done

    inc rdx

    jmp append_loop


append_done:

    add rax, rdx

    pop rdi
    pop rsi
    pop rbx

    ret

AppendStringW ENDP


; ============================================================
; AppendBackslash
; ============================================================

AppendBackslash PROC

    push rbx

    mov rbx, rcx

    xor rax, rax


append_slash_find_end:

    cmp word ptr [rbx + rax*2], 0
    je append_slash_end

    inc rax

    jmp append_slash_find_end


append_slash_end:



    test rax, rax
    jz append_slash_add




    mov cx, word ptr [rbx + rax*2 - 2]

    cmp cx, 005Ch
    je append_slash_done


append_slash_add:

    mov word ptr [rbx + rax*2], 005Ch

    inc rax

    mov word ptr [rbx + rax*2], 0000h


append_slash_done:

    pop rbx

    ret

AppendBackslash ENDP


; ============================================================
; LaunchShutdown
; ============================================================

LaunchShutdown PROC

    mov r10, rcx




    sub rsp, 38h

    xor ecx, ecx

    lea rdx, shellOpen

    lea r8, shutdownExe

    mov r9, r10

    mov qword ptr [rsp + 20h], 0

    mov qword ptr [rsp + 28h], SW_HIDE

    call ShellExecuteW

    add rsp, 38h

    ret

LaunchShutdown ENDP


; ============================================================
; main
; ============================================================

main PROC



    sub rsp, 28h




    mov ecx, STD_INPUT_HANDLE

    call GetStdHandle

    mov hInput, rax




    mov ecx, STD_OUTPUT_HANDLE

    call GetStdHandle

    mov hOutput, rax


    ; ========================================================
    ; shutdown.exe /a
    ; ========================================================

    lea rcx, cancelParams

    call LaunchShutdown




input_path:

    lea rcx, promptPath

    call WriteString


    lea rcx, path

    mov edx, MAX_PATH_CHARS

    call ReadLineW


    ; --------------------------------------------------------
    ; ReadConsoleW 
    ; --------------------------------------------------------

    cmp edx, 2

    je input_error




    cmp edx, 1

    je path_too_long




    test eax, eax

    jz path_empty




    mov pathLength, rax

    jmp validate_folder


path_empty:

    lea rcx, invalidPathText

    call WriteString

    jmp input_path


path_too_long:

    lea rcx, tooLongText

    call WriteString

    jmp input_path



validate_folder:

    lea rcx, path

    call GetFileAttributesW




    cmp eax, INVALID_FILE_ATTRIBUTES

    je folder_invalid




    test eax, FILE_ATTRIBUTE_DIRECTORY

    jz folder_not_directory

    jmp input_filename


folder_invalid:

    lea rcx, folderInvalidText

    call WriteString

    jmp input_path


folder_not_directory:

    lea rcx, notFolderText

    call WriteString

    jmp input_path




input_filename:

    lea rcx, promptFile

    call WriteString


    lea rcx, filename

    mov edx, MAX_PATH_CHARS

    call ReadLineW




    cmp edx, 2

    je input_error


    cmp edx, 1

    je filename_too_long




    test eax, eax

    jz filename_empty



    mov filenameLength, rax

    jmp build_path


filename_empty:

    lea rcx, invalidFileText

    call WriteString

    jmp input_filename


filename_too_long:

    lea rcx, tooLongText

    call WriteString

    jmp input_filename




build_path:



    mov rax, pathLength

    add rax, 1

    add rax, filenameLength

    cmp rax, MAX_PATH_CHARS - 1

    ja full_path_too_long


    ; --------------------------------------------------------
    ; fullpath = path
    ; --------------------------------------------------------

    lea rcx, fullpath

    lea rdx, path

    call CopyStringW


    ; --------------------------------------------------------
    ; 添加 '\'
    ; --------------------------------------------------------

    lea rcx, fullpath

    call AppendBackslash


    ; --------------------------------------------------------
    ; 添加 filename
    ; --------------------------------------------------------

    lea rcx, fullpath

    lea rdx, filename

    call AppendStringW

    jmp show_path


full_path_too_long:

    lea rcx, tooLongText

    call WriteString

    jmp input_filename


show_path:

    lea rcx, checkingText

    call WriteString


    lea rcx, fullpath

    call WriteString


    lea rcx, crlfText

    call WriteString




check_loop:

    ; --------------------------------------------------------
    ; GetFileAttributesW(fullpath)
    ; --------------------------------------------------------

    lea rcx, fullpath

    call GetFileAttributesW


    ; --------------------------------------------------------
    ; INVALID_FILE_ATTRIBUTES
    ; --------------------------------------------------------

    cmp eax, INVALID_FILE_ATTRIBUTES

    je file_not_found



    test eax, FILE_ATTRIBUTE_DIRECTORY

    jnz target_is_directory



    lea rcx, foundText

    call WriteString


    ; ========================================================
    ; shutdown.exe /s /t 60
    ; ========================================================

    lea rcx, shutdownParams

    call LaunchShutdown



    cmp rax, 32

    jbe shutdown_failed


    jmp exit_program


target_is_directory:

    lea rcx, directoryText

    call WriteString

    jmp wait_and_check


file_not_found:

    lea rcx, notFoundText

    call WriteString



wait_and_check:

    mov ecx, 60000

    call Sleep

    jmp check_loop


; ============================================================
; shutdown.exe NO
; ============================================================

shutdown_failed:

    ; 这里直接退出，不再进入检测循环

    xor ecx, ecx

    call ExitProcess



input_error:

    xor ecx, ecx

    call ExitProcess


; ============================================================
; END
; ============================================================

exit_program:

    lea rcx, exitText

    call WriteString


    ; --------------------------------------------------------
    ; Enter
    ; --------------------------------------------------------

    lea rcx, inputBuffer

    mov edx, MAX_INPUT_CHARS

    call ReadLineW


    ; --------------------------------------------------------
    ; ExitProcess(0)
    ; --------------------------------------------------------

    xor ecx, ecx

    call ExitProcess

main ENDP


END
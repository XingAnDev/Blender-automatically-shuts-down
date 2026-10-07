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
;
; 519 个字符 + 1 个 NULL
;
MAX_PATH_CHARS EQU 520


; ============================================================
; .data
; ============================================================

.data


; ============================================================
; 中文提示字符串
;
; 全部使用 UTF-16 code unit
; ============================================================


; ------------------------------------------------------------
; 请输入 Blender 输出文件夹路径：
; ------------------------------------------------------------

promptPath \
    dw 8BF7h       ; 请
    dw 8F93h       ; 输
    dw 5165h       ; 入
    dw 0020h       ; 空格
    dw 0042h       ; B
    dw 006Ch       ; l
    dw 0065h       ; e
    dw 006Eh       ; n
    dw 0064h       ; d
    dw 0065h       ; e
    dw 0072h       ; r
    dw 0020h       ; 空格
    dw 8F93h       ; 输
    dw 51FAh       ; 出
    dw 6587h       ; 文
    dw 4EF6h       ; 件
    dw 5939h       ; 夹
    dw 8DEFh       ; 路
    dw 5F84h       ; 径
    dw 0FF1Ah       ; :
    dw 000Dh
    dw 000Ah
    dw 0000h


; ------------------------------------------------------------
; 请输入目标文件名：
; ------------------------------------------------------------

promptFile \
    dw 8BF7h       ; 请
    dw 8F93h       ; 输
    dw 5165h       ; 入
    dw 76EEh       ; 目
    dw 6807h       ; 标
    dw 6587h       ; 文
    dw 4EF6h       ; 件
    dw 540Dh       ; 名
    dw 0FF1Ah       ; ：
    dw 000Dh
    dw 000Ah
    dw 0000h


; ------------------------------------------------------------
; 路径不能为空！
; ------------------------------------------------------------

invalidPathText \
    dw 000Dh
    dw 000Ah
    dw 8DEFh       ; 路
    dw 5F84h       ; 径
    dw 4E0Dh       ; 不
    dw 80FDh       ; 能
    dw 4E3Ah       ; 为
    dw 7A7Ah       ; 空
    dw 0FF01h       ; ！
    dw 000Dh
    dw 000Ah
    dw 0000h


; ------------------------------------------------------------
; 文件名不能为空！
; ------------------------------------------------------------

invalidFileText \
    dw 000Dh
    dw 000Ah
    dw 6587h       ; 文
    dw 4EF6h       ; 件
    dw 540Dh       ; 名
    dw 4E0Dh       ; 不
    dw 80FDh       ; 能
    dw 4E3Ah       ; 为
    dw 7A7Ah       ; 空
    dw 0FF01h       ; ！
    dw 000Dh
    dw 000Ah
    dw 0000h


; ------------------------------------------------------------
; 输入过长，请重试！
; ------------------------------------------------------------

tooLongText \
    dw 000Dh
    dw 000Ah
    dw 8F93h       ; 输
    dw 5165h       ; 入
    dw 8FC7h       ; 过
    dw 957Fh       ; 长
    dw 0FF0Ch       ; ，
    dw 8BF7h       ; 请
    dw 91CDh       ; 重
    dw 8BD5h       ; 试
    dw 0FF01h       ; ！
    dw 000Dh
    dw 000Ah
    dw 0000h


; ------------------------------------------------------------
; 输出文件夹不存在或无法访问。
; ------------------------------------------------------------

folderInvalidText \
    dw 000Dh
    dw 000Ah

    dw 8F93h       ; 输
    dw 51FAh       ; 出
    dw 6587h       ; 文
    dw 4EF6h       ; 件
    dw 5939h       ; 夹
    dw 4E0Dh       ; 不
    dw 5B58h       ; 存
    dw 5728h       ; 在
    dw 6216h       ; 或
    dw 65E0h       ; 无
    dw 6CD5h       ; 法
    dw 8BBFh       ; 访
    dw 95EEh       ; 问
    dw 3002h       ; 。

    dw 000Dh
    dw 000Ah
    dw 0000h


; ------------------------------------------------------------
; 指定路径不是文件夹。
; ------------------------------------------------------------

notFolderText \
    dw 000Dh
    dw 000Ah

    dw 6307h       ; 指
    dw 5B9Ah       ; 定
    dw 8DEFh       ; 路
    dw 5F84h       ; 径
    dw 4E0Dh       ; 不
    dw 662Fh       ; 是
    dw 6587h       ; 文
    dw 4EF6h       ; 件
    dw 5939h       ; 夹
    dw 3002h       ; 。

    dw 000Dh
    dw 000Ah
    dw 0000h


; ------------------------------------------------------------
; 目标路径是一个目录，不是文件。
; ------------------------------------------------------------

directoryText \
    dw 000Dh
    dw 000Ah

    dw 76EEh       ; 目
    dw 6807h       ; 标
    dw 8DEFh       ; 路
    dw 5F84h       ; 径
    dw 662Fh       ; 是
    dw 4E00h       ; 一
    dw 4E2Ah       ; 个
    dw 76EEh       ; 目
    dw 5F55h       ; 录
    dw 0FF0Ch       ; ，
    dw 4E0Dh       ; 不
    dw 662Fh       ; 是
    dw 6587h       ; 文
    dw 4EF6h       ; 件
    dw 3002h       ; 。

    dw 000Dh
    dw 000Ah
    dw 0000h


; ------------------------------------------------------------
; 正在检测：
; ------------------------------------------------------------

checkingText \
    dw 000Dh
    dw 000Ah
    dw 6B63h       ; 正
    dw 5728h       ; 在
    dw 68C0h       ; 检
    dw 6D4Bh       ; 测
    dw 0FF1Ah       ; ：
    dw 0000h


; ------------------------------------------------------------
; 文件还不存在，60 秒后再次检查...
; ------------------------------------------------------------

notFoundText \
    dw 000Dh
    dw 000Ah

    dw 6587h       ; 文
    dw 4EF6h       ; 件
    dw 8FD8h       ; 还
    dw 4E0Dh       ; 不
    dw 5B58h       ; 存
    dw 5728h       ; 在
    dw 0FF0Ch       ; ，

    dw 0036h       ; 6
    dw 0030h       ; 0
    dw 0020h
    dw 79D2h       ; 秒
    dw 540Eh       ; 后
    dw 518Dh       ; 再
    dw 6B21h       ; 次
    dw 68C0h       ; 检
    dw 67E5h       ; 查

    dw 002Eh
    dw 002Eh
    dw 002Eh

    dw 000Dh
    dw 000Ah
    dw 0000h


; ------------------------------------------------------------
; 检测到目标文件，60 秒后关机...
; ------------------------------------------------------------

foundText \
    dw 000Dh
    dw 000Ah

    dw 68C0h       ; 检
    dw 6D4Bh       ; 测
    dw 5230h       ; 到
    dw 76EEh       ; 目
    dw 6807h       ; 标
    dw 6587h       ; 文
    dw 4EF6h       ; 件
    dw 0FF0Ch       ; ，

    dw 0036h
    dw 0030h
    dw 0020h
    dw 79D2h       ; 秒
    dw 540Eh       ; 后
    dw 5173h       ; 关
    dw 673Ah       ; 机

    dw 002Eh
    dw 002Eh
    dw 002Eh

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
;
; RCX = UTF-16 字符串
;
; 使用 WriteConsoleW 输出
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
    ;
    ;   hOutput,
    ;   buffer,
    ;   chars,
    ;   &charsWritten,
    ;   NULL
    ;
    ; )
    ;
    ; 这里需要：
    ;
    ; 20h = Shadow Space
    ; 08h = 第五参数
    ; 08h = 对齐
    ;
    ; 总计 30h
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
;
; RCX = 输入缓冲区
; RDX = 缓冲区容量（WCHAR 数量）
;
; 返回：
;
; RAX = 去掉 CR/LF 后的字符串长度
;
; RDX =
;   0 = 正常
;   1 = 输入过长
;   2 = ReadConsoleW 失败
; ============================================================

ReadLineW PROC

    push rbx
    push rsi
    push rdi

    mov rbx, rcx
    mov rsi, rdx

    ; --------------------------------------------------------
    ; 3 个 PUSH 后：
    ;
    ; RSP 已经变化 18h
    ;
    ; 这里分配 30h：
    ;
    ; 20h = Shadow Space
    ; 08h = 第五参数
    ; 08h = 对齐
    ;
    ; --------------------------------------------------------

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


    ; --------------------------------------------------------
    ; ReadConsoleW 返回 0 = 失败
    ; --------------------------------------------------------

    test eax, eax
    jz readline_failed


    ; --------------------------------------------------------
    ; 保存读取数量
    ; --------------------------------------------------------

    mov rdi, qword ptr [rsp + 20h]

    add rsp, 30h


    ; --------------------------------------------------------
    ; 添加 NULL
    ; --------------------------------------------------------

    mov word ptr [rbx + rdi*2], 0


    ; --------------------------------------------------------
    ; 默认状态 = 0
    ; --------------------------------------------------------

    xor edx, edx


    ; --------------------------------------------------------
    ; 判断是否把输入缓冲区填满
    ; --------------------------------------------------------

    mov rcx, rsi
    dec rcx

    cmp rdi, rcx
    jne readline_trim


    ; --------------------------------------------------------
    ; 如果最后一个字符是 CR/LF
    ; 那么实际上没有溢出
    ; --------------------------------------------------------

    test rdi, rdi
    jz readline_trim

    movzx eax, word ptr [rbx + rdi*2 - 2]

    cmp ax, 000Dh
    je readline_trim

    cmp ax, 000Ah
    je readline_trim


    ; --------------------------------------------------------
    ; 没有遇到换行
    ;
    ; 说明这一行还有剩余字符
    ; --------------------------------------------------------

    call FlushConsoleLine

    mov edx, 1


readline_trim:

    ; --------------------------------------------------------
    ; RAX = 原始读取长度
    ; --------------------------------------------------------

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

    ; --------------------------------------------------------
    ; 新的字符串结尾
    ; --------------------------------------------------------

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
;
; 将超长输入剩余部分读掉
; 直到 CR / LF
; ============================================================

FlushConsoleLine PROC

flush_loop:

    ; --------------------------------------------------------
    ; 本函数没有 PUSH
    ;
    ; 入口栈状态下直接分配 28h：
    ;
    ; 20h = Shadow Space
    ; 08h = 第五参数
    ;
    ; 同时保持调用前栈对齐
    ; --------------------------------------------------------

    sub rsp, 28h

    mov rcx, hInput

    lea rdx, oneChar

    mov r8d, 1

    lea r9, [rsp + 20h]

    mov qword ptr [rsp + 20h], 0

    call ReadConsoleW

    add rsp, 28h


    ; --------------------------------------------------------
    ; ReadConsoleW 失败
    ; --------------------------------------------------------

    test eax, eax
    jz flush_done


    ; --------------------------------------------------------
    ; 读取字符
    ; --------------------------------------------------------

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
;
; RCX = destination
; RDX = source
;
; 返回：
; RAX = 字符数量，不包含 NULL
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
;
; RCX = destination
; RDX = source
;
; destination += source
;
; RAX = 最终长度
; ============================================================

AppendStringW PROC

    push rbx
    push rsi
    push rdi

    mov rbx, rcx
    mov rsi, rdx

    ; --------------------------------------------------------
    ; 找 destination 结尾
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
;
; RCX = 路径
;
; 如果最后没有 '\'，添加 '\'
;
; RAX = 最终长度
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

    ; --------------------------------------------------------
    ; 空字符串
    ; --------------------------------------------------------

    test rax, rax
    jz append_slash_add


    ; --------------------------------------------------------
    ; 检查最后一个字符
    ; --------------------------------------------------------

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
;
; RCX = shutdown.exe 参数
;
; ShellExecuteW(
;
;     NULL,
;     L"open",
;     L"shutdown.exe",
;     参数,
;     NULL,
;     SW_HIDE
;
; )
;
; RAX = ShellExecuteW 返回值
; ============================================================

LaunchShutdown PROC

    mov r10, rcx

    ; --------------------------------------------------------
    ; 6 个参数
    ;
    ; RCX = hwnd
    ; RDX = operation
    ; R8  = file
    ; R9  = parameters
    ;
    ; [RSP+20h] = directory
    ; [RSP+28h] = nShowCmd
    ;
    ; 20h Shadow Space
    ; 10h 两个栈参数
    ; 08h 对齐
    ;
    ; = 38h
    ; --------------------------------------------------------

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

    ; --------------------------------------------------------
    ; Shadow Space + 对齐
    ; --------------------------------------------------------

    sub rsp, 28h


    ; ========================================================
    ; 获取标准输入
    ; ========================================================

    mov ecx, STD_INPUT_HANDLE

    call GetStdHandle

    mov hInput, rax


    ; ========================================================
    ; 获取标准输出
    ; ========================================================

    mov ecx, STD_OUTPUT_HANDLE

    call GetStdHandle

    mov hOutput, rax


    ; ========================================================
    ; 启动时取消之前的关机倒计时
    ;
    ; shutdown.exe /a
    ; ========================================================

    lea rcx, cancelParams

    call LaunchShutdown


    ; ========================================================
    ; 输入输出文件夹
    ; ========================================================

input_path:

    lea rcx, promptPath

    call WriteString


    lea rcx, path

    mov edx, MAX_PATH_CHARS

    call ReadLineW


    ; --------------------------------------------------------
    ; ReadConsoleW 失败
    ; --------------------------------------------------------

    cmp edx, 2

    je input_error


    ; --------------------------------------------------------
    ; 输入过长
    ; --------------------------------------------------------

    cmp edx, 1

    je path_too_long


    ; --------------------------------------------------------
    ; 空路径
    ; --------------------------------------------------------

    test eax, eax

    jz path_empty


    ; --------------------------------------------------------
    ; 保存路径长度
    ; --------------------------------------------------------

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


; ============================================================
; 检查输出文件夹
; ============================================================

validate_folder:

    lea rcx, path

    call GetFileAttributesW


    ; --------------------------------------------------------
    ; 文件夹不存在 / 无法访问
    ; --------------------------------------------------------

    cmp eax, INVALID_FILE_ATTRIBUTES

    je folder_invalid


    ; --------------------------------------------------------
    ; 输入路径不是目录
    ; --------------------------------------------------------

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


; ============================================================
; 输入目标文件名
; ============================================================

input_filename:

    lea rcx, promptFile

    call WriteString


    lea rcx, filename

    mov edx, MAX_PATH_CHARS

    call ReadLineW


    ; --------------------------------------------------------
    ; 输入失败
    ; --------------------------------------------------------

    cmp edx, 2

    je input_error


    ; --------------------------------------------------------
    ; 输入过长
    ; --------------------------------------------------------

    cmp edx, 1

    je filename_too_long


    ; --------------------------------------------------------
    ; 空文件名
    ; --------------------------------------------------------

    test eax, eax

    jz filename_empty


    ; --------------------------------------------------------
    ; 保存文件名长度
    ; --------------------------------------------------------

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


; ============================================================
; 构造完整路径
;
; fullpath = path + "\" + filename
; ============================================================

build_path:

    ; --------------------------------------------------------
    ; 检查最终长度
    ;
    ; pathLength
    ; + "\"（最多 1）
    ; + filenameLength
    ; + NULL
    ;
    ; 必须 <= MAX_PATH_CHARS
    ; --------------------------------------------------------

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


; ============================================================
; 显示正在检测的路径
; ============================================================

show_path:

    lea rcx, checkingText

    call WriteString


    lea rcx, fullpath

    call WriteString


    lea rcx, crlfText

    call WriteString


; ============================================================
; 检测循环
; ============================================================

check_loop:

    ; --------------------------------------------------------
    ; GetFileAttributesW(fullpath)
    ; --------------------------------------------------------

    lea rcx, fullpath

    call GetFileAttributesW


    ; --------------------------------------------------------
    ; INVALID_FILE_ATTRIBUTES
    ;
    ; 目标文件不存在
    ; --------------------------------------------------------

    cmp eax, INVALID_FILE_ATTRIBUTES

    je file_not_found


    ; --------------------------------------------------------
    ; 如果目标路径本身是目录
    ; --------------------------------------------------------

    test eax, FILE_ATTRIBUTE_DIRECTORY

    jnz target_is_directory


    ; ========================================================
    ; 找到目标文件
    ; ========================================================

    lea rcx, foundText

    call WriteString


    ; ========================================================
    ; shutdown.exe /s /t 60
    ; ========================================================

    lea rcx, shutdownParams

    call LaunchShutdown


    ; --------------------------------------------------------
    ; ShellExecuteW 返回值 <= 32 表示失败
    ; --------------------------------------------------------

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


; ============================================================
; 等待 60 秒
; ============================================================

wait_and_check:

    mov ecx, 60000

    call Sleep

    jmp check_loop


; ============================================================
; shutdown.exe 启动失败
; ============================================================

shutdown_failed:

    ; 这里直接退出，不再进入检测循环

    xor ecx, ecx

    call ExitProcess


; ============================================================
; 输入设备错误
; ============================================================

input_error:

    xor ecx, ecx

    call ExitProcess


; ============================================================
; 程序结束
; ============================================================

exit_program:

    lea rcx, exitText

    call WriteString


    ; --------------------------------------------------------
    ; 等待用户按 Enter
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
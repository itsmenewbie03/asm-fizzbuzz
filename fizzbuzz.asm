.intel_syntax noprefix
.global main

.section .text

main:
  push rbp
  mov rbp, rsp
  sub rsp, 128
  
  mov rax, 0x01
  mov rdi, 0x01
  lea rsi, [rip + prompt]
  mov rdx, 16
  syscall

  mov rax, 0x00
  mov rdi, 0x00
  lea rsi, [rip + buf]
  mov rdx, 0xFF
  syscall
  
  lea rdi, [rip + buf]
  call atoi
  
  mov DWORD PTR [rbp-4], 1 
  mov DWORD PTR [rbp-8], eax
  
my_loop:
  mov ebx, DWORD PTR [rbp-4]
  mov ecx, 3
  mov eax, ebx
  cdq
  div ecx
  mov DWORD PTR [rbp-16], edx # MOD 3 res

  
  mov ebx, DWORD PTR [rbp-4]
  mov ecx, 5
  mov eax, ebx
  cdq
  div ecx
  mov DWORD PTR [rbp-32], edx # MOD 5 res

  # Check for Fizz
  cmp DWORD PTR [rbp-16], 0
  jne not_fizz_con
  call fizz
  mov DWORD PTR [rbp-64], 1
  
not_fizz_con:
  # Check for Buzz
  cmp DWORD PTR [rbp-32], 0
  jne not_buzz_con
  call buzz
  mov DWORD PTR [rbp-64], 1
  
not_buzz_con:
  cmp DWORD PTR [rbp-64], 1
  je continue
  
  lea rdi, [rip + int_fmt]
  mov eax, DWORD PTR [rbp-4]
  mov esi, eax
  mov eax, 0
  call printf
  
continue:  
  mov DWORD PTR [rbp-64], 0
  add DWORD PTR [rbp-4], 1
  mov eax, DWORD PTR [rbp-8]
  cmp DWORD PTR [rbp-4], eax
  jg end
  jmp my_loop
  
end:
  mov rax, 0x3c
  mov rdi, 0x00
  syscall

fizz:
  mov rax, 0x01
  mov rdi, 0x01
  lea rsi, [rip + _fizz]
  # HACK: we will not print the newline if MOD 5 is 0
  cmp DWORD PTR [rbp-32], 0
  je no_newline
  mov rdx, 5
  syscall
  ret

no_newline:
  mov rdx, 4
  syscall
  ret
  
buzz:
  mov rax, 0x01
  mov rdi, 0x01
  lea rsi, [rip + _buzz]
  mov rdx, 5
  syscall
  ret
  
.section .data
  fmt: .asciz "Hello, World [%2d]\n"
  int_fmt: .asciz "%d\n"
  prompt: .asciz "Enter a Number: "
  _fizz: .asciz "Fizz\n"
  _buzz: .asciz "Buzz\n"

.section .bss
  buf: .space 255

include Irvine32.inc

.data
array dword 9 * 9 DUP (0)

partial dword 9 * 9 DUP(0)

manual dword 9 * 9 DUP(0)

solved_array dword 9 * 9 DUP (?)

i dword 0
j dword 0

spa db " ",0

choice BYTE "Choose a Mode (1 for Easy, 2 for Medium and 3 for Hard): ", 0

Incorrect BYTE "Input is WRONG! ", 0
Works BYTE "YAYYYY!!!", 0

Bestie BYTE "Enter Position for x (Row from 1-9): ", 0
Slay BYTE "Enter Position for y (Column from 1-9): ", 0
Queen BYTE "Enter Number to store (1-9): ", 0

seven BYTE "ADDEDEDEDEDED!", 0

dashingBoi BYTE "---------------------", 0
columnBar BYTE "| ", 0

ROCK BYTE "--- HARD DIFFICULTY ---", 0
YAOI BYTE "--- EASY DIFFICULTY ---", 0
YURI BYTE "-- MEDIUM DIFFICULTY --", 0

draco BYTE "Number entered was Incorrect. Retry!", 0

errorRowMsg BYTE "WOAAAAAAAHHHH There is an error in Row: ",0
errorColMsg BYTE "WOAAAAAAAHHHH There is an error in Column: ",0
doneMsg BYTE "GG! Puzzle solved in Medium Mode!",0
doneMsgE BYTE "GG! Puzzle solved in Easy Mode!",0
doneMsgH BYTE "GG! Puzzle solved in Hard Mode!",0

score SDWORD 0              
currMode DWORD 0            ; 1=Easy, 2=Medium, 3=Hard
txtScore BYTE "Current frfr: ", 0
txtPts byte " Points", 0
finalScoreMsg BYTE "Total Score: ", 0

Replay BYTE "Do You Wish to Replay? Y/N", 0

Stoner BYTE 2 DUP(?)


.code
main PROC

swig:
    mov eax, 0
    mov ebx, 0
    mov edx, 0
    mov ecx, 0
    mov esi, 0

    push esi
    push ecx
    push edx
    push ebx
    push eax

    call Randomize
    
    mov eax, 13
    call RandomRange
    add eax, 12
    mov ecx, eax
    mov eax, 0

idk:

    mov eax, 9
    call RandomRange

    mov ebx, eax    ; x

    mov eax, 9
    call RandomRange

    mov esi, eax    ;y

    mov edx, OFFSET array

    mov eax, 9

    call RandomRange

    inc eax     ;Number

    push eax    ;Number in stack

    mov eax, 0

    mov eax, ebx

    mov ebx, 0

    mov ebx, 9
    
    mul ebx

    add eax, esi

    pop esi

    mov DWORD PTR array[eax*4], esi
    mov DWORD PTR partial[eax*4], esi
    mov DWORD PTR manual[eax*4], esi

    loop idk
    pop eax
    pop ebx
    pop edx
    pop ecx
    pop esi

push ecx
push edi
push esi
push ebx
push edx

mov i,0
mov j,0

mov ecx,9
mov ebx,0

ghumado1:
    mov ebx,ecx
    mov ecx,9
    mov j,0
        
        ghumado2:
            mov esi,i
            imul esi,9
            add esi,j
            mov edx,offset array
            mov edi,[edx + esi*4]

            cmp edi,0
            je inc_j

            push edi
            push j
            push i
            push offset array
            call bubba
            cmp eax,0
            je GENERATE_NEW_ARRAY
inc_j:
            inc j

            loop ghumado2

            mov ecx,ebx
            inc i

            loop ghumado1
            
            
        pop edx
        pop ebx
        pop esi
        pop edi
        pop ecx

mov j,0
mov i,0

push j
push i
push offset array

array_check:
call Solve
cmp eax,1
je store_array
    
GENERATE_NEW_ARRAY:
    mov ecx, 81
    mov edx, OFFSET array
    mov eax, 0
dang:
    mov DWORD PTR array[eax*4], 0
    mov DWORD PTR partial[eax*4], 0
    mov DWORD PTR manual[eax*4], 0
    inc eax
    loop dang
    mov eax, 0
    jmp swig

    store_array:
        
        mov ecx,81
        mov esi,offset array
        mov edi,offset solved_array

        s1:
            mov eax,[esi]
            mov [edi],eax

            add esi,4
            add edi,4

        loop s1
        

e:
    mov edx, OFFSET choice
    call writeString

    call readInt

    cmp eax, 1
    je Easy
    cmp eax, 2
    je Medium
    cmp eax, 3
    je Hard

    mov edx, OFFSET Incorrect
    call writeString
    jmp e

Easy:
    mov currMode, 1
    mov edx, OFFSET Works
    call writeString
    call EasyShi
    jmp ikhtitam


Medium:
    mov currMode, 2
    mov edx, OFFSET Works
    call writeString
    call MediumShi
    jmp ikhtitam

Hard:
    
    mov currMode, 3
    mov edx, OFFSET Works
    call writeString
    call HardShi
    jmp ikhtitam

ikhtitam:

mov edx, OFFSET Replay
call writeString

mov eax, 0

call readChar

mov Stoner, al

cmp Stoner, "Y"
je swig

call crlf
cmp Stoner, "N"
jne ikhtitam


call exitprocess
main ENDP

;----------------------------------------------
; Score Implementation
;----------------------------------------------

UpdateScore Proc uses eax ebx ecx edx esi edi
;ebx = index
;esi = input val

cmp esi, 0
je Finish_score

mov edi, solved_array[ebx*4]
cmp esi, edi
je correct

    cmp currMode, 1
    je  Mode_Easy_Wrong
    
    cmp currMode, 2
    je  Mode_Med_Wrong
    
    cmp currMode, 3
    je  Mode_Hard_Wrong
    
Mode_Easy_Wrong:
    sub score, 3
    jmp Check_Zero

Mode_Med_Wrong:
    sub score, 5
    jmp Check_Zero

Mode_Hard_Wrong:
    sub score, 10
    jmp Check_Zero

correct:
    add score, 20
    jmp Finish_score

Check_Zero:
    cmp score, 0
    jge Finish_score
    mov score, 0

Finish_score:
    ret

UpdateScore ENDP

;_________________________________________________
bubba PROC
;_________________________________________________

push ebp
mov ebp,esp

push ecx
push edi
push esi
push ebx
push edx

sub esp,16


mov ecx,9
mov ebx,0

l11:
    cmp ebx,[ebp+12]
    je row_inc

    mov edi,ebx
    imul edi,9
    add edi,[ebp+16]
    mov edx,[ebp+8]
    mov eax,[edx+ edi*4]


    cmp eax,[ebp+20]
    je r_false1

row_inc:
    inc ebx

    loop l11


mov ecx,9
mov ebx,0

l22:
    cmp ebx,[ebp+16]
    je col_inc

    mov edi,[ebp+12]
    imul edi,9
    add edi,ebx
    mov edx,[ebp+8]
    mov eax,[edx + edi*4]

    cmp eax,[ebp+20]
    je r_false1

col_inc:
    inc ebx

    loop l22


mov eax,[ebp+12]
cdq
mov ecx,3
idiv ecx
mov esi,[ebp+12]
sub esi,edx
mov [ebp-4-20],esi
mov [ebp-12-20],esi

mov eax,[ebp+16]
cdq
mov ecx,3
idiv ecx
mov esi,[ebp+16]
sub esi,edx
mov [ebp-8-20],esi
mov [ebp-16-20],esi


outer1_loop:
    mov eax,[ebp-12-20]
    add eax,3
    cmp [ebp-4-20],eax
    jge done1
    mov eax,[ebp-16-20]
    mov [ebp-8-20],eax

    inner1_loop:
        mov eax,[ebp-16-20]
        add eax,3
        cmp [ebp-8-20],eax
        jge o_incr1

        mov eax,[ebp+12]
        cmp eax,[ebp-4-20]
        jne eheh
        
        mov eax,[ebp+16]
        cmp eax,[ebp-8-20]
        je incr1

        eheh:
        mov edi,[ebp-4-20]
        imul edi,9
        add edi,[ebp-8-20]
        mov edx,[ebp+8]
        mov eax,[edx + edi*4]

        cmp [ebp + 20],eax
        je r_false1

        incr1:
        inc dword ptr [ebp-8-20]
        jmp inner1_loop

    o_incr1:
        inc dword ptr [ebp-4-20]
        jmp outer1_loop


    r_false1:
        mov eax,0

        add esp,16
        pop edx
        pop ebx
        pop esi
        pop edi
        pop ecx

        mov esp,ebp
        pop ebp
        ret 16
    done1:
        mov eax,1

        add esp,16
        pop edx
        pop ebx
        pop esi
        pop edi
        pop ecx

        mov esp,ebp
        pop ebp
        ret 16

;_________________________________________________________
bubba ENDP
;_________________________________________________________

;_________________________________________________________
valid PROC
;_________________________________________________________

push ebp
mov ebp,esp

push ecx
push edi
push esi
push ebx
push edx

sub esp,16


mov ecx,9
mov ebx,0

l1:
    mov edi,ebx
    imul edi,9
    add edi,[ebp+16]
    mov edx,[ebp+8]
    mov eax,[edx+ edi*4]

    cmp eax,[ebp+20]
    je r_false
    inc ebx

    loop l1


mov ecx,9
mov ebx,0

l2:
    mov edi,[ebp+12]
    imul edi,9
    add edi,ebx
    mov edx,[ebp+8]
    mov eax,[edx + edi*4]

    cmp eax,[ebp+20]
    je r_false

    inc ebx

    loop l2


mov eax,[ebp+12]
cdq
mov ecx,3
idiv ecx
mov esi,[ebp+12]
sub esi,edx
mov [ebp-4-20],esi
mov [ebp-12-20],esi

mov eax,[ebp+16]
cdq
mov ecx,3
idiv ecx
mov esi,[ebp+16]
sub esi,edx
mov [ebp-8-20],esi
mov [ebp-16-20],esi


outer_loop:
    mov eax,[ebp-12-20]
    add eax,3
    cmp [ebp-4-20],eax
    jge done
    mov eax,[ebp-16-20]
    mov [ebp-8-20],eax

    inner_loop:
        mov eax,[ebp-16-20]
        add eax,3
        cmp [ebp-8-20],eax
        jge o_incr


        mov edi,[ebp-4-20]
        imul edi,9
        add edi,[ebp-8-20]
        mov edx,[ebp+8]
        mov eax,[edx + edi*4]

        cmp [ebp + 20],eax
        je r_false

        incr:
        inc dword ptr [ebp-8-20]
        jmp inner_loop

    o_incr:
        inc dword ptr [ebp-4-20]
        jmp outer_loop


    r_false:
        mov eax,0

        add esp,16
        pop edx
        pop ebx
        pop esi
        pop edi

        mov esp,ebp
        pop ebp
        ret 16
    done:
        mov eax,1

        add esp,16
        pop edx
        pop ebx
        pop esi
        pop edi
        pop ecx


        mov esp,ebp
        pop ebp
        ret 16

valid ENDP

;----------------------------------------------
; to compute arr[i][j] we do [array offset + (i*9 + j)] * 4
; because our array is 1d
;----------------------------------------------

Solve PROC
    push ebp
    mov ebp, esp

    push ecx
    push edi
    push esi
    push ebx
    push edx


    ; Arguments:
    ; [ebp+8]  = arr (pointer)
    ; [ebp+12] = i
    ; [ebp+16] = j

    mov eax, [ebp+12]      
    cmp eax, 9
    jl check_j
    mov eax, 1             
    jmp done

check_j:
    mov eax, [ebp+16]      
    cmp eax, 9
    jl check_cell
    ; j >= 9 ? next row
    mov ecx, [ebp+8]       
    mov edx, [ebp+12]       
    inc edx
    push 0                  
    push edx               
    push ecx             
    call Solve
    jmp done


check_cell:
    ; compute &arr[i][j]
    mov eax, [ebp+12]      
    imul eax, 9
    add eax, [ebp+16]     
    mov ecx, [ebp+8]
    lea edx, [ecx + eax*4]
    mov eax, [edx]
    cmp eax, 0
    je try_numbers         
    ; else move to next column
    mov ecx, [ebp+8]
    mov edx, [ebp+12]
    mov eax, [ebp+16]
    inc eax
    push eax               
    push edx              
    push ecx              
    call Solve
    jmp done

try_numbers:
    mov esi, 1              

for_loop:
    cmp esi, 10
    jge return_false

    ; valid(arr, i, j, x)
    push esi
    push [ebp+16]          
    push [ebp+12]           
    push [ebp+8]          
    call valid
    cmp eax, 0
    je next_x

    ; arr[i][j] = x
    mov eax, [ebp+12]
    imul eax, 9
    add eax, [ebp+16]
    mov ecx, [ebp+8]
    lea edx, [ecx + eax*4]
    mov eax, esi
    mov [edx], eax

    ; call Solve(i, j+1)
    mov ecx, [ebp+8]
    mov edx, [ebp+12]
    mov eax, [ebp+16]
    inc eax
    push eax
    push edx
    push ecx
    call Solve
    cmp eax, 0
    je reset_cell
    mov eax, 1
    jmp done

reset_cell:
    ; backtrack
    mov eax, [ebp+12]
    imul eax, 9
    add eax, [ebp+16]
    mov ecx, [ebp+8]
    lea edx, [ecx + eax*4]
    mov dword ptr [edx], 0

next_x:
    inc esi
    jmp for_loop

return_false:
    mov eax,0

done:

        pop edx
        pop ebx
        pop esi
        pop edi
        pop ecx

    mov esp, ebp
    pop ebp
    ret 12

;_________________________________________________________
Solve ENDP
;_________________________________________________________


;_________________________________________________________
TakeInput PROC
;_________________________________________________________
gng:
    mov edx, OFFSET Bestie
    call writeString
    call ReadInt
    cmp eax, 9
    ja gng
    cmp eax, 1
    jl gng
    dec eax
    mov ebx, eax
    

gn:
    mov edx, OFFSET Slay
    call writeString
    call ReadInt
    cmp eax, 9
    ja gn
    cmp eax, 1
    jl gn
    dec eax
    mov ecx, eax
    

g:
    mov edx, OFFSET Queen
    call writeString

    call ReadInt
    cmp eax, 9
    ja g
    cmp eax, 1
    jl g
    mov esi, eax

    imul ebx, 9
    add ebx, ecx

    cmp DWORD PTR partial[ebx*4], 0
    jne gng
    
    mov eax, DWORD PTR manual[ebx*4]
    cmp eax, esi
    je SkipScoreUpdate

    mov edx, DWORD PTR manual[ebx*4]
    mov DWORD PTR manual[ebx*4], esi
    call UpdateScore

SkipScoreUpdate:
    ret

;_________________________________________________________
TakeInput ENDP
;_________________________________________________________

;_________________________________________________________
CompareArrays PROC
;_________________________________________________________
    push ebp
    mov  ebp, esp

    push edi
    push esi
    push ebx
    mov eax, [ebp+16]  
    cmp eax, 81
    jne check_val3

    mov eax, 1          
    jmp don

check_val3:

    mov esi, [ebp+8]    
    mov edi, [ebp+12]   
    mov ebx, [ebp+16]   

    imul ebx, 4         
    mov eax, [esi + ebx]
    mov edx, [edi + ebx]

    cmp eax, edx
    jne not_equal6      

    mov eax, [ebp+16]
    inc eax             
    push eax            
    push [ebp+12]       
    push [ebp+8]        

    call CompareArrays
    jmp don

not_equal6:
    mov eax, 0

don:
    pop ebx
    pop esi
    pop edi

    mov esp, ebp
    pop ebp
    ret 12

;_________________________________________________________
CompareArrays ENDP
;_________________________________________________________


;_________________________________________________________
PrinterKiDukan PROC
;_________________________________________________________

    mov edx, OFFSET txtScore
    call WriteString
    mov eax, score              
    call WriteInt               
    mov edx, OFFSET txtPts      
    call WriteString
    call Crlf

    mov edx, OFFSET dashingBoi
    call writeString
    call crlf

    mov esi, OFFSET manual      
    mov ecx, 9                  
    mov edi, 0                  

RowLoop:
    mov ebx, 0                  

ColLoop:
    mov eax, [esi]
    call WriteDec

    mov edx, OFFSET spa
    call WriteString

    add esi, 4                  
    inc ebx                     
    cmp ebx, 3
    je PrintB
    cmp ebx, 6
    je PrintB
    jmp SkipB

PrintB:
    mov edx, OFFSET columnBar
    call WriteString
SkipB:

    cmp ebx, 9
    jne ColLoop

    call Crlf

    inc edi                     
    cmp edi, 3
    je PrintD
    cmp edi, 6
    je PrintD
    jmp SkipD

PrintD:
    mov edx, OFFSET dashingBoi
    call WriteString
    call Crlf

SkipD:
    loop RowLoop
    mov edx, OFFSET dashingBoi
    call writeString
    call crlf

    ret

;_________________________________________________________
PrinterKiDukan ENDP
;_________________________________________________________

;----------------------------------------------
; HardShi Implementation
;----------------------------------------------

HardShi PROC
    call ClrScr 
whiler:    
    mov edx, OFFSET ROCK
    call writeString
    call crlf
    call PrinterKiDukan
    call TakeInput
    push 0          
    push offset manual
    push offset solved_array
    call CompareArrays

    cmp eax, 1
    call clrscr
    jne whiler

    mov edx, offset doneMsgH
    call writestring
    call crlf
    mov edx, OFFSET finalScoreMsg
    call WriteString
    mov eax, score
    call WriteInt
    call Crlf
    ret

;_________________________________________________________
HardShi ENDP
;_________________________________________________________


;----------------------------------------------
; EasyShi Implementation
;----------------------------------------------

EasyShi PROC
    call ClrScr
YEAT:
    mov edx, OFFSET YAOI
    call writeString
    call crlf
    call PrinterKiDukan
    call TakeInput
    mov eax, 0
    call EHints
    cmp  eax, 1
    jne  skipper

    mov  edx, OFFSET draco
    call WriteString
    call Crlf
    mov  eax, 2000
    call Delay
    call clrscr

skipper:
    push 0
    push offset manual
    push offset solved_array
    call CompareArrays
    call clrscr

    cmp eax, 1
    jne YEAT

    mov edx, offset doneMsgE
    call writestring
    call crlf
    mov edx, OFFSET finalScoreMsg
    call WriteString
    mov eax, score
    call WriteInt
    call Crlf
    ret
EasyShi ENDP
;_________________________________________________________


;_________________________________________________________
EHints PROC
;_________________________________________________________
       push ebp
    mov  ebp, esp
    push esi
    push edi
    push ebx

    mov  esi, OFFSET manual
    mov  edi, OFFSET solved_array
    mov  ecx, 81

CheckLoop:
    cmp dword ptr [esi], 0
    je CorrectValue
    cmp eax, 1
    je outsider
    mov  ebx, [esi]
    cmp  ebx, [edi]
    je   CorrectValue
    mov  dword ptr [esi], edx
    mov  eax, 1  

CorrectValue:
    cmp eax, 1
    je outsider
    add  esi, 4
    add  edi, 4
    loop CheckLoop

outsider:
    pop  ebx
    pop  edi
    pop  esi
    pop  ebp
    ret
EHints ENDP

;----------------------------------------------
; MediumShi Implementation
;----------------------------------------------

R_hint Proc

    push ebp
    mov ebp, esp
    push esi
    push edi
    push ebx
    push ecx
    push edx

    mov ebx, 0                 
    mov ecx, 9 

row_loop:

    push ecx
    mov esi, OFFSET manual
    mov edi, OFFSET solved_array

    mov eax, ebx
    imul eax, 36           
    add esi, eax
    add edi, eax

    mov ecx, 9
    mov edx, 1              

check_Row_full:        
        cmp Dword ptr [esi], 0
        je not_full
        add esi, 4
loop check_Row_full
    
    mov edx, 1
    jmp correctness_check

not_full:
    mov edx, 0

correctness_check:
        pop ecx
        cmp edx, 0
        je skip_correctness_check

        push ebx
        push ecx

        mov esi, OFFSET manual
        mov edi, OFFSET solved_array
        mov eax, ebx
        imul eax, 36

        add esi, eax
        add edi, eax

        mov ecx, 9

col_loop_r:

    mov eax, [esi]
    cmp eax, [edi]
    jne wrongRow_r

    add esi, 4
    add edi, 4
    loop col_loop_r
    
    pop ecx                       
    pop ebx                       

skip_correctness_check:
    
    inc ebx                        
    loop row_loop

    mov eax, 0                      
    jmp done_R

wrongRow_r:
    pop ecx
    pop ebx

    mov eax, ebx
    inc eax                        
    jmp done_R

done_R:
    pop edx
    pop ecx
    pop ebx
    pop edi
    pop esi
    mov esp, ebp
    pop ebp
ret
R_hint Endp

;_________________________________________________________
CHints PROC
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ebx
    push ecx
    push edx

    mov ebx, 0                 
    mov ecx, 9                  

col_loop1:
    push ecx
    push ebx

    mov ecx, 9
    mov edx, 1                  
    mov eax, 0                  
    mov esi, offset manual     

    col_full_check:

        mov edi, eax               
        imul edi, 9                
        add edi, ebx                ; row*9+col

        ;fullness check
        cmp DWORD ptr [esi + edi*4], 0          
        je not_full_c                           
        inc eax                                

    loop col_full_check

    mov edx, 1
    jmp Col_correct_check       ; Jump to check, skipping not_full_c

    not_full_c:
    mov edx, 0

        Col_correct_check:
        pop ebx
        pop ecx

        cmp edx, 0
        je skip_correct_C

        ;check after validating column is full
        push ecx                    
        mov ecx, 9                  
        mov eax, 0                  

            col_loop2:
            mov edi, eax
            imul edi, 9
            add edi, ebx            

            mov edx, manual[edi*4]
            cmp edx, solved_array[edi*4]
            jne wrongCol
            inc eax
            loop col_loop2

        pop ecx

    skip_correct_C:
        inc ebx     ;next col
        loop col_loop1

        mov eax, 0          
        jmp done_c

    wrongCol:
    pop ecx
    
    mov eax, ebx
    inc eax
    jmp done_c

done_c:    
    pop edx
    pop ecx
    pop ebx
    pop edi
    pop esi
    mov esp, ebp
    pop ebp
ret
CHints endp
;_________________________________________________________



MHints proc
push ebp
mov ebp, esp

    push ebx
    push ecx
    push edx

    call R_hint
    cmp eax,0
    je check_cols

    push eax
    mov edx, offset errorRowMsg
    call WriteString
    pop eax
    call WriteDec
    call Crlf
    mov eax, 3000
    call delay
    jmp pappu

    check_cols:
    call Chints
    cmp eax, 0
    je pappu
    
    push eax
    mov edx, offset errorColMsg
    call writestring
    pop eax
    call WriteDec
    call Crlf
    mov eax, 3000
    call delay

    pappu:
    pop edx
    pop ecx
    pop ebx

mov  esp, ebp
pop  ebp
ret
MHints ENDP
;_________________________________________________________


MediumShi Proc
push ebp
mov ebp, esp
    call clrscr
while_M:
    mov edx, OFFSET YURI
    call writeString
    call crlf
    call PrinterKiDukan
    call TakeInput
    
    call MHints
    
    push 0
    push offset manual
    push offset solved_array
    call CompareArrays
    call clrscr
    cmp eax, 1
    jne while_M

mov edx, OFFSET doneMsg
call WriteString
call crlf
mov edx, OFFSET finalScoreMsg
call WriteString
mov eax, score
call WriteInt
call Crlf

mov esp, ebp
pop ebp
ret
MediumShi ENDP
;_________________________________________________________

end main

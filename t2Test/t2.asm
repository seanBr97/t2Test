
.data ; start of a data section
public g ; export variable g
g QWORD 4 ; declare global variable g initialised to 4
.code ; start of a code section

;t2.asm

public      min               ; make sure function name is exported

min: 
	; Function Entry
	push ebp			; save ebp
	mov ebp, esp		; ebp -> new stack frame
	sub esp, 4			; allocate space for local variable v
	
	; Function Body
	mov eax, [ebp+8]	; v = a	
	mov [ebp-4],eax		; putting value into local variable
	
	mov eax, [ebp+12]	; b
	cmp eax, [ebp-4]	; if (b < v) 
	jge min0			; {
	mov eax, [ebp+12]	; v = b
	mov [ebp-4],eax
min0:					;}
	
	mov eax, [ebp+16]	; c
	cmp eax, [ebp-4]	; if (c < v) 
	jge min1			; {
	mov eax, [ebp + 16]	; v = c
	mov [ebp-4],eax
min1:					;}
	
	mov eax, [ebp-4]	; return v (returns in eax so move it there)
	; Function Exit
	mov esp, ebp		; restore esp
	pop ebp				; restore previous ebp
	ret 0				; return from function


public      p               ; make sure function name is exported

p: 
	; Function Entry
	push ebp			; save ebp
	mov ebp, esp		; ebp -> new stack frame
	; no local variables

	;Function Body
	push [ebp+12]		; push j
	push [ebp+8]		; push i
	push g				; push g
	call min			; min(g, i, j)
	add esp, 12			; clear 3 parameters from stack

	push [ebp+20]		; push l 
	push [ebp+16]		; push k 
	push eax			; push min(g, i, j)
	call min			; min(min(g, i, j), k, l)

	; Function Exit
	add esp, 12			; clear parameters from stack
	mov esp, ebp		; restore esp
	pop ebp				; restore previous ebp
	ret 0				; return from function



public      gcd               ; make sure function name is exported

gcd: 
	; Function Entry
	push ebp			; save ebp
	mov ebp, esp		; ebp -> new stack frame
	; no local variables

	;Function Body
	mov eax, [ebp+8]		; a
	mov ebx, [ebp+12]		; b
	cmp ebx, 0				; if (b == 0)
	jne else1				; {
	pop ebx
	mov esp, ebp
	pop ebp
	ret 0					; return a
else1:						; }
	
	mov edx, 0
	cdq						; eax edx
	idiv ebx				; a%b
	push edx				; edx contains remainder (a%b), eax contains quotient
	push ebx				; push b
	call gcd				; gcd(b, a % b)
	add esp, 8				; clear parameters from stack
	
	;Function Exit
	pop ebx				; restore registers
	mov esp, ebp		; restore esp
	pop ebp				; restore previous ebp
	ret 0				; return from function

END
includelib legacy_stdio_definitions.lib
extrn printf:near	; include printf
.data				; start of a data section
public g			; export variable g
g QWORD 4			; declare global variable g initialised to 4
.code				; start of a code section

;t2.asm

; PARAMETERS rcx, rdx, r8, r9
; rcx	rdx		r8		r9
; a		b		c

public      min             ; make sure function name is exported

min:
		mov rax, rcx		; v = a
		cmp rdx, rax		; if (b < v)
		jge min0			; {
		mov rax, rdx		; v = b
min0:						; }
		cmp r8, rax			; if (c < v)
		jge min1			; {
		mov rax, r8			; v = c
min1:						; }	
		ret 0               ; return v in rax	


; rcx	rdx		r8		r9
; i		j		k		l

;min -	rcx			rdx			r8
;		min(g,i,j)	k			l

public		p				; export function name

p:
		sub rsp, 32			; allocate 32 byte shadow space
		mov r10,r8			; r10 = k
		mov r8, rdx			; r8(c) = j
		mov rdx, rcx		; rdx(b) = i
		mov rcx, g			; rcx(a) = g
		call min			; min(g,i,j)

		mov rcx, rax		; a = min(g,i,j)
		mov rdx, r10		; b = k
		mov r8, r9			; c = l
		call min			; min (min(g,i,j),k,l)

		add rsp, 32			; deallocate shadow space
		ret	0				; return answer in rax


public		gcd				; export function name

gcd:

		cmp rdx, 0			; if (b==0)
		jne elseB			; {
		mov rax, rcx		; return a
		ret 0				; }
elseB:						; else {
		mov rax, rcx		; rax = a
		mov rbx, rdx		; b
		mov rdx, 0			; clear
		cdq					; rax rdx
		idiv rbx			; a%b -> rdx
		mov rcx, rbx
		sub rsp, 32			; allocate 32 byte shadow space		
		call gcd			; gcd (b,a%b) -> remainder in rdx, quotient in rax
		add rsp, 32			; deallocate shadow space
		ret 0				; return gcd (b,a%b)
		

public		q				; export function name

fq		db	'a = %I64d b = %I64d c = %I64d d = %I64d e = %I64d sum = %I64d', 0AH, 00H

q:
		mov r10, [rsp+40]	; r10 = e
		push rbx			; preserve rbx
		sub rsp, 48			; allocate 48 (8x6) byte shadow space
		
		mov rbx, 0			; clear
		add rbx, rcx		; total += a
		add rbx, rdx		; total += b
		add rbx, r8			; total += c
		add rbx, r9			; total += d
		add rbx, r10		; total += e
		; printf parameters
		mov [rsp+48], rbx	; total
		mov [rsp+40], rbx	; e
		mov [rsp+32], r9	; d
		mov r9,r8			; c
		mov r8, rdx			; b
		mov rdx, rcx		; a
		lea rcx, fq			; string

		call printf			; call printf

		mov rax, rbx		; returned in rax
		add rsp, 48			; deallocate shadow space
		pop rbx				; restore rbx
		ret 0				; return total

public		qns				; export name

fq2		db 'qns', 0AH, 00H

qns:	
; with shadow space
		sub rsp, 32			;allocate
		lea rcx, fq2
		call printf
		add rsp, 32			; deallocate
;without shadow space
		lea rcx, fq2
		call printf

		ret 0

END
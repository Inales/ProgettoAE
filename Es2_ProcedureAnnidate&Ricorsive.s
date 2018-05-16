#Title: Procedure annidate e ricorsive

#Authors: Andrea Chimenti (andrea.chimenti@stud.unifi.it) 5945877 - Denny Verduchi (denny.verduchi@stud.unifi.it) 5898088
 
#Description: il programma legge inizialmente un numero naturale n, con 0<n<8, e applicando due procedure G e F, restituisce il risultato calcolato in n

#Input: il programma chiede in ingresso un numero naturale n, con 0<n<8

#Output: il programma restituisce il risultato dell'applicazione delle procedure G e F con input n

#Filename: Es2_ProcedureAnnidate&Ricorsive.s

#Date: 25-05-2017

.data
strEnd: .asciiz "Programma terminato."
strErrChar: .asciiz "ERRORE: non si possono inserire caratteri o numeri al di fuori di 0<n<9.\n\n"
strInput: .asciiz "\nInserire un numero naturale n, con 0<n<9: "
strNewLine: .asciiz "\n"
strOverF: .asciiz "ECCEZIONE: il programma ha generato un overflow, quindi il risultato non e' piu' attendibile.\n"
strResult: .asciiz "Risultato: G(" 
strEqual: .asciiz ") = "
strTrack1: .asciiz "Traccia: \n"
strTrack2: .asciiz "G("
strTrack3: .asciiz ") --> "
strTrack4: .asciiz "F("
strTrack5: .asciiz "F:return("
strTrack6: .asciiz "G:return("
strTrack7: .asciiz ")"

.text
.globl main

exit:    
        lw $a0,0($sp)               #ripristina il parametro (n) salvato in precedenza nello stack frame
        lw $ra,4($sp)                #ripristina l'indirizzo di ritorno salvato in precedenza nello stack frame
        addi $sp,$sp,8             #ripristina lo stack frame

        la $a0,strTrack6      #carica la stringa contenuta in strTrack6 nel registo $a0
        li $v0,4               #codice di stampa stringa = 4 
        syscall               #stampa la stringa sul terminale

        move $a0,$t0              #sposta il valore di $t0 (u) in $a0
        li $v0,1               #codice di stampa intero = 1
        syscall               #stampa l'intero sul terminale

        la $a0,strTrack7              #carica la stringa contenuta in strTrack7 nel registo $a0
        li $v0,4               #codice di stampa stringa = 4 
        syscall               #stampa la stringa sul terminale
    
        la $a0,strNewLine              #carica la stringa contenuta in strNewLine nel registo $a0
        li $v0,4               #codice di stampa stringa = 4 
        syscall               #stampa la stringa sul terminale

        move $v0,$t0              #sposta il valore di $t0 (u) in $v0
        jr $ra               #torna al chiamante

#esegue la procedura G
procG:
        addi $sp,$sp,-8             #crea spazio per due words nello stack frame
        sw $a0,0($sp)               #salva il parametro d'invocazione 
        sw $ra,4($sp)               #salva l'indirizzo di ritorno al chiamante
    
        add $t0,$zero,$zero                     #inizializza $t0 (b) con il valore 0
        add $t1,$zero,$zero                        #inizializza $t1 (u) con il valore 0
        add $t2,$zero,$zero                        #inizializza $t2 (k) con il valore 0
        move $t3,$a0                                 #sposta il valore di $a0 (n) in $t3

    loop:
        bgt $t2,$t3,exit            #se $t2 (k) > $t3 (n) salta a exit

        la $a0,strTrack4                #carica la stringa contenuta in strTrack4 nel registo $a0
        li $v0,4                         #codice di stampa stringa = 4 
        syscall                         #stampa la stringa sul terminale

        move $a0,$t2             #sposta il valore di $t2 (k) in $a0
        li $v0,1                         #codice di stampa intero = 1
        syscall                         #stampa l'intero sul terminale

        la $a0,strTrack3                #carica la stringa contenuta in strTrack3 nel registo $a0
        li $v0,4                         #codice di stampa stringa = 4 
        syscall                         #stampa la stringa sul terminale

        addi $sp,$sp,-8         #crea spazio per due words nello stack
        sw $t0,0($sp)            #salva $t0 per preservarlo
        sw $t2,4($sp)           #salva $t2 per preservarlo

        move $a1,$t2            #sposta il valore di $t2 (k) in $a1
        jal procF                      #chiamata alla procedura procF
        move $t1,$v0            #sposta il risultato della procF in $t1 (u)

        lw $t0,0($sp)           #ripristina il valore preservato in precedenza
        lw $t2,4($sp)           #ripristina il valore preservato in precedenza
        addi $sp,$sp,8        #ripristina lo stack

        mul $t0,$t0,$t0     #esegue il quadrato di $t0 (b = b*b)

        mfhi $a3                                        #accede al registro Hi (registro per il controllo dell'overflow) e copia il suo valore all'interno del registro $a3
        bne $a3,$zero,overflow           #se $a3 != 0 salta a overflow

        add $t0,$t0,$t1              #esegue la somma $t0 (b*b) + $t1 (u) e mette il risultato nel registro $t0 (u)

        addi $t2,$t2,1              #esegue la somma $t2 (k) + 1
        j loop               #torna a loop

    overflow:    la $a0,strOverF              #carica la stringa contenuta in strOverF nel registo $a0
        li $v0,4               #codice di stampa stringa = 4 
        syscall               #stampa la stringa sul terminale

        la $a0,strNewLine              #carica la stringa contenuta in strNewLine nel registo $a0
        li $v0,4               #codice di stampa stringa = 4 
        syscall               #stampa la stringa sul terminale

        la $a0,strEnd              #carica la stringa contenuta in strEnd nel registo $a0
        li $v0,4               #codice di stampa stringa = 4 
        syscall               #stampa la stringa sul terminale

        lw $ra,0($sp)              #ripristina l'indirizzo di ritorno salvato in precedenza nello stack frame
        lw $ra,4($sp)              #ripristina l'indirizzo di ritorno salvato in precedenza nello stack frame
        lw $ra,8($sp)              #ripristina l'indirizzo di ritorno salvato in precedenza nello stack frame
        addi $sp,$sp,16              #ripristina lo stack frame
        
        jr $ra               #torna al chiamante (exeption handler)

#esegue la procedura F
procF:
        addi $sp,$sp,-8                    #crea spazio per due words nello stack frame
        sw $ra,4($sp)                       #salva l'indirizzo di ritorno al chiamante
        sw $a1,0($sp)                      #salva il parametro d'invocazione

        slti $t4,$a1,1                               #mette $t4 = 1 se $a1 (k) < 1
        beq $t4,$zero,return                #se $t4 == 0 salta a return

        addi $t5,$zero,1                        #esegue la somma $zero + 1 e mette il risultato nel registro $t5

        la $a0,strTrack5                           #carica la stringa contenuta in strTrack5 nel registo $a0
        li $v0,4                                 #codice di stampa stringa = 4 
        syscall                                 #stampa la stringa sul terminale

        move $a0,$t5                   #sposta il valore di $t5 (risultato procF) in $a0
        li $v0,1                                #codice di stampa intero = 1
        syscall                                #stampa l'intero sul terminale

        la $a0,strTrack3                    #carica la stringa contenuta in strTrack3 nel registo $a0
        li $v0,4                             #codice di stampa stringa = 4 
        syscall                             #stampa la stringa sul terminale    

        move $v0,$t5                #sposta il valore di $t5 (risultato procF) in $v0

        lw $a1,0($sp)                  #ripristina il parametro (k) salvato in precedenza nello stack frame
        lw $ra,4($sp)                   #ripristina l'indirizzo di ritorno salvato in precedenza nello stack frame
        addi $sp,$sp,8                #ripristina lo stack frame
    
        jr $ra                                  #torna al chiamante

    return:
        addi $a1,$a1,-1             #esegue la sottrazione $a1 (k) - 1 e mette il risultato nel registro $a1

        la $a0,strTrack4                    #carica la stringa contenuta in strTrack4 nel registo $a0
        li $v0,4                             #codice di stampa stringa = 4 
        syscall                             #stampa la stringa sul terminale

        move $a0,$a1                #sposta il valore di $a1 (k-1) in $a0
        li $v0,1                             #codice di stampa intero = 1
        syscall                             #stampa l'intero sul terminale

        la $a0,strTrack3                    #carica la stringa contenuta in strTrack3 nel registo $a0
        li $v0,4                             #codice di stampa stringa = 4 
        syscall                             #stampa la stringa sul terminale

        jal procF                           #chiamata ricorsiva alla procedura procF

        lw $a1,0($sp)                   #ripristina il parametro (k) salvato in precedenza nello stack frame
        lw $ra,4($sp)                   #ripristina l'indirizzo di ritorno salvato in precedenza nello stack frame
        addi $sp,$sp,8                #ripristina lo stack frame

        move $t5,$v0                 #sposta il valore di $v0 (risultato procF) in $t5

        add $t5,$t5,$t5             #esegue il prodotto $t5 (F(k-1)) * 2 e mette il risultato nel registro $t5
        add $t5,$t5,$a1             #esegue la somma $t5 (F(k-1)*2) + $a1 (k) e mette il risultato nel registro $t5
    
        la $a0,strTrack5                    #carica la stringa contenuta in strTrack5 nel registo $a0
        li $v0,4                             #codice di stampa stringa = 4 
        syscall                             #stampa la stringa sul terminale

        move $a0,$t5                #sposta il valore di $t5 in $a0
        li $v0,1                             #codice di stampa intero = 1
        syscall                             #stampa l'intero sul terminale
        
        la $a0,strTrack3                  #carica la stringa contenuta in strTrack3 nel registo $a0
        li $v0,4                           #codice di stampa stringa = 4 
        syscall                           #stampa la stringa sul terminale
    
        move $v0,$t5                #sposta il valore di $t5 (risultato procF) in $v0
        jr $ra                                #torna al chiamante

main:
        addi $sp,$sp,-4         #crea spazio per due word nello stack frame
        sw $ra,0($sp)                #salva l'indirizzo di ritorno al chiamante
          

        la $a0,strInput              #carica la stringa contenuta in strInput nel registo $a0    
        li $v0,4                            #codice di stampa stringa = 4
        syscall                            #stampa la stringa sul terminale

        addi $s0,$zero,49            #aggiunge a $s0 il numero 49,  rappresentazione in caratteri ASCII dell'elemento 1
        addi $s1,$zero,56              #aggiunge a $s1 il numero 56,  rappresentazione in caratteri ASCII dell'elemento 8

        li $v0,12                   #codice di lettura carattere = 12
        syscall                     #legge la stringa su terminale

        blt $v0,$s0,errChar               #se $v0 < $s0 (49) vai a errChar 
        bgt $v0,$s1,errChar             #se $v0 > $s1 (56) vai a errChar

        sub $t0,$v0,$s0               #sottrae a $v0, $s0 (49)nel caso in cui il branch non sia andato a errChar, per ritrovare il numero inserito dall'esterno -1
        addi $t0,$t0,1                     #somma uno per ritrovare il numero inserito dall'utente
        sw $t0,4($sp)                   #salva il registro $t0 nella stack per poterlo usare nella stampa del risultato 

        la $a0,strNewLine       #carica la stringa contenuta in strNewLine nel registo $a0
        li $v0,4                            #codice di stampa stringa = 4 
        syscall                            #stampa la stringa sul terminale
    
        la $a0,strTrack1       #carica la stringa contenuta in strTrack1 nel registo $a0
        li $v0,4                        #codice di stampa stringa = 4 
        syscall                        #stampa la stringa sul terminale

        la $a0,strTrack2               #carica la stringa contenuta in strTrack2 nel registo $a0
        li $v0,4                   #codice di stampa stringa = 4 
        syscall                   #stampa la stringa sul terminale

        move $a0,$t0               #sposta il valore di $t0 (n) in $a0
        li $v0,1                   #codice di stampa intero = 1
        syscall                   #stampa l'intero sul terminale

        la $a0,strTrack3               #carica la stringa contenuta in strTrack3 nel registo $a0
        li $v0,4                   #codice di stampa stringa = 4 
        syscall                   #stampa la stringa sul terminale
            
        move $a0,$t0               #sposta il valore di $t0 (n) in $a0
        jal procG                       #chiamata alla procedura procG
        move $t6,$v0              #sposta il risultato della procG in $t5

        lw $t0,4($sp)               #ripristina il registro $t0 salvato in precedenza nello stack frame

        la $a0,strNewLine               #carica la stringa contenuta in strNewLine nel registo $a0
        li $v0,4                   #codice di stampa stringa = 4 
        syscall                   #stampa la stringa sul terminale

        la $a0,strResult               #carica la stringa contenuta in strResult nel registo $a0
        li $v0,4                   #codice di stampa stringa = 4 
        syscall                   #stampa la stringa sul terminale

        move $a0,$t0               #sposta il valore di $t0 (n), in $a0
        li $v0,1                   #codice di stampa intero = 1
        syscall                   #stampa l'intero sul terminale

        la $a0,strEqual               #carica la stringa contenuta in strEqual nel registo $a0
        li $v0,4                   #codice di stampa stringa = 4 
        syscall                   #stampa la stringa sul terminale
            
        move $a0,$t6               #sposta il valore di $t5 (risultato procG) in $a0
        li $v0,1                   #codice di stampa intero = 1
        syscall                   #stampa l'intero sul terminale

      
        lw $ra,0($sp)                 #ripristina l'indirizzo di ritorno salvato in precedenza nello stack frame
        addi $sp,$sp,4           #ripristina lo stack frame

        jr $ra                   #torna al chiamante (exeption handler)

        #errore carattere
    errChar:    
        la $a0,strNewLine              #carica la stringa contenuta in strNewLine nel registo $a0
        li $v0,4               #codice di stampa stringa = 4 
        syscall               #stampa la stringa sul terminale

        la $a0,strErrChar              #carica la stringa contenuta in strErrChar nel registo $a0
        li $v0,4               #codice di stampa stringa = 4
        syscall               #stampa la stringa sul terminale

        j main               #torna a main per ripetere l'operazione di inserimento

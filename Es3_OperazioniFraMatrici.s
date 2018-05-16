#Title: Operazioni fra matrici

#Authors: Andrea Chimenti (andrea.chimenti@stud.unifi.it) 5945877 - Denny Verduchi (denny.verduchi@stud.unifi.it) 5898088
  
#Description: il programma legge inizialmente un numero n (comrpeso tra 1 e 5) inserito dall'esterno per la scelta dell'operazione da menu principale. L'utente può scegliere tra una delle seguenti opzioni:
     #1) inserimento di matrici --> il programma chiede l'inserimento di un numero naturale n, con 0<n<5, con il quale crea la dimensione delle due matrici quadrate. Il programma successivamente richiede l'inserimento di 
     #                                                       numeri interi per popolare le due matrici
     #2) somma di matrici --> il programma esegue la somma di matrici con in ingresso le due matrici create 
     #3) sottrazione di matrici --> il programma esegue la sottrazione di matrici con in ingresso le due matrici create 
     #4) prodotto di matrici --> il programma esegue la prodotto di matrici con in ingresso le due matrici create 
     #5) fine programma --> il programma termina la sua esecuzione

#Input: il programma richiede le operazioni da svolgere e i dati da inserire nelle matrici al momento dell'inserimento

#Output: il programma restituisce il risultato di ogni singola opezione

#Filename: Es3_OperazioniFraMatrici.s

#Date: 25-05-2017

.data
strDimMat: .asciiz "Inserisci un numero n per creare le dimensioni delle matrici, con 0<n<5: "
strEnd: .asciiz "Programma terminato"
strErrCh: .asciiz "ERRORE: il numero da inserire deve essere compreso tra 1 e 5.\n\n"
strErrOp: .asciiz "ERRORE: le matrici non sono state create.\n\n"
strErrNum: .asciiz "ERRORE: il numero da inserire deve essere maggiore  a 0 e minore di 5.\n\n"
strErrChar: .asciiz "ERRORE: il numero da inserire deve essere maggiore  a 0 e minore di 5.\n\n"
strD0: .asciiz "Dimensione matrice: "
strD1: .asciiz "x"
strIns: .asciiz "Inserisci il numero dell'operazione: "
strSetMatA: .asciiz "Inserimento matrice A:\n"
strSetMatB: .asciiz "Inserimento matrice B:\n"
strSetMatRow: .asciiz "Inserisci elemento in posizione: riga("
strSetMatCol: .asciiz "); colonna("
strSetEq: .asciiz ") = "
strBackN: .asciiz "\n"
strProdM: .asciiz "Matrice risultante dal prodotto:\n"
strR0: .asciiz "     r("
strR1: .asciiz ")"
strS0: .asciiz "Opzioni possibili:\n\n"
strS1: .asciiz "1) Inserimento di matrici\n" 
strS2: .asciiz "2) Somma di matrici\n" 
strS3: .asciiz "3) Sottrazione di matrici\n" 
strS4: .asciiz "4) Prodotto di matrici\n"
strS5: .asciiz "5) Fine programma\n\n"
strSpV: .asciiz " | "
strsubM: .asciiz "Matrice risultante dalla sottrazione:\n"
strSumM: .asciiz "Matrice risultante dalla somma:\n"

.align 2
jumpTable: .space 20       #jump table array a 4 word che verra' instanziata dal main con gli indirizzi delle label che chiameranno le corrispondenti procedure

.text
.globl main

optionInsert:      
     li $v0, 4
     la $a0, strBackN     
     syscall
     
     li $v0, 4          #chiedo all'utente la dimensione della matrice
     la $a0, strDimMat
     syscall

     li $v0, 5          #tramite la syscall vado a leggere il dato inserito 
     syscall

     move $t5, $v0     #sposto il dato inserito che si trova in v0 in t5 per poterlo riutilizzare

     ble $t5,$zero,errNum       #se $t5 <= 0 salta a errNum
     bge $t5, 5, errNum                             #se $t5 >=5 salta aa errNum
        
     mul $t6, $t5, $t5     #moltiplico la grandezza inserita dall'utente per se stessa così da avere la grandezza effettiva della catena
    
     addi $sp, $sp, -32       #alloco spazio nella stack per preservare i registri $t
     sw $t1, 0($sp)
     sw $t2, 4($sp)
     sw $t3, 8($sp)
     sw $t5, 12($sp)
     sw $t6, 16($sp)
     sw $t7, 20($sp)
     sw $t8, 24($sp)
     sw $t4, 28($sp)

     li $v0, 4
     la $a0, strBackN
     syscall
        
     li $v0, 4  #mostro all'utente la stringa di servizio per l'inserimento della matrice  a attraverso la chiamata a sistema di codice 4
     la $a0, strSetMatA
     syscall

     move $a0, $t1     #sposto  nei registri $a, i valori da passare al chiamato per effettuare la procedura
     move $a1, $t2
     move $a2, $t5
     move $a3, $t6 
        
     jal insert          #attraverso la jump e link vado alla procedura insert
        
     lw $t1, 0($sp)     #riporto i registri preservati nei $t
     lw $t2, 4($sp)
     lw $t3, 8($sp)
     lw $t5, 12($sp)
     lw $t6, 16($sp)
     lw $t7, 20($sp)
     lw $t8, 24($sp)
     lw $t4, 28($sp)

     addi $sp, $sp, 32     #dealloco la stack
        
     move $t1, $v0     #sposto in t1 e t2, la nuova testa e coda avuti come risultato dalla procedura
     move $t2, $v1
     
     addi $sp, $sp, -32       #alloco spazio nella stack per preservare i registri $t
     sw $t1, 0($sp)
     sw $t2, 4($sp)
     sw $t3, 8($sp)
     sw $t5, 12($sp)
     sw $t6, 16($sp)
     sw $t7, 20($sp)
     sw $t8, 24($sp)
     sw $t4, 28($sp)

     move $a0, $t1     #sposto negli a i registri da passare al chiamato per effettuare la procedura
     move $a1, $t2
     move $a2, $t5
     move $a3, $t6 
                
     jal printMatrix     #faccio una jal alla procedura di stampa
        
     lw $t1, 0($sp)     #riporto i registri preservati nei $t
     lw $t2, 4($sp)
     lw $t3, 8($sp)
     lw $t5, 12($sp)
     lw $t6, 16($sp)
     lw $t7, 20($sp)
     lw $t8, 24($sp)
     lw $t4, 28($sp)

     addi $sp, $sp, 32     #dealloco la stack
     
     addi $sp, $sp, -32       #alloco spazio nella stack per preservare i registri $t
     sw $t1, 0($sp)
     sw $t2, 4($sp)
     sw $t3, 8($sp)
     sw $t5, 12($sp)
     sw $t6, 16($sp)
     sw $t7, 20($sp)
     sw $t8, 24($sp)
     sw $t4, 28($sp)

     li $v0,4
     la $a0,strBackN
     syscall        
        
     li $v0,4          #mostro all'utente la stringa di servizio per l'inserimento della matrice b, attraverso la chiamata a sistema di codice 4
     la $a0,strSetMatB
     syscall

     move $a0, $t3     #passo la testa e la coda della seconda matrice alla procedura di inserimento
     move $a1, $t4                
     move $a2, $t5
     move $a3, $t6 
     
     jal insert
     
     lw $t1, 0($sp)     #riporto i registri preservati nei $t
     lw $t2, 4($sp)
     lw $t3, 8($sp)
     lw $t5, 12($sp)
     lw $t6, 16($sp)
     lw $t7, 20($sp)
     lw $t8, 24($sp)
     lw $t4, 28($sp)

     addi $sp, $sp, 32             
     
     move $t3, $v0     #sposto in t1 e t2, la nuova testa e coda avuti come risultato dalla procedura
     move $t4, $v1
             
     addi $sp,$sp,-32       #alloco spazio nella stack per preservare i registri $t
     sw $t1, 0($sp)
     sw $t2, 4($sp)
     sw $t3, 8($sp)
     sw $t5, 12($sp)
     sw $t6, 16($sp)
     sw $t7, 20($sp)
     sw $t8, 24($sp)
     sw $t4, 28($sp)

     move $a0, $t3     #sposto negli a i registri da passare al chiamato per effettuare la procedura
     move $a1, $t4
     move $a2, $t5
     move $a3, $t6 

     jal printMatrix     #faccio una jal alla procedura di stampa
        
     lw $t1, 0($sp)     #riporto i registri preservati nei $t
     lw $t2, 4($sp)
     lw $t3, 8($sp)
     lw $t5, 12($sp)
     lw $t6, 16($sp)
     lw $t7, 20($sp)
     lw $t8, 24($sp)
     lw $t4, 28($sp)
     
     addi $sp, $sp, 32        
     
     li $v0, 4
     la $a0, strBackN
     syscall     

     li $v0, 4
     la $a0, strBackN
     syscall     
        
     j menuSel
        
     insert:     
        addi $sp, $sp, -16       #alloco spazio nello stack per salvare il registro $ra e preservare i tre registri
        sw $ra, 0($sp)       #s2 ed s3 ed s4 che utilizzero' come indici di servizio per informare l'utente sulla posizione dell'elemento inserito
        sw $s2, 4($sp)          
        sw $s3, 8($sp)
        sw $s4, 12($sp)

        move $t1, $a0       #vado a spostare attraverso la move i valori che mi sono stati passati dal chiamante.
        move $t2, $a1
        move $t5, $a2
        move $t3, $a3
        
        move $s4, $t1       #mi faccio una copia della testa, così da poter scorrere facilmente gli elementi già presenti in memoria
     
     store:     
        beq $t8, $t3, stopinsert         #se indice i, che ho in t8 è uguale a nxn, ho già inserito tutti gli elementi
        beq $s2, $t5, nextrow          #se indice z, che ho in s2 è uguale a n, cambio riga.
             
        li $v0, 4     #stampo su schermo la stringa di richiesta del dato da inserire in una certa riga e colonna della matrice
        la $a0, strSetMatRow
        syscall
             
        move $a0,$s3          
        li $v0,1                   
        syscall     
        
        li $v0, 4     #stampo su schermo la stringa di concatenazione
        la $a0, strSetMatCol
        syscall
             
        move $a0,$s2             
        li $v0,1                   
        syscall     

        li $v0, 4     #stampo su schermo la chiusura della stringa di servizio
        la $a0, strSetEq
        syscall
        
        li $v0, 5     #tramite il codice della syscall 5 vado a prendere l'intero inserito da tastiera
        syscall
             
        move $t7, $v0
             
        beq $t1, $zero, newpiece         #se la testa è uguale a 0, non ho ancora creato spazio di lavoro quindi vado a crearlo
        beq $t4, $zero, newpiece         #oppure se non ho elementi a cui punta la coda, e ho bisogno ancora di inserire, sicuramente dovro' allocare nuovo spazio
        
        sw $v0, 0($s4)       #sovrascrivo l'elemento inserito da utente nei primi 4 blocchi di un vecchio elemento
        lw $s4, 4($s4)       # in s4 vado a mettere l'indirizzo del blocco successivo
        
        move $t4, $s4       #copio s4 in t4 cosi' da avere sempre aggiornata la coda in caso di creazione nuovi blocchi
        
        addi $s2,$s2, 1       #incremento s2 per comunicare all'utente dove sta' inserendo
        addi $t8,$t8, 1       #incremento t8 per effettuare il controllo stop inserimenti
        
        j store

     newpiece:     
        li $v0, 9     #richiamo la syscall con codice 9, cosi' da creare tramite l'sbrk un elemento di 8 byte
        li $a0, 8
        syscall
                
        sw $t7, 0($v0)       #salvo l'intero inserito dall'utente nei primi 4 byte dell'elemento creato
        sw $zero, 4($v0)       #salvo nel campo elemento successivo zero=nil
                
        bne $t1, $zero, link       #se la testa non è uguale a 0, quindi ci sono elementi all'interno della lista vado a fare il link 
        move $t1, $v0       #altrimenti sono davanti al primo elemento quindi testa = coda
        move $t2, $v0     
        lw $t4, 4($t2)       #carico in t4 gli ultimi 4 byte dell'elemento in coda, così da effettuare il controllo successivo per linkarlo con un nuovo oggetto creato
                
        addi $t8, $t8, 1
        addi $s2, $s2, 1
        j store
             
     link:     
        sw $v0, 4($t2)       #salvo nei campo elemento successivo, del vecchio ultimo elemento, l'indirizzo dell'elemento appena creato
        move $t2, $v0       #adesso imposto la coda al nuovo elemento linkato
        lw $t4, 4($t2)       #carico in t4 gli ultimi 4 byte dell'elemento in coda, così da effettuare il controllo successivo per linkarlo con un nuovo oggetto creato
         
        addi $t8, $t8, 1       #incremento s2 per comunicare all'utente dove sta' inserendo
        addi $s2, $s2, 1       #incremento t8 per effettuare il controllo stop inserimenti
         
        j store

     nextrow:     
        add $s2, $zero, $zero         #riporto l'indice di colonna a 0 e aumento l'indice di riga di 1 
        addi $s3, $s3, 1
        
        j store

     stopinsert:    
             lw $ra 0($sp)         #quando tutta la matrice è stata inserita
             lw $s2,4($sp)         #ripristino gli elementi preservati in precedenza
             lw $s3,8($sp)         #dealloco la stack e metto in v0, e v1, testa e coda nuovi da inviare al chiamante
             lw $s4,12($sp)
        
             addi $sp,$sp, 16
        
             move $v0, $t1
             move $v1, $t2
        
             jr $ra       #attravero la jr $ra ritorno nella posizione PC+4 di quando ho effettuato la chiamata

     printMatrix:     
            addi $sp, $sp, -12         #alloco spazio nello stack per salvare il registro $ra e preservare i due registri
             sw $ra, 0($sp)         #s2 ed s3 che utilizzero' come indici di servizio per informare l'utente sulla posizione dell'elemento inserito
             sw $s2, 4($sp)
             sw $s3, 8($sp)

             move $t1, $a0
             move $t2, $a1
             move $t5, $a2
             move $t3, $a3

             li $v0, 4
             la $a0, strBackN
             syscall

             li $v0, 4       
             la $a0,strD0
             syscall       #stampa la stringa di servizio1 per dimensione matrice

             move $a0,$t5     
             li $v0,1
             syscall       #lettura dell'intero che viene messo nel registro $v0

             li $v0, 4       
             la $a0, strD1
             syscall       #stampa la stringa di servizio2 per dimensione matrice

             move $a0, $t5    
             li $v0,1
             syscall

             li $v0, 4
             la $a0, strBackN
             syscall

             la $a0,strR0       
             li $v0,4                 
            syscall               #stampa la stringa per identificare la riga1
        
             move $a0,$s3         
             li $v0,1                 
             syscall       #stampa il valore della riga

             la $a0,strR1       
             li $v0,4                 
            syscall               #stampa la stringa per identificare la riga2
     
             la $a0,strSpV       
             li $v0,4                 
            syscall               #stampa il separatore di righe     
             
     print:     
     beq $t8,$t3,stopprint         #controlla di aver raggiunto con la testa la coda per essere sicuro di ver stampato la matrice, così da uscire dalla stampa
        beq $s2,$t5,nextrowprint         #controlla se ha terminato di stampare la riga per passare alla seconda 
             
        lw $t4,0($t1)       #vado a leggere l'intero all'interno dei primi 4 byte degli otto allocati per ogni elemento
             
        move $a0,$t4
        li $v0,1
        syscall     #stampa il numero contenuto nella matrice
             
        li $v0,4
        la $a0,strSpV
        syscall     #applica separatore di riga 
        
        lw $t1,4($t1)       #vado a mettere in t1 il puntatore al successivo
        addi $t8,$t8,1       #incremento gli indici di controllo
        addi $s2, $s2,1

        j print
             
     nextrowprint:     
            add $s2, $zero, $zero    #riporto l'indice di colonna a 0
                
             li $v0, 4
             la $a0, strBackN             
             syscall
              
             la $a0,strR0         #attraverso la syscall vado a stampare stringhe di servizio per una migliore lettura della matrice
             li $v0,4            
             syscall          

             addi $s3,$s3,1         #aumento s3 di 1, indice di riga, per poi stamparlo per indicare all'utente dove si trovano i suoi elementi
        
             move $a0,$s3         
             li $v0,1                 
             syscall       

             la $a0,strR1       
             li $v0,4                 
               syscall               

             la $a0,strSpV       
             li $v0,4                 
             syscall               

             j print       #attraverso l'istruzione j salto di nuovo alla print
                
     stopprint:    
        lw $ra 0($sp)       #vado a ripristinare i valori preservati e dealloco la stack
        lw $s2,4($sp)
        lw $s3,8($sp)
        addi $sp,$sp, 12

        li $v0, 4
        la $a0, strBackN
        syscall

        jr $ra     #attraverso la jr salto a PC+4 del momento in cui è stata chiamata la print

     errChar:     
        li $v0, 4
        la $a0, strBackN
        syscall

        la $a0,strErrChar        
        li $v0,4         
        syscall       #stampa stringa errore       

        j optionInsert       #torna a main per ripetere l'operazione di inserimento     

errNum:     
    la $a0,strErrNum       
     li $v0,4            
    syscall       
                                                    
         j optionInsert            #torna a main per ripetere l'operazione di inserimento     

#somma di matrici
optionSumMat:     
        beq $t1,$zero,errorOp 
        addi $sp,$sp,-12     #alloco spazio nello stack per salvare il registro $ra e preservare i due registri
             #s2 ed s3 che utilizzero' come indici di servizio per informare l'utente sulla posizione dell'elemento inserito
     sw $s2,4($sp)
     sw $s3,8($sp)

     li $v0,4
     la $a0,strBackN
     syscall
                
     li $v0,4     
     la $a0,strSumM
     syscall

     mul $t6,$t5,$t5     #moltiplico la grandezza inserita dall'utente per se stessa così da avere la grandezza effettiva della catena
    
     addi $sp,$sp,-32       #alloco spazio nella stack per preservare i registri $t
     sw $t1,0($sp)
     sw $t2,4($sp)
     sw $t3,8($sp)
     sw $t5,12($sp)
     sw $t6,16($sp)
     sw $t7,20($sp)
     sw $t8,24($sp)
     sw $t4,28($sp)
     
     move $a0,$t1     #sposto negli a i registri da passare al chiamato per effettuare la procedura
     move $a1,$t3
     move $a2,$t5
     move $a3,$t6 
        
     jal Sum

     lw $t1,0($sp)     #riporto i registri preservati nei $t
     lw $t2,4($sp)
     lw $t3,8($sp)
     lw $t5,12($sp)
     lw $t6,16($sp)
     lw $t7,20($sp)
     lw $t8,24($sp)
     lw $t4,28($sp)
     addi $sp,$sp,32

     li $v0,4
     la $a0,strBackN
     syscall     

     li $v0,4
     la $a0,strBackN
     syscall     

     lw $ra,0($sp)
     lw $s2,4($sp)
     lw $s3,8($sp)
     addi $sp,$sp,12
        
     j menuSel
        
     Sum:     
        addi $sp, $sp, -12       #alloco spazio nello stack per salvare il registro $ra e preservare i due registri
        sw $ra, 0($sp)       #s2 ed s3 che utilizzero' come indici di servizio per informare l'utente sulla posizione dell'elemento inserito
        sw $s2, 4($sp)
        sw $s3, 8($sp)

        move $t1,$a0       #sposto i dati passati alla procedura in t1, t3, t5, t6
        move $t3,$a1       #t1 testa della prima matrice e t3 testa della seconda matrice
        move $t5,$a2       #t5 n
        move $t6,$a3       #t6 nxm

        add $t8,$t8,$zero       #imposto in t8 l'indice di controllo di fine stampa

        la $a0,strBackN       
        li $v0,4                 
        syscall               

        la $a0,strR0       
        li $v0,4                 
        syscall             #stampa su schermo l'indicatore di riga

        move $a0,$s3         
        li $v0,1                 
        syscall     #stampa su schermo la riga corrente

        la $a0,strR1       
        li $v0,4                 
        syscall             #stampa su schermo la chiusura dell'indicatore di riga

        la $a0,strSpV       
        li $v0,4                 
        syscall             #stampa su schermo il separatore di righe
 
        loopSum:     
             beq $t8,$t6,exitSum         #se $t8 (indice controllo inserimento) = $t6 (nxm) vai a exitSum
             beq $s2,$t5,nxTSum    #se $s2 (indice colonna) = $t5 (n inserito dall'esterno dall'utente) vai a nxTSum
             
             lw $t2,0($t1)         #aggiorna elemento della matrice A
             lw $t4,0($t3)         #aggiorna elemento della matrice B
     
             add $t2,$t2,$t4         #esegue la somma di matrici

             move $a0,$t2        
             li $v0,1
             syscall       #stampa su schermo il risultato della somma
             
             li $v0,4
             la $a0,strSpV
             syscall
        
             lw $t1,4($t1)
             lw $t3,4($t3)

             addi $t8,$t8,1         #aggiorna t8
             addi $s2,$s2,1         #aggiorna la colonna

             j loopSum

        nxTSum:     
            add $s2,$zero,$zero    #riporta la colonna a zero
                
             li $v0, 4
             la $a0, strBackN
             syscall
              
             la $a0,strR0         
             li $v0,4            
            syscall          

             addi $s3,$s3,1         #aggiorno la riga
        
             move $a0,$s3    
             li $v0,1            
             syscall       #stampa su schermo la riga corrente

             la $a0,strR1         
             li $v0,4            
            syscall          

             la $a0,strSpV         
             li $v0,4            
            syscall          

             j loopSum
        
        exitSum:     
             lw $ra,0($sp)         #disalloco lo spazio dello stack
             lw $s2,4($sp)
             lw $s3,8($sp)
             addi $sp,$sp,12

             li $v0, 4
             la $a0, strBackN
             syscall

             jr $ra       #torno al chiamante
        
optionSotrMat:      
     beq $t1,$zero,errorOp
     addi $sp,$sp,-12     #alloco spazio nello stack per salvare il registro $ra e preservare i due registri
             #s2 ed s3 che utilizzero' come indici di servizio per informare l'utente sulla posizione dell'elemento inserito
     sw $s2,4($sp)
     sw $s3,8($sp)

     li $v0,4
     la $a0,strBackN
     syscall
                
     li $v0,4     
     la $a0,strsubM
     syscall

     mul $t6,$t5,$t5     #moltiplico la grandezza inserita dall'utente per se stessa così da avere la grandezza effettiva della catena
    
     addi $sp,$sp,-32       #alloco spazio nella stack per preservare i registri $t
     sw $t1,0($sp)
     sw $t2,4($sp)
     sw $t3,8($sp)
     sw $t5,12($sp)
     sw $t6,16($sp)
     sw $t7,20($sp)
     sw $t8,24($sp)
     sw $t4,28($sp)
     
     move $a0,$t1     #sposto negli a i registri da passare al chiamato per effettuare la procedura
     move $a1,$t3
     move $a2,$t5
     move $a3,$t6 
        
     jal subtract

     lw $t1,0($sp)     #riporto i registri preservati nei $t
     lw $t2,4($sp)
     lw $t3,8($sp)
     lw $t5,12($sp)
     lw $t6,16($sp)
     lw $t7,20($sp)
     lw $t8,24($sp)
     lw $t4,28($sp)
     addi $sp,$sp,32

     li $v0,4
     la $a0,strBackN
     syscall     

     li $v0,4
     la $a0,strBackN
     syscall     

     lw $ra,0($sp)
     lw $s2,4($sp)
     lw $s3,8($sp)
     addi $sp,$sp,12
        
     j menuSel
        
     subtract:     
        addi $sp,$sp,-12       #alloco spazio nello stack per salvare il registro $ra e preservare i due registri
        sw $ra,0($sp)       #s2 ed s3 che utilizzero' come indici di servizio per informare l'utente sulla posizione dell'elemento inserito
        sw $s2,4($sp)
        sw $s3,8($sp)

        move $t1,$a0       #sposto i dati passati alla procedura in t1, t3, t5, t6
        move $t3,$a1       #t1 testa della prima matrice e t3 testa della seconda matrice
        move $t5,$a2       #t5 n
        move $t6,$a3       #t6 nxm

        add $t8,$t8,$zero       #imposto in t8 l'indice di controllo di fine stampa

        la $a0,strBackN       
        li $v0,4                 
        syscall               
                
        la $a0,strR0       
        li $v0,4                 
        syscall               
        
        move $a0,$s3         
        li $v0,1                 
        syscall     #stampa su schermo la riga corrente       

        la $a0,strR1       
        li $v0,4                 
        syscall               

        la $a0,strSpV       
        li $v0,4                 
        syscall               

        loopsub:     
             beq $t8,$t6,exitsub         #se $t8 (indice controllo inserimento) = $t6 (nxm) vai a exitSum
             beq $s2,$t5,nxTsub    #se $s2 (indice colonna) = $t5 (n inserito dall'esterno dall'utente) vai a nxTsub
             
             lw $t2,0($t1)         #aggiorna elemento della matrice A
             lw $t4,0($t3)         #aggiorna elemento della matrice B
     
             sub $t2,$t2,$t4         #esegue la sottrazione di matrici

             move $a0,$t2
             li $v0,1
             syscall       #stampa su schermo il risultato della sottrazione
             
             li $v0, 4
             la $a0,strSpV
             syscall
        
             lw $t1,4($t1)    
             lw $t3,4($t3)

             addi $t8,$t8,1         #aggiorna t8
             addi $s2,$s2,1         #aggiorna la colonna

             j loopsub

        nxTsub:     
            add $s2, $zero, $zero    #riporta la colonna a zero
                
             li $v0, 4
             la $a0, strBackN
             syscall
              
             la $a0,strR0    
             li $v0,4            
            syscall          

             addi $s3,$s3,1         #aggiorna la riga
        
             move $a0,$s3    
             li $v0,1            
             syscall       #stampa la riga corrente

             la $a0,strR1         
             li $v0,4            
            syscall          

             la $a0,strSpV    
             li $v0,4                        
            syscall                      

             j loopsub
        
        exitsub:     
            lw $ra,0($sp)         #disalloco lo spazio dello stack
             lw $s2,4($sp)
             lw $s3,8($sp)
             addi $sp,$sp,12

             li $v0, 4
             la $a0, strBackN
             syscall

             jr $ra       #torno al chiamante

optionMltpMat:
     beq $t1,$zero,errorOp     
     addi $sp,$sp,-20
     sw $t1, 0($sp)
     sw $t2, 4($sp)
     sw $t3, 8($sp)
     sw $t4, 12($sp)
     sw $t5, 16($sp)
     
    move $a0, $t1
     move $a1, $t3
     move $a2, $t5

     jal mltp        
        
     lw $t1, 0($sp)
     lw $t2, 4($sp)
     lw $t3, 8($sp)
     lw $t4, 12($sp)
     lw $t5, 16($sp)
     addi $sp, $sp, 20
        
     j menuSel

     mltp:
     
        addi $sp, $sp, -36
        sw $ra, 0($sp)
        sw $s0, 4($sp)
        sw $s1, 8($sp)
        sw $s2, 12($sp)
        sw $s3, 16($sp)
        sw $s4, 20($sp)
        sw $s5, 24($sp)
        sw $s6, 28($sp)
        sw $s7, 32($sp)
        
        move $t1, $a0       #sposto i dati passati alla procedura in t1, t3, t4
        move $t3, $a1       #t3 e t4 testa e coda seconda matrice
        move $t5, $a2
        move $s1, $t1       
        move $s2, $t3         
        move $s3, $t1       #mi creo una copia degli indici della testa e della coda di entrambe le matrice cosi' da poterle modificare     
        move $s4, $t3     #avendo sempre un riferimento alla base
        move $t2, $zero     
        move $t4, $zero
        move $s0, $zero
        move $s5, $zero     
        move $s6, $zero     
        move $s7, $zero
        move $t8, $zero
        move $t7, $zero

        li $v0,4
        la $a0,strBackN
        syscall        
        
        li $v0,4
        la $a0,strProdM
        syscall

        li $v0, 4
        la $a0, strBackN
        syscall

        la $a0,strR0         
        li $v0,4            
        syscall          
        
        move $a0,$s7    
        li $v0,1            
        syscall         

        la $a0,strR1         
        li $v0,4            
        syscall             
        
     mulmatrix:
     
        move $t8,$zero
        lw $t2,0($s3)       #carico in t2 ed t4 i due elementi delle matrici a e b da moltiplicare
        lw $t4,0($s4)     
        mul $t6, $t2, $t4       #moltiplico il primo elemento per il secondo
        add $t7,$t7,$t6       #effettuo la somma parziale, il cui risultato si trova in t7
        addi $s5, $s5,1       #aumento l'indice di controllo di 1
        beq $s5,$t5, changecolumn         #se l'indice di colonna è uguale ad n, quindi sono alla fine di una riga, vado a riportare a zero l'indice
             #e muovere la colonna del moltiplicatore
        lw $s3,4($s3)       #altrimenti leggo il puntatore al secondo elemento della matrice A
#creo un piccolo ciclo per spostarmi ogni volta nella posizione giusta della matrice moltiplicanda

     column:     
        beq $t8,$t5,mulmatrix     
        lw $s4,4($s4)
        addi $t8,$t8,1
        j column
        j mulmatrix
         
     changecolumn:     
            li $v0, 4
            la $a0, strSpV
             syscall
         
             move $a0,$t7         #sposto il contenuto di $s2 in $a0
             li $v0,1                 #codice di lettura intero da console = 1
             syscall       #lettura dell'intero che viene messo nel registro $v0
         
             addi $s6,1         #aggiungo 1 all'indice, con cui controllo la fine della moltiplicazione delle riga
             beq $s6, $t5, changerow    #se uguale ad n vado a cambiare riga
     
            move $s3,$s1         #metto in $s3, $s1, cioe' riporto il puntatore della prima matrice al primo elemento
             move $s4,$s2         #riporto il puntatore dell'elemento della seconda matrice all'inizio
             lw $s4,4($s2)         #per poi andare a leggere il suo elemento successivo = colonna
             move $s2,$s4         #mi aggiorno cosi il puntatore s2 al nuovo elemento da cui dovro' ripartire la prossima volta che dovro' cambiare colonna
             #della matrice B             
            move $s5,$zero         #riporto l'indice di colonna interno al loop a 0
             move $t7,$zero         #riporto il registro di somma parziale a 0     
             j mulmatrix         # salto al loop
                  
     changerow:
             li $v0, 4
             la $a0, strSpV
             syscall
         
             li $v0, 4
             la $a0, strBackN         
             syscall

             addi $s7,$s7,1         #aggiungo 1 all'indice di controllo riga, così quando sara' uguale ad n, saro' sicuro che ho effettuato tutte le operazioni
             beq $s7,$t5,gotomenu    #se uguale ad n vado all'uscita

             la $a0,strR0         
             li $v0,4            
            syscall          
        
             move $a0,$s7    
             li $v0,1            
             syscall         

             la $a0,strR1         
             li $v0,4            
            syscall          
         
             lw $s3,4($s3)         #dato che la scansione della prima matrice mi termina all'ultimo elemento di una data riga, per avere il puntatore all'elemento
                     #successivo, quindi riga successiva mi bastera' leggere il puntatore che si trova nei secondi 4 byte dell'ultimo elemento scansionato
             move $s1,$s3         #mi aggiorno il puntatore alla testa, che ho tenuto fisso fino ad ora, ma che adesso puntera' alla riga successiva
             move $s4,$t3         #riporto l'indice di colonna al primo elemento
             move $s2,$t3         #ed anche $s2, copia dell'indice di colonna lo riporto al primo elemento, così da continuare nelle operazioni
             move $s5,$zero         #riporto l'indice di controllo colonna interno al loop a zero
             move $t7,$zero         #riporto il registro di somma parziale a 0
             move $s6,$zero         #porto l'indice che utilizzo in changerow a zero
             j mulmatrix
        
        gotomenu:
             li $v0, 4
             la $a0, strBackN
             syscall
     
             li $v0, 4
             la $a0, strBackN
             syscall
             
             lw $ra, 0($sp)
             lw $s0, 4($sp)
             lw $s1, 8($sp)
             lw $s2, 12($sp)
             lw $s3, 16($sp)
             lw $s4, 20($sp)
             lw $s5, 24($sp)
             lw $s6, 28($sp)
             lw $s7, 32($sp)
             addi $sp, $sp, 36
             
             jr $ra

optionExit:      j exit

main:     
    addi $sp,$sp,-12     #crea spazio per una word nello stack frame
     sw $ra,0($sp)       #salva l'indirizzo di ritorno al chiamante
     sw $s0,4($sp)     #mi preservo anche s0 e s1 dato che vengono utilizzati dal main
     sw $s1,8($sp)

     la $s1,jumpTable     #carica l'indirizzo della jumpTable nel registro $s1
     
     #carico gli indirizzi delle jOp nella jump table
     la $t0,optionInsert         
     sw $t0,0($s1)         

     la $t0,optionSumMat          
     sw $t0,4($s1)         

     la $t0,optionSotrMat         
     sw $t0,8($s1)         

     la $t0,optionMltpMat         
     sw $t0,12($s1)         

     la $t0,optionExit         
     sw $t0,16($s1)         

     #inserisco le stringhe del menu di scelta
     menuSel:    
        la $a0,strS0         
        li $v0,4          
        syscall         

        la $a0,strS1    
        li $v0,4          
        syscall         

        la $a0,strS2         
        li $v0,4          
        syscall         
     
        la $a0,strS3         
        li $v0,4          
        syscall         

        la $a0,strS4         
        li $v0,4          
        syscall         

        la $a0,strS5         
        li $v0,4          
        syscall         

     choice:     
        la $a0,strIns     
        li $v0,4             
        syscall         

        li $v0,5            
        syscall         

        move $s0,$v0    
     
        sle $t0,$s0,$zero       #mette $t0 = 1 se $s0 (= n) <= 0
        bne $t0,$zero,errorCh         #se $t0 != 0 salta a errorCh

        li $t0,5     #carica nel registro $t0 il valore 5

        sgt $t0,$s0,$t0       #mette $t0 = 1 se $s0 (= n) > $t0 (= 5) 
        bne $t0,$zero,errorCh         #se $t0 != 0 salta a errorCh

     branchC:     
        addi $s0,$s0,-1        #esegue la sottrazione $s0 (= n) - 1, perché prima scelta della jumptable (= 0) corrisponde alla prima scelta del case e mette il risultato nel registro $t0
        add $t0,$s0,$s0        #esegue il prodotto $s0 (= n-1) * 2 e mette il risultato nel registro $t0
        add $t0,$t0,$t0       #esegue la prodotto $s0 (= n-1) * 4, trovando l'offset, e mette il risultato nel registro $t0
        add $t0,$t0,$s1       #esegue la somma $t0 (= offset) + $s1 (= indirizzo della jumpTable) e mette il risultato nel registro $t0
        lw $t0,0($t0)       #carica l'operazione contenuta nell'indirizzo $t0 e la mette nel registro $t0  

        jr $t0       #salta all'indirizzo calcolato, contenuto nel registro $t0 

     #gestione errore carattere e numero negativo
     errorCh:      
        la $a0,strErrCh          
        li $v0,4          
        syscall         
     
        j choice       #torna a choice per ripetere l'operazione di inserimento

     #gestione errore operazione ancora non disponibile
     errorOp:    
        la $a0,strErrOp          
        li $v0,4          
        syscall         
     
        j choice

exit:     
     lw $s1,8($sp)
     lw $s0,4($sp)
     lw $ra,0($sp)     #ripristina l'indirizzo di ritorno salvato in precedenza nello stack frame
     addi $sp,$sp,12     #ripristina lo stack frame
     
    la $a0,strBackN       
     li $v0,4        
     syscall       

     la $a0,strEnd       
     li $v0,4        
     syscall       

     jr $ra          #torna al chiamante (exeption handler)

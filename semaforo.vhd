ENTITY semaforo IS
	PORT (clk : IN BIT; -- clock
 	      clrn: IN BIT; -- clear
 	      A   : IN BIT; -- input 1
 	      B   : IN BIT; -- input 2
 	      S1_vm : OUT BIT; -- Led Vermelho semáforo 1
	      S1_am : OUT BIT; -- Led Amarelo semáforo 1
	      S1_vd : OUT BIT; -- Led Verde semáforo 1
	      S2_vm : OUT BIT; -- Led Vermelho semáforo 2
	      S2_am : OUT BIT; -- Led Amarelo semáforo 2
	      S2_vd : OUT BIT); -- Led Verde semáforo 2
END semaforo;

ARCHITECTURE arch_1 OF semaforo IS
    TYPE tipo_estado IS (EA, EB, EC, ED, EE, EF, EG, EH);
    SIGNAL estado_atual : tipo_estado;
    SIGNAL prox_estado  : tipo_estado;

BEGIN

-- Registrador de estado

    p_estado_reg: PROCESS(clk,clrn)
    BEGIN
       IF (clrn='0') THEN
           estado_atual <= EA;
       ELSIF (clk'EVENT AND clk='1') THEN
           estado_atual <= prox_estado;
       END IF;
    END PROCESS;

-- Função de transição de estado

     p_prox_estado: PROCESS(estado_atual, A, B )
     BEGIN
        CASE (estado_atual) IS
        WHEN EA => IF (B = '0') THEN
 		        prox_estado <= EA;
		   ELSIF ( A = '0' and B = '1' ) THEN
			prox_estado <= EE;
		   ELSE prox_estado <= EB;
 		   END IF;

        WHEN EB => IF (A = '0' and B = '1' ) THEN
			prox_estado <= EE;
		   ELSIF ( A = '1' and B = '1' ) THEN
			prox_estado <= EC;
 		   ELSE prox_estado <= EA;
 		   END IF;
	WHEN EC => IF (A = '0' and B = '1' ) THEN
			prox_estado <= EE;
		   ELSIF ( A = '1' and B = '1' ) THEN
			prox_estado <= ED;
 		   ELSE prox_estado <= EA;
 		   END IF;

	WHEN ED => IF ( B = '1' ) THEN
			prox_estado <= EE;
		   ELSE prox_estado <= EA;
 		   END IF;

	WHEN EE => prox_estado <= EF;
	
	WHEN EF => IF (A = '0' and B = '1' ) THEN
			prox_estado <= EF;
		   ELSIF ( A = '1' and B = '1' ) THEN
			prox_estado <= EG;
 		   ELSE prox_estado <= EH;
 		   END IF;	

	WHEN EG => prox_estado <= EH;

	WHEN EH => IF (A = '0' and B = '1' ) THEN
			prox_estado <= EC;
		   ELSIF ( A = '1' and B = '1' ) THEN
			prox_estado <= EB;
 		   ELSE prox_estado <= EA;
 		   END IF;

 	WHEN OTHERS=> prox_estado <= EA;
 	END CASE;
    END PROCESS;

    -- Output
    S1_vm <= '1' WHEN ( estado_atual = EF or estado_atual = EG or estado_atual = EH ) ELSE '0';
    S1_am <= '1' WHEN ( estado_atual = EE ) ELSE '0';
    S1_vd <= '1' WHEN ( estado_atual = EA or estado_atual = EB or estado_atual = EC or estado_atual = ED ) ELSE '0';

    S2_vm <= '1' WHEN ( estado_atual = EA or estado_atual = EB or estado_atual = EC or estado_atual = ED or estado_atual = EE ) ELSE '0';
    S2_am <= '1' WHEN ( estado_atual = EH ) ELSE '0';
    S2_vd <= '1' WHEN ( estado_atual = EF or estado_atual = EG ) ELSE '0';
	
END arch_1;

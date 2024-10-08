-- A: 000 -> ._
-- B: 001 -> _...
-- C: 010 -> _._.
-- D: 011 -> _..
-- E: 100 -> .
-- F: 101 -> .._.
-- G: 110 -> _ _.
-- H: 111 -> ....

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity morsa is
    Port ( clk   : in  STD_LOGIC;        -- Clock de 50 MHz
           sw0   : in  STD_LOGIC;        -- Entrada switch 0
           sw1   : in  STD_LOGIC;        -- Entrada switch 1
           sw2   : in  STD_LOGIC;        -- Entrada switch 2
           key0  : in  STD_LOGIC;        -- Botão para desligar
           key1  : in  STD_LOGIC;        -- Botão para ligar
           led0   : out STD_LOGIC);       -- Saída LED
end morsa;

architecture Behavioral of morsa is

-- sinais:
signal count    : INTEGER := 0;
signal state    : INTEGER := 0; -- Estado do LED e temporizador
signal running  : BOOLEAN := FALSE; -- se key1 = true, então running = true, ...
signal morse_signal : INTEGER := 0; -- Para controlar o sinal Morse, ele tem um numero inteiro para cada digito

-- tempos:
constant CLK_FREQ : INTEGER := 50000000;  -- 50MHz
constant DOT_TIME : INTEGER := CLK_FREQ / 2;   -- 0.5s para ponto
constant DASH_TIME : INTEGER := CLK_FREQ * 3 / 2; -- 1.5s para traço
constant SPACE_TIME : INTEGER := CLK_FREQ; -- 1.0s para intervalo

begin

process(clk)
begin
    if rising_edge(clk) then
        if key1 = '1' then
            running <= TRUE;  -- Liga o código Morse
            state <= 0; -- Reseta o estado para iniciar
            morse_signal <= 0; -- Reseta o sinal Morse
        elsif key0 = '1' then
            running <= FALSE; -- Desliga o código Morse
            led0 <= '0'; -- Garante que o LED está apagado
            count <= 0; -- Reseta o contador
        end if;

        if running then
            case state is
                when 0 =>  -- Aguardando sinal
                    led0 <= '0'; -- LED apagado
                    if sw0 = '0' and sw1 = '0' and sw2 = '0' then
                        morse_signal <= 0; -- Representa "A"
                        state <= 1; -- Inicia o primeiro sinal
                    elsif sw0 = '1' and sw1 = '0' and sw2 = '0' then
                        morse_signal <= 1; -- Representa "B"
                        state <= 1;
                    elsif sw0 = '0' and sw1 = '1' and sw2 = '0' then
                        morse_signal <= 2; -- Representa "C"
                        state <= 1;
                    elsif sw0 = '1' and sw1 = '1' and sw2 = '0' then
                        morse_signal <= 3; -- Representa "D"
                        state <= 1;
                    elsif sw0 = '0' and sw1 = '0' and sw2 = '1' then
                        morse_signal <= 4; -- Representa "E"
                        state <= 1;
                    elsif sw0 = '1' and sw1 = '0' and sw2 = '1' then
                        morse_signal <= 5; -- Representa "F"
                        state <= 1;
                    elsif sw0 = '0' and sw1 = '1' and sw2 = '1' then
                        morse_signal <= 6; -- Representa "G"
                        state <= 1;
                    elsif sw0 = '1' and sw1 = '1' and sw2 = '1' then
                        morse_signal <= 7; -- Representa "H"
                        state <= 1;
                    end if;

                when 1 =>  -- Executar sinal Morse
                    if morse_signal = 0 then  -- A (._)
                        if count < DOT_TIME then
                            led0 <= '1';  -- Acende o LED (ponto)
                        elsif count < DOT_TIME + SPACE_TIME then
                            led0 <= '0';  -- Apaga o LED (intervalo)
                        elsif count < DOT_TIME + SPACE_TIME + DASH_TIME then
                            led0 <= '1';  -- Acende o LED (traço)
                        elsif count < DOT_TIME + SPACE_TIME + DASH_TIME + SPACE_TIME then
                            led0 <= '0';  -- Apaga o LED (intervalo)
                        else -- depois de executar uma vez, não executa mais (não é infinito)
                            count <= 0; 
                            state <= 0; -- Retorna para aguardando sinal
                        end if;

                    elsif morse_signal = 1 then  -- B (-...)
                        if count < DASH_TIME then
                            led0 <= '1';  -- Acende o LED (traço)
                        elsif count < DASH_TIME + SPACE_TIME then
                            led0 <= '0';  -- Apaga o LED (intervalo)
                        elsif count < DASH_TIME + SPACE_TIME + DOT_TIME then
                            led0 <= '1';  -- Acende o LED (ponto)
                        elsif count < DASH_TIME + SPACE_TIME + DOT_TIME + SPACE_TIME then
                            led0 <= '0';  -- Apaga o LED (intervalo)
                        elsif count < DASH_TIME + SPACE_TIME + DOT_TIME + SPACE_TIME + DOT_TIME then
                            led0 <= '1';  -- Acende o LED (ponto)
                        elsif count < DASH_TIME + SPACE_TIME + DOT_TIME + SPACE_TIME + DOT_TIME + SPACE_TIME then
                            led0 <= '0';  -- Apaga o LED (intervalo)
                        elsif count < DASH_TIME + SPACE_TIME + DOT_TIME + SPACE_TIME + DOT_TIME + SPACE_TIME + DOT_TIME then
                            led0 <= '1';  -- Acende o LED (ponto)
                        else
                            count <= 0; 
                            state <= 0; -- Retorna para aguardando sinal
                        end if;

                    elsif morse_signal = 2 then  -- C (-.-.)
                        if count < DASH_TIME then
                            led0 <= '1';  -- Acende o LED (traço)
                        elsif count < DASH_TIME + SPACE_TIME then
                            led0 <= '0';  -- Apaga o LED (intervalo)
                        elsif count < DASH_TIME + SPACE_TIME + DOT_TIME then
                            led0 <= '1';  -- Acende o LED (ponto)
                        elsif count < DASH_TIME + SPACE_TIME + DOT_TIME + SPACE_TIME then
                            led0 <= '0';  -- Apaga o LED (intervalo)
                        elsif count < DASH_TIME + SPACE_TIME + DOT_TIME + SPACE_TIME + DASH_TIME then
                            led0 <= '1';  -- Acende o LED (traço)
                        elsif count < DASH_TIME + SPACE_TIME + DOT_TIME + SPACE_TIME + DASH_TIME + SPACE_TIME then
                            led0 <= '0';  -- Apaga o LED (intervalo)
                        elsif count < DASH_TIME + SPACE_TIME + DOT_TIME + SPACE_TIME + DASH_TIME + SPACE_TIME + DOT_TIME then
                            led0 <= '1';  -- Acende o LED (ponto)
                        else
                            count <= 0; 
                            state <= 0; -- Retorna para aguardando sinal
                        end if;

                    elsif morse_signal = 3 then  -- D (-..)
                        if count < DASH_TIME then
                            led0 <= '1';  -- Acende o LED (traço)
                        elsif count < DASH_TIME + SPACE_TIME then
                            led0 <= '0';  -- Apaga o LED (intervalo)
                        elsif count < DASH_TIME + SPACE_TIME + DOT_TIME then
                            led0 <= '1';  -- Acende o LED (ponto)
                        elsif count < DASH_TIME + SPACE_TIME + DOT_TIME + SPACE_TIME then
                            led0 <= '0';  -- Apaga o LED (intervalo)
                        elsif count < DASH_TIME + SPACE_TIME + DOT_TIME + SPACE_TIME + DOT_TIME then
                            led0 <= '1';  -- Acende o LED (ponto)
                        else
                            count <= 0; 
                            state <= 0; -- Retorna para aguardando sinal
                        end if;

                    elsif morse_signal = 4 then  -- E (.)
                        if count < DOT_TIME then
                            led0 <= '1';  -- Acende o LED (ponto)
                        elsif count < DOT_TIME + SPACE_TIME then
                            led0 <= '0';  -- Apaga o LED (intervalo)
                        else
                            count <= 0; 
                            state <= 0; -- Retorna para aguardando sinal
                        end if;

                    elsif morse_signal = 5 then  -- F (..-.)
                        if count < DOT_TIME then
                            led0 <= '1';  -- Acende o LED (ponto)
                        elsif count < DOT_TIME + SPACE_TIME then
                            led0 <= '0';  -- Apaga o LED (intervalo)
                        elsif count < DOT_TIME + SPACE_TIME + DOT_TIME then
                            led0 <= '1';  -- Acende o LED (ponto)
                        elsif count < DOT_TIME + SPACE_TIME + DOT_TIME + SPACE_TIME then
                            led0 <= '0';  -- Apaga o LED (intervalo)
                        elsif count < DOT_TIME + SPACE_TIME + DOT_TIME + SPACE_TIME + DASH_TIME then
                            led0 <= '1';  -- Acende o LED (traço)
								elsif count < DOT_TIME + SPACE_TIME + DOT_TIME + SPACE_TIME + DASH_TIME + SPACE_TIME then
                            led0 <= '0';  -- APAGA o LED (INTERVALO)
								elsif count < DOT_TIME + SPACE_TIME + DOT_TIME + SPACE_TIME + DASH_TIME + SPACE_TIME + DOT_TIME then
                            led0 <= '1';  -- Acende o LED (PONTO)
                        else
                            count <= 0; 
                            state <= 0; -- Retorna para aguardando sinal
                        end if;

                    elsif morse_signal = 6 then  -- G (--.)
                        if count < DASH_TIME then
                            led0 <= '1';  -- Acende o LED (traço)
                        elsif count < DASH_TIME + SPACE_TIME then
                            led0 <= '0';  -- Apaga o LED (intervalo)
								elsif count < DASH_TIME + SPACE_TIME + DASH_TIME then
                            led0 <= '1';  -- Acende o LED (traço)
                        elsif count < DASH_TIME + SPACE_TIME + DASH_TIME + SPACE_TIME	then
                            led0 <= '0';  -- Apaga o LED (intervalo)
                        elsif count < DASH_TIME + SPACE_TIME + DASH_TIME + SPACE_TIME + DOT_TIME then
                            led0 <= '1';  -- Acende o LED (ponto)
                        else
                            count <= 0; 
                            state <= 0; -- Retorna para aguardando sinal
                        end if;

                    elsif morse_signal = 7 then  -- H (....)
                        if count < DOT_TIME then
                            led0 <= '1';  -- Acende o LED (ponto)
                        elsif count < DOT_TIME + SPACE_TIME then
                            led0 <= '0';  -- Apaga o LED (intervalo)
                        elsif count < DOT_TIME + SPACE_TIME + DOT_TIME then
                            led0 <= '1';  -- Acende o LED (ponto)
                        elsif count < DOT_TIME + SPACE_TIME + DOT_TIME + SPACE_TIME then
                            led0 <= '0';  -- Apaga o LED (intervalo)
                        elsif count < DOT_TIME + SPACE_TIME + DOT_TIME + SPACE_TIME + DOT_TIME then
                            led0 <= '1';  -- Acende o LED (ponto)
                        elsif count < DOT_TIME + SPACE_TIME + DOT_TIME + SPACE_TIME + DOT_TIME + SPACE_TIME then
                            led0 <= '0';  -- Apaga o LED (intervalo)
                        elsif count < DOT_TIME + SPACE_TIME + DOT_TIME + SPACE_TIME + DOT_TIME + SPACE_TIME + DOT_TIME then
                            led0 <= '1';  -- Acende o LED (ponto)
                        else
                            count <= 0; 
                            state <= 0; -- Retorna para aguardando sinal
                        end if;

                    end if;

                    count <= count + 1; -- Incrementa o contador

                when others => 
                    state <= 0; -- Para garantir que o estado seja válido
            end case;
        else
            led0 <= '0'; -- Se não estiver rodando, garante que o LED está apagado
        end if;
    end if;
end process;

end Behavioral;

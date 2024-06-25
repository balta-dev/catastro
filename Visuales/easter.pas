unit easter;
{$IFDEF Windows} 
{$codepage UTF-8}
{$ENDIF}

interface

uses {$IFDEF Windows}  MMSystem, {$ENDIF}
	crt, keyboard, sysutils;

type line = array[1..28] of string;

procedure ewm(entrada:string);
procedure ee(entrada:string);
procedure eb2c(entrada:string);

implementation

procedure dibujarLetras();
var lineasDibujo:line;
i, j:byte;
begin

lineasDibujo[1] :=('                                         @@@@@@         @@@@@@@@         @@@@@     @@@@@@ @@@@@ @@@@@@@@@@@@  @@@@@@@@    @@@@@@ @@@                                          ');
lineasDibujo[2] :=('                                            @@@         @@@  @@@         @@@@@@   @@@  @@ @@@@@ @@@@@@        @@@@@@@@    @@@@@                                               ');
lineasDibujo[3] :=('                                          @@@@               @            @@@@@@ @@ @@@@  @@@@      @          @@@@@@@     @@@                                                ');
lineasDibujo[4] :=('                                          @@@@         @@@@ @@@@          @@@@@@@@@@@@@@  @@@@      @@@@     @@@@ @@@@@    @@@@  @@@@                                         ');
lineasDibujo[5] :=('                                          @@@@         @@@@@@@@@@         @@@@@@@@@ @@@@  @@@@      @@@@     @@@@@@@@@@    @@@@  @@@@                                         ');
lineasDibujo[6] :=('                                     @    @@@@   @@@  @@@@    @@@@        @@@@ @@@  @@@@  @@@@      @@@@    @@@@    @@@@   @@@@  @@@@                                         ');
lineasDibujo[7] :=('                                  @@@@@@@ @@@@@@@@@@ @@@@@    @@@@@      @@@@@  @  @@@@@@ @@@@@    @@@@@@  @@@@@   @@@@@@ @@@ @ @@@@@   @                                     ');
lineasDibujo[8] :=('                                 @@@@@@@@@@@@@@@@@@@ @@@@@    @@@@@@@@   @@@@@     @@@@@@ @@@@@    @@@@@@  @@@@@   @@@@@@ @@@@@@@@@  @@@@@@                                   ');
lineasDibujo[9] :=('                                     @                            @@@                                                                 @@@@@                                   ');
lineasDibujo[10] :=('                     @               @                                                                                                 @                                      ');
lineasDibujo[11] :=('                   @@                  @ @@@ @@     @@@@@@    @@@@@@@@     @@@@@@@@@@       @@@@@@ @@ @@@ @@@@@@  @@@@@@  @@@ @@@@@     @                  @                  ');
lineasDibujo[12] :=('                  @@@      @        @@@@@ @@@@@@@  @@@@@@@     @@@@@@@     @@@@@@@@@@@      @@@@@@ @@@@@@ @@@@@@@ @@@@@  @@@@@@@@@@@    @@                @                   ');
lineasDibujo[13] :=('                   @@@              @@@@@@ @@@@@@@@@@@@@@     @@@@@@@@     @@@@    @         @@@@   @@@@   @@@@@@@ @@@@  @@@@   @@@@ @@@@                @@@                  ');
lineasDibujo[14] :=('                   @@@@             @@@@@@ @@@@@@@@@@@@@@     @@@@ @@@@    @@@@@@@@@         @@@@   @@@@   @@@@@@@@@@@@  @@@@   @@@@  @@@@@@           @@@@                   ');
lineasDibujo[15] :=('                     @@@@@@@@@@@@@@@@@@    @@@@ @@@@ @@@@    @@@@@@@@@@@     @@@@@@@@@       @@@@   @@@@   @@@@@@@@@@@@  @@@@   @@@@    @@@@@@@@@@@@@@@@@                     ');
lineasDibujo[16] :=('                         @@@@@@@@@@        @@@@  @@  @@@@   @@@@    @@@@   @@@@  @@@@@       @@@@   @@@@   @@@@  @@@@@@  @@@@   @@@@       @@@@@@@@@@@@    @                  ');
lineasDibujo[17] :=('                                          @@@@@@    @@@@@@ @@@@@@   @@@@@  @@@@@@@@@@        @@@@@@@@@@@  @@@@@@  @@@@@@ @@@@@@@@@@                                           ');
lineasDibujo[18] :=('                                      @   @@@@@@    @@@@@@ @@@@@@   @@@@@    @@@@@@            @@@@@@@    @@@@@@   @@@@    @@@@@@                                             ');

for j:=1 to 18 do
begin
for i:=0 to 144 do
	begin
	
		if (copy(lineasDibujo[j], i, 1) = '@') then
		begin

			textcolor(yellow);	
			gotoxy(i-30, j+5);
			write('.');

		end

	end;

end;

end;

procedure dibujarLogo();
var lineasDibujo:line;
i,j:byte;
begin


lineasDibujo[1] :='                                            ------                ------                         ';
lineasDibujo[2] :='                                          ---*%%%------      ------%%%*---                       ';
lineasDibujo[3] :='                                       ----%%%%%%%%%%----------%%%%%%%%%%----                    ';
lineasDibujo[4] :='                                    ----%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%----                 ';
lineasDibujo[5] :='                                   ---%%%%-%%%--%%-%%--%%--%%--%%-%%%-%%%-%%%%---                ';
lineasDibujo[6] :='                                   --%%%%%%#%%%%%%%%%%%%%%%%%%%%%%%%%%%%-%%%%%%--                ';
lineasDibujo[7] :='                                   --%%-%%%%%%--%%-%%%-%%--%%-%%%-%%--%%%%%%-%%--                ';
lineasDibujo[8] :='                                   --%%%-%%%-%%%-%%%%%%%%%%%%%%%%%%-%%%-%%%-%%%--                ';
lineasDibujo[9] :='                                   --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--                ';
lineasDibujo[10] :='                                   --%%%%%-----%%%%%*---%%%%------%%%%%----%%%%--                ';
lineasDibujo[11] :='                                   ---%%%---%%--%%%%----%%%%---%---%%%%%--%%%%---                ';
lineasDibujo[12] :='                                    --%%%---%%%%%%%---%---%%%-------%%%%%--%%%%--                 ';
lineasDibujo[13] :='                                    --%%%---%%--%%--------%%---%---%---%--%%%%--                 ';
lineasDibujo[14] :='                                     --%%-------%----%%----%-------%------%%%--                  ';
lineasDibujo[15] :='                                     ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---                  ';
lineasDibujo[16] :='                                      --%%%--%%--%%--%%--%%--%%--%%--%%--%%%--                   ';
lineasDibujo[17] :='                                      ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---                   ';
lineasDibujo[18] :='                                       ---%%-%%%%-%%%-%%%--%%%-%%%-%%%%-%%---                    ';
lineasDibujo[19] :='                                        ---%%%%%%%%%%%%--%%--%%%%%%%%%%%%---                     ';
lineasDibujo[20] :='                                         ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%---                      ';
lineasDibujo[21] :='                                          ---%%%-%%%%-%%%--%%%-%%%%-%%%---                       ';
lineasDibujo[22] :='                                           ---%%%%-%%%%-%%%%-%%%%-%%%%---                        ';
lineasDibujo[23] :='                                            ---*%%%%%%%%%--%%%%%%%%%*---                         ';
lineasDibujo[24] :='                                              ---%%%#%%%%%%%%%%%%%%---                           ';
lineasDibujo[25] :='                                                ---%%%%-%%%%-%%%%---                             ';
lineasDibujo[26] :='                                                 ----%%%%--%%%%----                              ';
lineasDibujo[27] :='                                                    ----%%%%----                                 ';
lineasDibujo[28] :='                                                      --------                                   ';

for j:=1 to length(line) do
begin
for i:=0 to 119 do
	begin

		//writeln(copy(lineasDibujo[j], i, 1));
		//readkey;

		if (copy(lineasDibujo[j], i, 1) = '-') or (copy(lineasDibujo[j], i, 1) = '#') then
		begin

			textcolor(yellow);	textbackground(yellow);
			gotoxy(i, j);
			write('*');
			textcolor(white); textbackground(16);

		end
		else if (copy(lineasDibujo[j], i, 1) = '%') or (copy(lineasDibujo[j], i, 1) = '*') then
		begin

			textcolor(16); textbackground(9);
			gotoxy(i, j);
			write('|');
			textcolor(white); textbackground(yellow);

		end;

	end;
end;

end;

procedure emb();
var i,j:byte;
lineasDibujo:line;
begin

lineasDibujo[1] :=('           %%%       %%%           ');
lineasDibujo[2] :=('        %%*+++**%%%*++%+*%%        ');
lineasDibujo[3] :=('       %+++++++%+++%+++++++%       ');
lineasDibujo[4] :=('       %+++++++++++++++++++%       ');
lineasDibujo[5] :=('       %++%%%++%%+%%%++%%++%       ');
lineasDibujo[6] :=('        %+%+++%+%++%%+++%+%        ');
lineasDibujo[7] :=('        %+%%%+%+%%%%%+%%++%        ');
lineasDibujo[8] :=('         %+++++++++++++++%         ');
lineasDibujo[9] :=('         %%+++%+%+%+%+++%%         ');
lineasDibujo[10] :=('          %%+%+++++++%+%%          ');
lineasDibujo[11] :=('            %++%+%+%++%            ');
lineasDibujo[12] :=('             %%++%++%%             ');
lineasDibujo[13] :=('               %%+%%            ');

for j:=1 to length(line) do
begin
for i:=0 to 50 do
	begin

		if (copy(lineasDibujo[j], i, 1) = '%') or (copy(lineasDibujo[j], i, 1) = '*') then
		begin

			textcolor(yellow);	//%textbackground(yellow);
			gotoxy(i+86, j+9);
			write('*');
			textcolor(white); textbackground(16);

		end
		else if (copy(lineasDibujo[j], i, 1) = '+') or (copy(lineasDibujo[j], i, 1) = '#') then
		begin

			textcolor(white); //textbackground(9);
			gotoxy(i+86, j+9);
			write('.');
			textcolor(white); //textbackground(yellow);

		end;

	end;
end;

end;

procedure ewm(entrada:string);
begin

	entrada := upcase(entrada);
	if entrada = 'BRANDSEN 805' then
	begin

		textcolor(yellow);
		gotoxy(100, 26);
		writeln('LA MITAD *');
		textcolor(blue);
		gotoxy(102, 27);
		writeln('* MAS UNO');
		textcolor(white);
		emb;

	end;

end;

procedure eb();
begin

InitKeyboard;

	clrscr;
	{$IFDEF Windows} mciSendString('pause "Musica/background.mp3"',nil, 0, 0); {$ENDIF}
	{$IFDEF Windows}  mciSendString('play "Musica/easter.mp3"',nil, 0, 0); {$ENDIF}
	dibujarLetras;
	dibujarLogo;
	gotoxy(45, 20);
	textcolor(yellow);
	writeln('TERRENO INGRESADO CON ÉXITO');
	gotoxy(48, 21);
	writeln('Y SÍ, COMO BOQUITA!');

	if TKeyRecord(TranslateKeyEvent(GetKeyEvent)).KeyCode<>0 then begin {$IFDEF Windows} mciSendString('pause "Musica/easter.mp3"',nil, 0, 0); end; {$ENDIF}

DoneKeyboard;

end;

procedure eb2();
begin

	{$IFDEF Windows} mciSendString('play "Musica/arclb.mp3"',nil, 0, 0); {$ENDIF}
	sleep(2200);
	gotoxy(60, 26);
	writeln('A River cuando lo bailo, lo bailo de noche y de día..');
	sleep(4500);
	gotoxy(60, 27);
	write('¡A River lo vuelvo loco con la '); textcolor(lightblue); write('azul '); textcolor(yellow); write('y la amarilla!'); textcolor(white);
	sleep(4400);

end;

procedure eb2c(entrada:string);
begin

if entrada = '26/06/2011' then
begin
	textcolor(lightred);
	gotoxy(47, 15);
	write('26/');
	textcolor(white);
	write('06');
	textcolor(lightred);
	write('/2011');
	textcolor(white);
end;

end;

procedure ee(entrada:string);
begin

	entrada := upcase(entrada);

	case entrada of
	'BRANDSEN 805': eb;
	'26/06/2011': eb2;
	end;

end;

begin
end.

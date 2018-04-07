uses tambahan, fitur, sysutils;
var
	i,j,pos : integer;
	a : strukDat;
begin
	setLength(a,15);
	for i := Low(a) to High(a) do begin
		setLength(a[i],i+1);
		for j := Low(a[i]) to High(a[i]) do begin
			a[i][j] := IntToStr((i+1)*(j+1));
		end;
	end;
	//tampilkan
	for i := Low(a) to High(a) do begin
		for j := Low(a[i]) to High(a[i]) do begin
			write(a[i][j],' ');
		end;
		writeln;
	end;
	write('Masukkan indeks yang mau dihapus : ');
	readln(pos);
	delStrukDat(a,pos);
	//tampilkan
	for i := Low(a) to High(a) do begin
		for j := Low(a[i]) to High(a[i]) do begin
			write(a[i][j],' ');
		end;
		writeln;
	end;
end.
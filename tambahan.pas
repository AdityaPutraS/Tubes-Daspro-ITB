unit tambahan;

interface
	type
		miniArr = array of AnsiString;
		strukDat = array of array of AnsiString;
	function parseString(s : AnsiString):miniArr;
	procedure parseTanggal(s : AnsiString;var hari,bulan,tahun : integer);
	procedure delStrukDat(var arr : strukDat; pos : longint);
	
implementation
	uses sysutils;
	function parseString(s : AnsiString):miniArr;
	//parseString memotong  string a1 | a2 | a3 | a4 | a5 menjadi array yang berisi [a1,a2,a3,a4,a5]
	var
		temp : miniArr;
		i,j,awalKata,banyakHuruf,panjang : integer;
	begin
		//awal baris = i, awal kolom = j
		i := 1; j := 1;
		awalKata := 1; banyakHuruf := 1;
		panjang := length(s); //length mengembalikan panjang string
		//traversal dari i = 1 sampai akhir string, pake while buat jaga jaga aja
		while(i <= panjang) do begin
			//jika karakter ke i adalah | maka potong string dari indeks (awalKata) sepanjang (banyakHuruf) lalu dimasukkan ke array bernama temp
			if(s[i] = '|') then begin
				//setLength berguna untuk mengatur panjang array dinamis, dalam kasus ini panjang temp diset menjadi j
				SetLength(temp,j);
				//ini pake matematika, kenapa isi -1, karena sebelum | ada spasi, makanya dikurang 1
				banyakHuruf := i-awalKata-1;
				//copy syntaxnya Copy(s, i, n) outputya berupa string potongan dari s dari indeks ke-i dan panjang n huruf
				temp[j-1] := Copy(s,awalKata,banyakHuruf);
				//naikan variable awal kata sebanyak 2, karena setelah | ada spasi lagi
				awalKata := i+2;
				j += 1;
			end else begin
				//cek jika sudah sampai di ujung, maka langsung potong string s dari awalKata sampai akhir, lalu simpann di array temp
				if(i = panjang) then begin
					SetLength(temp,j);
					banyakHuruf := i-awalKata+1;
					temp[j-1] := Copy(s,awalKata,banyakHuruf);
				end;
			end;
			i += 1;
		end;
		parseString := temp;
	end;
	
	//ini kayaknya ga penting, tapi kasian kalo dihapus
	procedure parseTanggal(s : AnsiString;var hari,bulan,tahun : integer);
	var
		temp : miniArr;
		i,j,awalKata,banyakHuruf,panjang : integer;
	begin
		i := 1; j := 1;
		awalKata := 1; banyakHuruf := 1;
		panjang := length(s);
		while(i <= panjang) do begin
			if(s[i] = '/') then begin
				SetLength(temp,j);
				banyakHuruf := i-awalKata;
				temp[j-1] := Copy(s,awalKata,banyakHuruf);
				awalKata := i+1;
				j += 1;
			end else begin
				if(i = panjang) then begin
					SetLength(temp,j);
					banyakHuruf := i-awalKata+1;
					temp[j-1] := Copy(s,awalKata,banyakHuruf);
				end;
			end;
			i += 1;
		end;
		hari := StrToInt(temp[0]);
		bulan := StrToInt(temp[1]);
		tahun := StrToInt(temp[2]);
	end;
	
	procedure delStrukDat(var arr : strukDat; pos : longint);
	var
		i : longint;
	begin
		for i := pos to high(arr)-1 do begin
			arr[i] := arr[i+1];
		end;
		setLength(arr, length(arr)-1);
	end;
	
end.
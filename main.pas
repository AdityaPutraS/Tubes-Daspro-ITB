program main;
uses fitur,tambahan,sistem,sysutils;
var
	nomor,countIst,countMakan : longint;
	sav : strukDatSave;
	nomorSim, hariLewat, energi, maksInv, totBMentahBeli, totBOlahanBuat, totBOlahanJual, totResepJual, totPemasukan, totPengeluaran, totUang : longint;
	daftarBahMentah, listInvMentah, daftarBahOlahan, listInvOlahan, daftarResep, status : strukDat;
	input,tanggal,inputLuar,sug : AnsiString;
	sudahTidur : Boolean;
begin
	inputLuar := ''; nomor := 0;
	repeat
		write('>'); readln(inputLuar);
		//normalisasi input
		inputLuar := LowerCase(inputLuar);
		//mulai cek
		if(inputLuar = 'exit') then begin
			//validasi apakah sudah ada simulasi yang jalan dengan mengecek nomor simulasi sekarang
			if(nomor <> 0) then begin
				//jika nomor bukan 0, maka sudah ada simulasi yang berjalan
				save(sav);
				writeln('Semua data telah disimpan. Program selesai');
			end;
		end else begin
			if(inputLuar = 'load') then begin
				writeln('Mengeload semua data yang diperlukan.');
				load(sav);
				writeln('Load selesai.');
			end else begin
				if(inputLuar = 'startsimulasi') then begin
					write('Masukkan No. Simulasi : '); readln(nomor);
					//validasi nomor simulasi
					while(not( (nomor >= 1) and (nomor <= banyakSimulasi) )) do begin
						writeln('No. Simulasi salah, masukan antara 1 - ',banyakSimulasi);
						write('Masukkan No. Simulasi : '); readln(nomor);
					end;
					//nomor sudah benar, mulai simulasi
					writeln('Mengeload semua variable dari save game nomor ',nomor);
					loadToVar(nomor,sav,daftarBahMentah,listInvMentah,daftarBahOlahan,listInvOlahan,daftarResep,status); 
					loadStatus(status, nomorSim,tanggal, hariLewat, energi, maksInv, totBMentahBeli, totBOlahanBuat, totBOlahanJual, totResepJual, totPemasukan, totPengeluaran, totUang);
					writeln('Load sukses, simulasi dimulai');
					//mulai simulasi
						input := '';
						sudahTidur:=false;
						countIst:=0;
						countMakan:=0;
						repeat
							if(energi > 0) then begin
								//baca input
								write('>> '); readln(input);
								input := LowerCase(input);//normalisasi input dengan mengubahnya menjadi huruf kecil semua
								case input of
									'stopsimulasi'	 	: writeln('Simulasi berhenti.');
									'belibahan'			: beliBahan(daftarBahMentah,listInvMentah,listInvOlahan,maksInv,totBMentahBeli,totPengeluaran,energi,totUang,tanggal,hariLewat,sudahTidur);
									'olahbahan'			: olahBahan(energi,totBOlahanBuat,maksInv,daftarBahOlahan,daftarBahMentah,listInvMentah,listInvOlahan,tanggal,hariLewat,sudahTidur);
									'jualolahan'		: jualOlahan(energi,totPemasukan,totBOlahanJual,totUang,listInvOlahan,daftarBahOlahan,sudahTidur);
									'jualresep'			: jualResep (energi, totPemasukan,totResepJual,totUang,listInvOlahan, listInvMentah, daftarResep,sudahTidur);
									'makan'				: makan (countMakan,energi,sudahTidur);
									'istirahat'			: istirahat(countIst,energi,sudahTidur);
									'tidur'				: tidur(tanggal,hariLewat,energi,daftarBahMentah,listInvMentah,listInvOlahan,sudahTidur,countIst,countMakan); //harus diubah sistemnya, tanggal harusnya ga berubah, cuman hariLewat yang berubah
									'lihatstatistik'	: lihatStatistik(status,listInvMentah,listInvOlahan,sudahTidur);
									'lihatinventori'	: lihatInventori(listInvMentah, listInvOlahan,sudahTidur);
									'lihatresep'		: lihatResep(daftarResep,sudahTidur);
									'cariresep' 		: cariresep(daftarResep,sudahTidur);
									'tambahresep'		: tambahresep (daftarResep,daftarBahMentah,daftarBahOlahan,sudahTidur);
									'upgradeinventori'	: upgradeinventori(maksInv,totUang,sudahTidur);
									else begin
										//memberikan sugesti kepada user jika inputnya salah
										sug := sugesti(input);
										write('Perintah ',input,' tidak ditemukan.');
										if(not(sug = 'tidak ada')) then begin
											writeln('Mungkin yang anda maksud : ',sug);
										end else begin
											writeln;
										end;
									end;
								end;
								//mengsave semua variable status ke status untuk jaga jaga
								saveStatus(status,nomorSim,tanggal, hariLewat, energi, maksInv, totBMentahBeli, totBOlahanBuat, totBOlahanJual, totResepJual, totPemasukan, totPengeluaran, totUang);
							end else begin
								//memaksa pemain untuk tidur dengan tidak memberikannya opsi lain selain tidur :D
								repeat
									write('>> '); readln(input);
									input := LowerCase(input);
										if (input<>'tidur') then writeln('Energi habis, Anda hanya dapat tidur.');
								until(input='tidur');
								tidur(tanggal,hariLewat,energi,daftarBahMentah,listInvMentah,listInvOlahan,sudahTidur,countIst,countMakan);
								writeln('Hari telah berganti.');
							end;
						until( (input = 'stopsimulasi') or (hariLewat = 10) );
						//Pesan output jika program berhenti karena hari lewat
							if(hariLewat = 10) then begin
								writeln('Sudah lewat 10 hari,simulasi berhenti.');
							end;
						//tampilkan hasil simulasi
							lihatStatistik(status,listInvMentah,listInvOlahan,sudahTidur);
						//save semua variable ke array sav
							saveStatus(status,nomorSim,tanggal, hariLewat, energi, maksInv, totBMentahBeli, totBOlahanBuat, totBOlahanJual, totResepJual, totPemasukan, totPengeluaran, totUang);
							saveFromVar(nomor,sav,daftarBahMentah,listInvMentah,daftarBahOlahan,listInvOlahan,daftarResep,status); 
				end else begin
					writeln('Perintah tidak ditemukan.');
				end;
			end;
		end;
	until (inputLuar = 'exit');
end.
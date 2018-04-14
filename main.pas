program main;
uses fitur,tambahan,sistem,sysutils;
const
	banyakSimulasi = 3;
var
	nomor,countIst,countMakan : longint;
	nomorSim, hariLewat, energi, maksInv, totBMentahBeli, totBOlahanBuat, totBOlahanJual, totResepJual, totPemasukan, totPengeluaran, totUang : longint;
	daftarBahMentah, listInvMentah, daftarBahOlahan, listInvOlahan, daftarResep, status : strukDat;
	input,tanggal,inputLuar : AnsiString;
	sudahTidur : Boolean;
begin
	inputLuar := '';
	repeat
		write('> Masukkan No. Simulasi : '); readln(nomor);
		while(not( (nomor >= 1) and (nomor <= banyakSimulasi) )) do begin
			writeln('No. Simulasi salah, masukan antara 1 - ',banyakSimulasi);
			write('> Masukkan No. Simulasi : '); readln(nomor);
		end;
			input := '';
			load(IntToStr(nomor),daftarBahMentah, listInvMentah, daftarBahOlahan, listInvOlahan, daftarResep, status);
			//load semua variable status yang diperlukan
			loadStatus(status, nomorSim,tanggal, hariLewat, energi, maksInv, totBMentahBeli, totBOlahanBuat, totBOlahanJual, totResepJual, totPemasukan, totPengeluaran, totUang);
			sudahTidur:=false;
			countIst:=0;
			countMakan:=0;
			while((input <> 'cukupsudahhentikansimulasiini') and (hariLewat <> 10)) do begin
				if(energi > 0) then begin
					//baca input
					write('>> '); readln(input);
					input := LowerCase(input);//normalisasi input dengan mengubahnya menjadi huruf kecil semua
					case input of
						'belibahan' 		: beliBahan(daftarBahMentah,listInvMentah,listInvOlahan,maksInv,totBMentahBeli,totPengeluaran,energi,totUang, tanggal,sudahTidur);
						'save'				: begin
											  //save semua variable status ke array status
											  saveStatus(status, nomorSim,tanggal, hariLewat, energi, maksInv, totBMentahBeli, totBOlahanBuat, totBOlahanJual, totResepJual, totPemasukan, totPengeluaran, totUang);
											  //save semua array ke file eksternal
											  save(IntToStr(nomor), daftarBahMentah, listInvMentah, daftarBahOlahan, listInvOlahan, daftarResep, status);
											  end;
						'cariresep' 		: cariresep(daftarResep,sudahTidur);
						'tidur'				: tidur(tanggal,hariLewat,energi,daftarBahMentah,listInvMentah,listInvOlahan,sudahTidur);
						'lihatinventori' 	: lihatInventori(listInvMentah, listInvOlahan,sudahTidur);
						'lihatresep'		: lihatResep(daftarResep,sudahTidur);
						'istirahat'			: istirahat(countIst,energi,sudahTidur);
						'makan'				: makan (countMakan,energi,sudahTidur);
						'tambahresep'		: tambahresep (daftarResep,daftarBahMentah,daftarBahOlahan,sudahTidur);
						'upgradeinventori'	: upgradeinventori(maksInv,totUang,sudahTidur);
						'lihatstatistik'	: lihatStatistik(status,listInvMentah,listInvOlahan);
						'olahbahan'			: olahBahan(energi,totBOlahanBuat,maksInv,daftarBahOlahan,daftarBahMentah,listInvMentah,listInvOlahan,tanggal);
						'jualbahan'			: jualOlahan (energi,totPemasukan,totBOlahanJual,totUang,listInvOlahan,daftarBahOlahan);
						'jualresep'			: jualResep (energi, totPemasukan,totResepJual,totUang,listInvOlahan, listInvMentah, daftarResep);
						'stopsimulasi'		: begin
											  //save semua variable status ke array status
											  saveStatus(status, nomorSim,tanggal, hariLewat, energi, maksInv, totBMentahBeli, totBOlahanBuat, totBOlahanJual, totResepJual, totPemasukan, totPengeluaran, totUang);
											  //save semua array ke file eksternal
											  save(IntToStr(nomor), daftarBahMentah, listInvMentah, daftarBahOlahan, listInvOlahan, daftarResep, status);
											  input := 'cukupsudahhentikansimulasiini';
											  end;
					end;
				end else begin
					//hari yang telah dilewati bertambah 1 & mengisi ulang energi menjadi 10
					repeat
						write('>> '); readln(input);
						input := LowerCase(input);
							if (input<>'tidur') then writeln('Energi habis, Anda hanya dapat tidur.');
					until(input='tidur');
					writeln('Hari telah berganti.');
					tidur(tanggal,hariLewat,energi,daftarBahMentah,listInvMentah,listInvOlahan,sudahTidur);
				end;
			end;
	until (inputLuar = 'exit');
end.
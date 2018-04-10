unit fitur;
interface
	procedure jualOlahan();
implementation
	procedure jualOlahan (bahanOlahan : AnsiString; var listInvOlahan : listBahan);
		begin
	
		while ((bahanOlahan<>listInvOlahan.nama[i]) and (i<>listInvOlahan.nEff)) do
			begin
				i:=i+1;
			end;
			
		if (bahanOlahan = listInvOlahan.nama[i]) then
		begin
				val (listInvOlahan.jumlah[i] , jumlahOlahan);
				val (listInvOlahan.harga[i] , hargaJual);
				jumlahOlahan := jumlahOlahan -1; //mengurangi inventori
				energi := energi-1; //mengurangi energi
				totPemasukan:= totPemasukan+hargaJual; //menambah pemasukan
				totBOlahanJual := totBolahanJual+1;//menambah jumlah bahan olahan dijual
		end;
		saveStatus(status, nomorSim,tanggal, hariLewat, energi, maksInv, totBMentahBeli, totBOlahanBuat, totBOlahanJual, totResepJual, totPemasukan, totPengeluaran, totUang);
		save(daftarBahMentah, listInvMentah, daftarBahOlahan, listInvOlahan, daftarResep, status);
		end;
end.
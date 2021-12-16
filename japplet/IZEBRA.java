package net.is_bg.ltf.japplet;

import java.io.IOException;

public interface IZEBRA {

		public void Append(String s) throws IOException;

		public void Print() throws IOException;
		
		public String FindPrinter(String Printer) throws IOException;

}

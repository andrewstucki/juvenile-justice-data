package juvenile;

import java.io.FileOutputStream;
import java.io.IOException;
import static java.lang.System.out;
 
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Font.FontFamily;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfImportedPage;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.awt.geom.AffineTransform;
import com.itextpdf.text.pdf.draw.LineSeparator;

public class Merger {
    private String[] sources;
    private String destination;
    private String city;
    private BaseFont bf;
    
    private final int COL1 = 72;
    private final int COL2 = 324;
    private final int ROW6 = 60;
    private final int ROW5 = 158;
    private final int ROW4 = 256;
    private final int ROW3 = 354;
    private final int ROW2 = 452;
    private final int ROW1 = 550;
    
    public Merger(String cityName, String outputFile, String... inputFiles) {
      city = cityName;
      destination = outputFile;
      sources = inputFiles;
      try {
        bf = BaseFont.createFont();
      } catch (DocumentException e) {
      } catch (IOException e) {
      }
    }
 
 
    public void writeOutput(PdfContentByte canvas, PdfImportedPage page, int row, int col) {
        canvas.saveState();
        canvas.concatCTM(AffineTransform.getTranslateInstance(row, col)); //set x,y value
        canvas.addTemplate(page, 1f, 0, 0, 1, 0, 0);
        canvas.restoreState();
    }
    
    public void writeTitle(PdfContentByte canvas, String title) {
      canvas.beginText();
      canvas.setFontAndSize(bf, 36);
      canvas.showTextAligned(Element.ALIGN_LEFT, title, 72, 684, 0);
      canvas.endText();
      
      canvas.saveState();
      canvas.setLineWidth(3);
      canvas.moveTo(72, 682);
      canvas.lineTo(540,682);
      canvas.stroke();
      canvas.restoreState();
    }
    /**
     * Main method.
     * @param    args    no arguments needed
     * @throws DocumentException 
     * @throws IOException
     */
    public void merge()
        throws IOException, DocumentException {
        // step 1
        Document document = new Document(PageSize.LETTER);
        // step 2
        PdfWriter writer
            = PdfWriter.getInstance(document, new FileOutputStream(destination));
        // step 3
        document.open();
        // step 4
        
        PdfContentByte canvas = writer.getDirectContent();
        PdfImportedPage page;
        int wrap;
        int numGraphs;

        writeTitle(canvas, city);
        
        System.out.println("Done with name");

        numGraphs = sources.length;
        for (int i=0; i < numGraphs; i++) {
            // Create a reader object
            System.out.println("opening " + sources[i]);
            PdfReader reader = new PdfReader(sources[i]);
            page = writer.getImportedPage(reader, 1);
            System.out.println("grabbed page!");
            wrap = i % 12;
            switch (wrap) {
              case 0: if (i != 0) {document.newPage(); writeTitle(canvas, city + " (cont.)");} writeOutput(canvas, page, COL1, ROW1);
                break;
              case 1: writeOutput(canvas, page, COL1, ROW2);
                break;
              case 2: writeOutput(canvas, page, COL1, ROW3);
                break;
              case 3: writeOutput(canvas, page, COL1, ROW4);
                break;
              case 4: writeOutput(canvas, page, COL1, ROW5);
                break;
              case 5: writeOutput(canvas, page, COL1, ROW6);
                break;
              case 6: writeOutput(canvas, page, COL2, ROW1);
                break;
              case 7: writeOutput(canvas, page, COL2, ROW2);
                break;
              case 8: writeOutput(canvas, page, COL2, ROW3);
                break;
              case 9: writeOutput(canvas, page, COL2, ROW4);
                break;
              case 10: writeOutput(canvas, page, COL2, ROW5);
                break;
              case 11: writeOutput(canvas, page, COL2, ROW6);
                break;
            }
        }    
        // step 5
        document.close();
    }
    
    public static void main(String[] args)
      throws IOException, DocumentException {
      Merger merger = new Merger("output/out.pdf","output/test.pdf");
      merger.merge();
    }
}

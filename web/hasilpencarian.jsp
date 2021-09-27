<%-- 
    Document   : hasilpencarian
    Created on : Jan 18, 2021, 5:03:04 PM
    Author     : USER
--%>
<%@ page import="com.hp.hpl.jena.rdf.model.ModelFactory" %>
<%@ page import="com.hp.hpl.jena.ontology.OntModel" %>
<%@ page import="com.hp.hpl.jena.ontology.OntModelSpec" %>
<%@ page import="com.hp.hpl.jena.query.ResultSet" %>
<%@ page import="com.hp.hpl.jena.util.FileManager" %>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Collection" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.List" %>
<%@ page import="java.io.*" %>
<%@ page import="org.dom4j.Document" %>
<%@ page import="org.dom4j.Element" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<html>
    <head><link href="css/style.css" rel="stylesheet"></head>
    <body>
        <div id="terkait">
            <%
                String terkait;
                terkait = request.getParameter("keyword");
                if (terkait != null) {
                    out.print("\n Menampilkan pencarian dari : \n" + terkait);
                }
            %>
            
        </div>
        <div id="katakunci">
            <%! String search = "";
                    ServletContext sc = null;
                    OntModel model = null;
                    mysemantic.sparqlUtil util = new mysemantic.sparqlUtil();
                    String prefix = "";
                    
                    public String readFile(String inputFileName) {
                        String Prefix = "";
                        try {
                            model = ModelFactory.createOntologyModel(OntModelSpec.OWL_MEM_RDFS_INF);
                            InputStream in = FileManager.get().open(sc.getRealPath("/" + inputFileName));
                            if (in == null) {
                                throw new IllegalArgumentException("File : ”+inputFileName +not found");
                            }
                            //akhir dari if
                            model.read(new InputStreamReader(in), "");
                            //  }catch(Exception e){ System.out.println(""+e.getMessage());}
                            Map map = model.getNsPrefixMap();
                            Collection collection = map.values();
                            Iterator it = collection.iterator();
                            for (; it.hasNext();) //mengambil prefix yang digunakan
                            {
                                String ns = it.next().toString();
                                Prefix = model.getNsURIPrefix(ns);
                                if (Prefix != "") {
                                    prefix += "PREFIX " + Prefix + ":";
                                } else {
                                    prefix += "PREFIX " + ": ";
                                }
                                prefix += "<" + ns + ">\r\n";
                            }
                        } //end dari try
                        catch (Exception e) {
                            e.printStackTrace();
                        }
                        return prefix;
                    }
                    
                    private String parseSearchKeys1(String searchText) {
                    String queryString = prefix + "\nPREFIX : <http://www.semanticweb.org/sabila/ontologies/2021/0/kosjogja.owl.owl#>\n"
                            + "SELECT DISTINCT ?Nama_Kos ?Jenis_Kos ?FasilitasKos ?Tipe_Bayar ?LokasiKos ?HargaKos\n"
                            + "WHERE {{?Kos :berada_di ?Lokasi.}"
                            + "{?Kos :nama_kos ?Nama_Kos.}"
                            + "{?Kos :jenis_kos ?Jenis_Kos.}"
                            + "{?Kos :memiliki_fasilitas ?Fasilitas.}"
                            + "{?Fasilitas :fasilitas ?FasilitasKos.}"
                            + "{?Kos :dibayar_setiap ?WaktuBayar.}"
                            + "{?WaktuBayar :tipe_bayar ?Tipe_Bayar.}"
                            + "{?Lokasi :lokasi ?LokasiKos.}"
                            + "{?Kos :memiliki_harga ?Harga.}"
                            + "{?Harga :harga ?HargaKos.}"     

                            + "FILTER (REGEX(str(?Jenis_Kos),'" + searchText + "','i'))" 

        ;
                    queryString += "} ORDER BY ?Nama_Kos";
                    return queryString;
                } 
              
                private String parseResult(Document d) {
                    String returnValue;
                    int nomor;
                    List list = d.getRootElement().element("results").elements("result");
                    if (list.size() != 0) {
                        returnValue = "Total hasil pencarian : " + list.size();
                        //returnValue = "";
                        for (int i = 0; i < list.size(); i++) {
                            nomor = i + 1;
                            returnValue += "<table border='0'>";
                            Element elm = (Element) list.get(i);
                            List column = elm.elements("binding");
                            for (int j = 0; j < column.size(); j++) {
                                Element variable = (Element) column.get(j);
                                String attribute = variable.attributeValue("name");
                                String value = "";

                                if (variable.element("literal") != null) {
                                    value += variable.element("literal").getData().toString();
                                } else if (variable.element("unbound") != null) {
                                    value += "-";
                                }
                                if (attribute.equals("Nama_Kos")) {
                                    returnValue += "<tr><td rowspan='10' valign ='top'><b>" + nomor + ".&nbsp&nbsp&nbsp&nbsp<b></td><td align='left' width='150' style='padding:3px;'><b>Nama Kos</b></td><td> : </td><td align='left' > " + value + "</td></tr><hr>";
                                }
                                else if (attribute.equals("Jenis_Kos")) {
                                    returnValue += "<tr><td width='120' align='left' style='padding:3px;'><b>Jenis Kos</b></td><td> : </td><td align='left' > " + value + "</td></tr>";
                                }
                                else if (attribute.equals("FasilitasKos")) {
                                    returnValue += "<tr><td width='100' align='left' style='padding:3px;'><b>Fasilitas</b></td><td> : </td><td align='left' > " + value + "</td></tr>";
                                }
                                else if (attribute.equals("Tipe_Bayar")) {
                                    returnValue += "<tr><td width='100' align='left' style='padding:3px;'><b>Tipe Bayar</b></td><td> : </td><td align='left' > " + value + "</td></tr>";
                                }
                                else if (attribute.equals("LokasiKos")) {
                                    returnValue += "<tr><td width='100' align='left' style='padding:3px;'><b>Lokasi Kos</b></td><td> : </td><td align='left' > " + value + "</td></tr>";
                                }  
                                else if (attribute.equals("HargaKos")) {
                                    returnValue += "<tr><td width='100' align='left' style='padding:3px;'><b>Harga</b></td><td> : </td><td align='left' > " + value + "</td></tr>";
                                }
                                else {
                                    returnValue += "<br/><b>" + attribute + "</b>:" + value;
                                }
                            }
                            returnValue += "</table>";
                        }

                        returnValue += "</ol>";
                    } else {
                        returnValue = " Data tidak ditemukan, silahkan cari dengan kata kunci atau kriteria lain";
                    }
                    return returnValue;

                }
                    public Document displayResult1(PrintWriter out, String searchText) throws Exception {

                    String queryText = parseSearchKeys1(searchText);
                    Document result = util.prepareResult(util.execute(model, queryText), false);
                    return result;
                }
                    %>       
          </div>
          <% long start = System.currentTimeMillis();%>

        <table width="100%" border="0">  
            <tr>
                <td>&nbsp;</td>
                <td>
                    <%  response.setContentType("text/html");
                        PrintWriter outs = response.getWriter();
                        sc = getServletConfig().getServletContext();


                        try {
                            search = request.getParameter("keywordbutton");
                            String searchText = request.getParameter("keyword");
                            prefix = readFile("kosjogja.owl");
                            if (search != null) {
                                if (searchText.equals("")) {
                                    String msg = "* Type the keyword...";
                                    String alamat = "index.jsp";
                                    String str_url = alamat + "?msg=" + msg;
                                    response.sendRedirect(str_url);
                                }
                                Document hasil1 = displayResult1(outs, searchText);
                                if (parseResult(hasil1) != null) {
                                    out.println(parseResult(hasil1));                                
                                } 
                                else {
                                     out.print("\nMaaf, Data tidak ditemukan ");
                                }

                            }
                        } catch (Exception ex) {
                            out.println("Exception: " + ex);
                            ex.printStackTrace(outs);
                        }
                    %>  
                </td> 
                <td>&nbsp;</td></tr>
            <tr> 
                <td align="center"  colspan="3" bgcolor="#FFF">&nbsp</td> 
            </tr>
        </table>
                 <% long end = System.currentTimeMillis();%>

        <div id="terkait">
            <%
                String waktu;
                waktu = request.getParameter("keyword");
                if (waktu != null) {
                    out.print("\nWaktu yang diperlukan untuk proses adalah " + ((end - start) / 1000.0) + " detik");
                }
            %>
        </div>
    </body>
</html>
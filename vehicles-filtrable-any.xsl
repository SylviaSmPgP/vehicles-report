<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
    <html>
      <head>
        <title>Informe de Vehicles</title>
        <style>
          table { border-collapse: collapse; width: 100%; margin-top: 1em; }
          th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
          th { background-color: #f2f2f2; }
          .verd { background-color: #d4edda; }
        </style>
        <script>
          function aplicarFiltres() {
            const tipusFiltre = document.getElementById("tipusSelect").value;
            const anyFiltre = document.getElementById("anySelect").value;
            const files = document.querySelectorAll("table tbody tr");
            files.forEach(row => {
              const tipus = row.getAttribute("data-tipus");
              const any = row.getAttribute("data-any");
              const visibleTipus = (tipusFiltre === "Tots" || tipus === tipusFiltre);
              const visibleAny = (anyFiltre === "Tots" || any === anyFiltre);
              row.style.display = (visibleTipus &amp;&amp; visibleAny) ? "" : "none";
            });
          }
        </script>
      </head>
      <body>
        <h1>Vehicles</h1>

        <label for="tipusSelect">Filtrar per tipus:</label>
        <select id="tipusSelect" onchange="aplicarFiltres()">
          <option value="Tots">Tots</option>
          <option value="Elèctric">Elèctric</option>
          <option value="SUV">SUV</option>
          <option value="Sedan">Sedan</option>
        </select>

        <label for="anySelect">Filtrar per any:</label>
        <select id="anySelect" onchange="aplicarFiltres()">
          <option value="Tots">Tots</option>
          <option value="2023">2023</option>
          <option value="2022">2022</option>
          <option value="2021">2021</option>
          <option value="2020">2020</option>
        </select>

        <table>
          <thead>
            <tr>
              <th>Marca</th>
              <th>Model</th>
              <th>Any</th>
              <th>Tipus</th>
              <th>Preu (€)</th>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each select="concessionari/vehicle">
              <xsl:sort select="any" data-type="number" order="descending"/>
              <tr>
                <xsl:attribute name="data-tipus"><xsl:value-of select="tipus"/></xsl:attribute>
                <xsl:attribute name="data-any"><xsl:value-of select="any"/></xsl:attribute>
                <xsl:attribute name="class">
                  <xsl:if test="autonomia &gt; 400">verd</xsl:if>
                </xsl:attribute>
                <td><xsl:value-of select="marca"/></td>
                <td><xsl:value-of select="model"/></td>
                <td><xsl:value-of select="any"/></td>
                <td><xsl:value-of select="tipus"/></td>
                <td><xsl:value-of select="preu"/></td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>

        <h2>Resum vehicles elèctrics</h2>
        <xsl:variable name="preusElectric" select="concessionari/vehicle[tipus='Elèctric']/preu"/>
        <xsl:variable name="totalElectric" select="count($preusElectric)"/>
        <xsl:variable name="sumaElectric" select="sum($preusElectric)"/>
        <p>Total de vehicles elèctrics: <xsl:value-of select="$totalElectric"/></p>
        <p>Preu mitjà dels vehicles elèctrics:
          <xsl:value-of select="format-number($sumaElectric div $totalElectric, '###,##0.00')"/> €
        </p>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>

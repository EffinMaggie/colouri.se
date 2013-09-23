<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:xhtml="http://www.w3.org/1999/xhtml"
              xmlns:colour="http://colouri.se/2012"
              xmlns="http://www.w3.org/1999/xhtml"
              version="1.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8"
              doctype-public="-//W3C//DTD XHTML 1.1//EN"
              doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
              indent="no"
              media-type="application/xhtml+xml" />

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template name="precision">
    <xsl:param name="precision"/>
    <xsl:param name="link"/>
    <ul id="precision">
      <li>Precision</li>
      <xsl:if test="$precision > 6"><li><a href="{$link}.{$precision -6}"><xsl:value-of select="$precision -6"/></a></li></xsl:if>
      <xsl:if test="$precision > 5"><li><a href="{$link}.{$precision -5}"><xsl:value-of select="$precision -5"/></a></li></xsl:if>
      <xsl:if test="$precision > 4"><li><a href="{$link}.{$precision -4}"><xsl:value-of select="$precision -4"/></a></li></xsl:if>
      <xsl:if test="$precision > 3"><li><a href="{$link}.{$precision -3}"><xsl:value-of select="$precision -3"/></a></li></xsl:if>
      <xsl:if test="$precision > 2"><li><a href="{$link}.{$precision -2}"><xsl:value-of select="$precision -2"/></a></li></xsl:if>
      <xsl:if test="$precision > 1"><li><a href="{$link}.{$precision -1}"><xsl:value-of select="$precision -1"/></a></li></xsl:if>
      <li class="current"><a href="{$link}.{$precision}"><xsl:value-of select="$precision"/></a></li>
      <li><a href="{$link}.{$precision +1}"><xsl:value-of select="$precision +1"/></a></li>
      <li><a href="{$link}.{$precision +2}"><xsl:value-of select="$precision +2"/></a></li>
      <li><a href="{$link}.{$precision +3}"><xsl:value-of select="$precision +3"/></a></li>
      <li><a href="{$link}.{$precision +4}"><xsl:value-of select="$precision +4"/></a></li>
      <li><a href="{$link}.{$precision +5}"><xsl:value-of select="$precision +5"/></a></li>
      <li><a href="{$link}.{$precision +6}"><xsl:value-of select="$precision +6"/></a></li>
    </ul>
  </xsl:template>

  <xsl:template match="colour:precision">
    <xsl:param name="link"/>
    <xsl:call-template name="precision">
      <xsl:with-param name="precision" select="."/>
      <xsl:with-param name="link" select="$link"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="main-page">
    <xsl:param name="colour"/>
    <xsl:param name="link"/>
    <html style="background: {$colour}">
      <head>
        <title>Colour</title>
      </head>
      <body>
        <ul class="set">
          <xsl:for-each select="colour:colour">
            <li><xsl:apply-templates select="."/></li>
          </xsl:for-each>
        </ul>
        <xsl:apply-templates select="colour:picker"/>
        <xsl:choose>
          <xsl:when test="colour:precision">
            <xsl:apply-templates select="colour:precision">
              <xsl:with-param name="link" select="$link"/>
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="precision">
              <xsl:with-param name="precision">24</xsl:with-param>
              <xsl:with-param name="link" select="$link"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="/colour:set[colour:colour[1][@space='hsl']]">
    <xsl:variable name="hueDenominator"><xsl:choose>
      <xsl:when test="colour:colour[1]/@hueDenominator"><xsl:value-of select="colour:colour[1]/@hueDenominator"/></xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:variable name="saturationDenominator"><xsl:choose>
      <xsl:when test="colour:colour[1]/@saturationDenominator"><xsl:value-of select="colour:colour[1]/@saturationDenominator"/></xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:variable name="lightnessDenominator"><xsl:choose>
      <xsl:when test="colour:colour[1]/@lightnessDenominator"><xsl:value-of select="colour:colour[1]/@lightnessDenominator"/></xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:call-template name="main-page">
      <xsl:with-param name="colour" select="concat('hsl(', colour:colour[1]/@hue div $hueDenominator * 360, ',', colour:colour[1]/@saturation div $saturationDenominator * 100, '%,', colour:colour[1]/@lightness div $lightnessDenominator * 100, '%)')"/>
      <xsl:with-param name="link" select="concat('/hsl:', colour:colour[1]/@hue,'/', $hueDenominator, ':', colour:colour[1]/@saturation, '/', $saturationDenominator, ':', colour:colour[1]/@lightness, '/', $lightnessDenominator)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="/colour:set[colour:colour[1][@space='rgb']]">
    <xsl:variable name="redDenominator"><xsl:choose>
      <xsl:when test="colour:colour[1]/@redDenominator"><xsl:value-of select="colour:colour[1]/@redDenominator"/></xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:variable name="greenDenominator"><xsl:choose>
      <xsl:when test="colour:colour[1]/@greenDenominator"><xsl:value-of select="colour:colour[1]/@greenDenominator"/></xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:variable name="blueDenominator"><xsl:choose>
      <xsl:when test="colour:colour[1]/@blueDenominator"><xsl:value-of select="colour:colour[1]/@blueDenominator"/></xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:call-template name="main-page">
      <xsl:with-param name="colour" select="concat('rgb(', colour:colour[1]/@red div $redDenominator * 100, '%,', colour:colour[1]/@green div $greenDenominator * 100, '%,', colour:colour[1]/@blue div $blueDenominator * 100, '%)')"/>
      <xsl:with-param name="link" select="concat('/rgb:', colour:colour[1]/@red,'/', $redDenominator, ':', colour:colour[1]/@green, '/', $greenDenominator, ':', colour:colour[1]/@blue, '/', $blueDenominator)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="link-colour">
    <xsl:param name="colour"/>
    <xsl:param name="link"/>
    <xsl:param name="name"/>
    <xsl:variable name="precision"><xsl:if test="preceding::colour:precision[1]">.<xsl:value-of select="preceding::colour:precision[1]"/></xsl:if></xsl:variable>
    <a style="background: {$colour}" href="{$link}{$precision}">
      <xsl:choose>
        <xsl:when test="@type='small'">
          <xsl:attribute name="class">colour small</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">colour</xsl:attribute><xsl:value-of select="$name"/>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:template>

  <xsl:template match="colour:colour[@space='hsl']">
    <xsl:variable name="hueDenominator"><xsl:choose>
      <xsl:when test="@hueDenominator"><xsl:value-of select="@hueDenominator"/></xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:variable name="saturationDenominator"><xsl:choose>
      <xsl:when test="@saturationDenominator"><xsl:value-of select="@saturationDenominator"/></xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:variable name="lightnessDenominator"><xsl:choose>
      <xsl:when test="@lightnessDenominator"><xsl:value-of select="@lightnessDenominator"/></xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:call-template name="link-colour">
      <xsl:with-param name="colour" select="concat('hsl(', @hue div $hueDenominator * 360, ',', @saturation div $saturationDenominator * 100, '%,', @lightness div $lightnessDenominator * 100, '%)')"/>
      <xsl:with-param name="link" select="concat('/hsl:', @hue,'/', $hueDenominator, ':', @saturation, '/', $saturationDenominator, ':', @lightness, '/', $lightnessDenominator)"/>
      <xsl:with-param name="name" select="concat('(H, S, L) = (', @hue,'/', $hueDenominator, ', ', @saturation, '/', $saturationDenominator, ', ', @lightness, '/', $lightnessDenominator, ')')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="colour:colour[@space='rgb']">
    <xsl:variable name="redDenominator"><xsl:choose>
      <xsl:when test="@redDenominator"><xsl:value-of select="@redDenominator"/></xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:variable name="greenDenominator"><xsl:choose>
      <xsl:when test="@greenDenominator"><xsl:value-of select="@greenDenominator"/></xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:variable name="blueDenominator"><xsl:choose>
      <xsl:when test="@blueDenominator"><xsl:value-of select="@blueDenominator"/></xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:call-template name="link-colour">
      <xsl:with-param name="colour" select="concat('rgb(', @red div $redDenominator * 100, '%,', @green div $greenDenominator * 100, '%,', @blue div $blueDenominator * 100, '%)')"/>
      <xsl:with-param name="link" select="concat('/rgb:', @red,'/', $redDenominator, ':', @green, '/', $greenDenominator, ':', @blue, '/', $blueDenominator)"/>
      <xsl:with-param name="name" select="concat('(R, G, B) = (', @red,'/', $redDenominator, ', ', @green, '/', $greenDenominator, ', ', @blue, '/', $blueDenominator, ')')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="colour:picker">
    <table class="picker">
      <xsl:apply-templates select="colour:set"/>
    </table>
  </xsl:template>

  <xsl:template match="colour:picker/colour:set">
    <tr>
      <xsl:for-each select="colour:colour">
        <td><xsl:apply-templates select="."/></td>
      </xsl:for-each>
    </tr>
  </xsl:template>
</xsl:stylesheet>

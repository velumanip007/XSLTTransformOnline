<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tns="http://www.temenos.com/T24/event/OutwardMappingForCR/doOutwardMappingForCR" xmlns:ns0="http://www.temenos.com/T24/event/Common/EventCommon" xmlns:ns1="http://www.temenos.com/T24/CancellationRequestService/PaymentHeader" xmlns:ns2="http://www.temenos.com/T24/CancellationRequestService/PorTransactionRTGS" xmlns:ns3="http://www.temenos.com/T24/CancellationRequestService/PpCanReq" xmlns:ns4="http://www.temenos.com/T24/CancellationRequestService/PorCoverInfo" xmlns:ns5="http://www.temenos.com/T24/CancellationRequestService/PaymentFlowDets" xmlns:ns6="http://www.temenos.com/T24/CancellationRequestService/PorOutboundInfo" xmlns:ns7="http://www.temenos.com/T24/CancellationRequestService/PaymentRecord" xmlns:ns8="http://www.temenos.com/T24/CancellationRequestService/AdditionalPaymentDets" xmlns:ns9="http://www.temenos.com/T24/CancellationRequestService/PorInformation" xmlns:ns10="http://www.temenos.com/T24/CancellationRequestService/PorAdditionalInf" xmlns:ns11="http://www.temenos.com/T24/CancellationRequestService/PorExtendedInfo" xmlns:ns12="http://www.temenos.com/T24/CancellationRequestService/PorPartyCredit" xmlns:ns13="http://www.temenos.com/T24/CancellationRequestService/PorPartyDebit" xmlns:ns14="http://www.temenos.com/T24/CancellationRequestService/PorAccountInfo" xmlns:ns15="http://www.temenos.com/T24/CancellationRequestService/PorRemittanceInfoPart2" xmlns:ns16="http://www.temenos.com/T24/CancellationRequestService/PorExtentedRemittanceInfo" xmlns:ns17="http://www.temenos.com/T24/CancellationRequestService/PorRelatedRemittanceInfo" xmlns:ns18="http://www.temenos.com/T24/event/OutwardMappingForCR/doOutwardMappingForCR" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="1.0" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="ns0 ns1 ns2 ns3 ns4 ns5 ns6 ns7 ns8 ns9 ns10 ns11 ns12 ns13 ns14 ns15 ns16 ns17 ns18 exsl xs">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:template name="RfrdDocinf">
        <xsl:param name="element" select="1"/>
        <xsl:param name="count" select="1"/>
        <RfrdDocInf xmlns="urn:iso:std:iso:20022:tech:xsd:camt.111.001.02">
            <xsl:for-each select=" ns16:rfrDocInfTpCdOrPropCd ">
                <xsl:if test="$count = position()">
                    <xsl:if test="ns16:Value and ns16:Value != 'NOTAPPLICABLE'">
                        <Tp>
                            <CdOrPrtry>
                                <Cd>
                                    <xsl:value-of select="ns16:Value"/>
                                </Cd>
                            </CdOrPrtry>
                        </Tp>
                    </xsl:if>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="ns16:rfrDocInfNr">
                <xsl:if test="$count = position()">
                    <xsl:if test="ns16:Value and ns16:Value != 'NOTAPPLICABLE'">
                        <Nb>
                            <xsl:value-of select="ns16:Value"/>
                        </Nb>
                    </xsl:if>
                </xsl:if>
            </xsl:for-each>
        </RfrdDocInf>
        <xsl:if test="$element &gt; 1">
            <xsl:call-template name="RfrdDocinf">
                <xsl:with-param name="element" select="number($element)-1"/>
                <xsl:with-param name="count" select="number($count)+1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="getAgentRole">
        <xsl:param name="agentName"/>
        <xsl:choose>
            <xsl:when test="$agentName != '' and $agentName = 'Agent - Instructing reimbursement agent'">
                <xsl:value-of select="'SNDCBK$G'"/>
            </xsl:when>
            <xsl:when test="$agentName != '' and $agentName = 'Agent - Instructed reimbursement agent'">
                <xsl:value-of select="'RCVCBK$G'"/>
            </xsl:when>
            <xsl:when test="$agentName != '' and $agentName = 'Agent - Third reimbursement agent'">
                <xsl:value-of select="'TRMINS$G'"/>
            </xsl:when>
            <xsl:when test="$agentName != '' and $agentName = 'Agent - Intermediary agent 1'">
                <xsl:value-of select="'INTINS$G'"/>
            </xsl:when>
            <xsl:when test="$agentName != '' and $agentName = 'Agent - Intermediary agent 2'">
                <xsl:value-of select="'INTIN2$G'"/>
            </xsl:when>
            <xsl:when test="$agentName != '' and $agentName = 'Agent - Intermediary agent 3'">
                <xsl:value-of select="'INTIN3$G'"/>
            </xsl:when>
            <xsl:when test="$agentName != '' and $agentName = 'Agent - Debtor agent'">
                <xsl:value-of select="'ORDINS$R'"/>
            </xsl:when>
            <xsl:when test="$agentName != '' and $agentName = 'Agent - Previous instructing agent 1'">
                <xsl:value-of select="'PRVINS$G'"/>
            </xsl:when>
            <xsl:when test="$agentName != '' and $agentName = 'Agent - Previous instructing agent 2'">
                <xsl:value-of select="'PRVIN2$G'"/>
            </xsl:when>
            <xsl:when test="$agentName != '' and $agentName = 'Agent - Previous instructing agent 3'">
                <xsl:value-of select="'PRVIN3$G'"/>
            </xsl:when>
            <xsl:when test="$agentName != '' and $agentName = 'Party - Ultimate Debtor'">
                <xsl:value-of select="'ULTDBT$R'"/>
            </xsl:when>
            <xsl:when test="$agentName != '' and $agentName = 'Party - Debtor'">
                <xsl:value-of select="'ORDPTY$R'"/>
            </xsl:when>
            <xsl:when test="$agentName != '' and $agentName = 'Party - Initiating Party'">
                <xsl:value-of select="'INSPTY$R'"/>
            </xsl:when>
            <xsl:when test="$agentName != '' and $agentName = 'Party - Creditor'">
                <xsl:value-of select="'BENFCY$R'"/>
            </xsl:when>
            <xsl:when test="$agentName != '' and $agentName = 'Party - Ultimate Creditor'">
                <xsl:value-of select="'ULTCDT$R'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="findValue">
        <xsl:param name="data"/>
        <xsl:param name="values"/>
        <xsl:param name="searchKey"/>
        <xsl:choose>
            <xsl:when test="not(contains($data, 'CORESM'))">
                <xsl:if test="$data = $searchKey">
                    <xsl:choose>
                        <xsl:when test="$searchKey = 'Remittance' or $searchKey = 'Agent - Instructing agent' or $searchKey = 'Agent - Instructing reimbursement agent' or $searchKey = 'Agent - Instructed reimbursement agent' or $searchKey = 'Agent - Third reimbursement agent' or $searchKey = 'Agent - Intermediary agent 1' or $searchKey = 'Agent - Intermediary agent 2' or $searchKey = 'Agent - Intermediary agent 3' or $searchKey = 'Agent - Debtor agent' or $searchKey = 'Agent - Previous instructing agent 1' or $searchKey = 'Agent - Previous instructing agent 2' or $searchKey = 'Agent - Previous instructing agent 3' or $searchKey = 'Agent - Creditor agent' or $searchKey = 'Agent - Instructed agent' or $searchKey = 'Party - Ultimate Debtor' or $searchKey = 'Party - Debtor' or $searchKey = 'Party - Initiating Party' or $searchKey = 'Party - Creditor' or $searchKey = 'Party - Ultimate Creditor'">
                            <xsl:value-of select="$searchKey"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$values"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="currentData" select="substring-before($data, 'CORESM')"/>
                <xsl:variable name="remainingData" select="substring-after($data, 'CORESM')"/>
                <xsl:variable name="currentValue" select="substring-before($values, 'CORESM')"/>
                <xsl:variable name="remainingValues" select="substring-after($values, 'CORESM')"/>
                <xsl:choose>
                    <xsl:when test="$currentData = $searchKey">
                        <xsl:choose>
                            <xsl:when test="$searchKey = 'Remittance' or $searchKey = 'Agent - Instructing agent' or $searchKey = 'Agent - Instructing reimbursement agent' or $searchKey = 'Agent - Instructed reimbursement agent' or $searchKey = 'Agent - Third reimbursement agent' or $searchKey = 'Agent - Intermediary agent 1' or $searchKey = 'Agent - Intermediary agent 2' or $searchKey = 'Agent - Intermediary agent 3' or $searchKey = 'Agent - Debtor agent' or $searchKey = 'Agent - Previous instructing agent 1' or $searchKey = 'Agent - Previous instructing agent 2' or $searchKey = 'Agent - Previous instructing agent 3' or $searchKey = 'Agent - Creditor agent' or $searchKey = 'Agent - Instructed agent' or $searchKey = 'Party - Ultimate Debtor' or $searchKey = 'Party - Debtor' or $searchKey = 'Party - Initiating Party' or $searchKey = 'Party - Creditor' or $searchKey = 'Party - Ultimate Creditor'">
                                <xsl:value-of select="$searchKey"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$currentValue"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="string-length($remainingData) > 0">
                        <xsl:call-template name="findValue">
                            <xsl:with-param name="data" select="$remainingData"/>
                            <xsl:with-param name="values" select="$remainingValues"/>
                            <xsl:with-param name="searchKey" select="$searchKey"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="''"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="mapCreditPartyDetails">
        <xsl:param name="crPtyIdentifierCode"/>
        <xsl:param name="crPtyClearingMemberId"/>
        <xsl:param name="crPtyClearingSystemIdCode"/>
        <xsl:param name="crPtyLei"/>
        <xsl:param name="crPtyName"/>
        <xsl:param name="crPtyAddrDept"/>
        <xsl:param name="crPtyAddrSubdept"/>
        <xsl:param name="crPtyAddrStreetName"/>
        <xsl:param name="crPtyAddrBldgNo"/>
        <xsl:param name="crPtyAddrBldgName"/>
        <xsl:param name="crPtyAddrBldgFloor"/>
        <xsl:param name="crPtyAddrPostBox"/>
        <xsl:param name="crPtyAddrRoom"/>
        <xsl:param name="crPtyAddrPostCode"/>
        <xsl:param name="crPtyAddrTownName"/>
        <xsl:param name="crPtyAddrTownLocation"/>
        <xsl:param name="crPtyAddrDistrict"/>
        <xsl:param name="crPtyAddrCountrySubDiv"/>
        <xsl:param name="crPtyCountry"/>
        <xsl:param name="crPtyAddressLine1"/>
        <xsl:param name="crPtyAddressLine2"/>
        <xsl:if test="$crPtyIdentifierCode != '' or $crPtyClearingMemberId != '' or $crPtyClearingSystemIdCode != '' or $crPtyLei != '' or $crPtyName != '' or $crPtyAddrDept != '' or $crPtyAddrSubdept != '' or $crPtyAddrStreetName != '' or $crPtyAddrBldgNo != '' or $crPtyAddrBldgName != '' or $crPtyAddrBldgFloor != '' or $crPtyAddrPostBox != '' or $crPtyAddrRoom != '' or $crPtyAddrPostCode != '' or $crPtyCountry != '' or $crPtyAddrCountrySubDiv != '' or $crPtyAddrDistrict != '' or $crPtyAddrTownLocation != '' or $crPtyAddrTownName != '' or $crPtyAddressLine1 != '' or $crPtyAddressLine2 != ''">
            <Agt xmlns="urn:iso:std:iso:20022:tech:xsd:camt.111.001.02">
                <FinInstnId>
                    <xsl:if test="$crPtyIdentifierCode != ''">
                        <BICFI>
                            <xsl:value-of select="$crPtyIdentifierCode"/>
                        </BICFI>
                    </xsl:if>
                    <xsl:if test="($crPtyClearingMemberId != '') and ($crPtyClearingSystemIdCode != '')">
                        <ClrSysMmbId>
                            <xsl:if test="$crPtyClearingSystemIdCode">
                                <ClrSysId>
                                    <Cd>
                                        <xsl:value-of select="$crPtyClearingSystemIdCode"/>
                                    </Cd>
                                </ClrSysId>
                            </xsl:if>
                            <xsl:if test="$crPtyClearingMemberId != ''">
                                <MmbId>
                                    <xsl:value-of select="$crPtyClearingMemberId"/>
                                </MmbId>
                            </xsl:if>
                        </ClrSysMmbId>
                    </xsl:if>
                    <xsl:if test="$crPtyLei != ''">
                        <LEI>
                            <xsl:value-of select="$crPtyLei"/>
                        </LEI>
                    </xsl:if>
                    <xsl:if test="$crPtyName != ''">
                        <Nm>
                            <xsl:value-of select="$crPtyName"/>
                        </Nm>
                    </xsl:if>
                    <xsl:if test="$crPtyAddrDept != '' or $crPtyAddrSubdept != '' or $crPtyAddrStreetName != '' or $crPtyAddrBldgNo != '' or $crPtyAddrBldgName != '' or $crPtyAddrBldgFloor != '' or $crPtyAddrPostBox != '' or $crPtyAddrRoom != '' or $crPtyAddrPostCode != '' or $crPtyCountry != '' or $crPtyAddrCountrySubDiv != '' or $crPtyAddrDistrict != '' or $crPtyAddrTownLocation != '' or $crPtyAddrTownName != '' or $crPtyAddressLine1 != '' or $crPtyAddressLine2 != ''">
                        <PstlAdr>
                            <xsl:if test="$crPtyAddrDept != ''">
                                <Dept>
                                    <xsl:value-of select="substring(string($crPtyAddrDept), '1', '70')"/>
                                </Dept>
                            </xsl:if>
                            <xsl:if test="$crPtyAddrSubdept != ''">
                                <SubDept>
                                    <xsl:value-of select="substring(string($crPtyAddrSubdept), '1', '70')"/>
                                </SubDept>
                            </xsl:if>
                            <xsl:if test="$crPtyAddrStreetName != ''">
                                <StrtNm>
                                    <xsl:value-of select="substring(string($crPtyAddrStreetName), '1', '70')"/>
                                </StrtNm>
                            </xsl:if>
                            <xsl:if test="$crPtyAddrBldgNo != ''">
                                <BldgNb>
                                    <xsl:value-of select="substring(string($crPtyAddrBldgNo), '1', '16')"/>
                                </BldgNb>
                            </xsl:if>
                            <xsl:if test="$crPtyAddrBldgName != ''">
                                <BldgNm>
                                    <xsl:value-of select="substring(string($crPtyAddrBldgName), '1', '35')"/>
                                </BldgNm>
                            </xsl:if>
                            <xsl:if test="$crPtyAddrBldgFloor != ''">
                                <Flr>
                                    <xsl:value-of select="substring(string($crPtyAddrBldgFloor), '1', '70')"/>
                                </Flr>
                            </xsl:if>
                            <xsl:if test="$crPtyAddrPostBox != ''">
                                <PstBx>
                                    <xsl:value-of select="substring(string($crPtyAddrPostBox), '1', '16')"/>
                                </PstBx>
                            </xsl:if>
                            <xsl:if test="$crPtyAddrRoom != ''">
                                <Room>
                                    <xsl:value-of select="substring(string($crPtyAddrRoom), '1', '70')"/>
                                </Room>
                            </xsl:if>
                            <xsl:if test="$crPtyAddrPostCode != ''">
                                <PstCd>
                                    <xsl:value-of select="substring(string($crPtyAddrPostCode), '1', '16')"/>
                                </PstCd>
                            </xsl:if>
                            <xsl:if test="$crPtyAddrTownName != ''">
                                <TwnNm>
                                    <xsl:value-of select="substring(string($crPtyAddrTownName), '1', '35')"/>
                                </TwnNm>
                            </xsl:if>
                            <xsl:if test="$crPtyAddrTownLocation != ''">
                                <TwnLctnNm>
                                    <xsl:value-of select="substring(string($crPtyAddrTownLocation), '1', '35')"/>
                                </TwnLctnNm>
                            </xsl:if>
                            <xsl:if test="$crPtyAddrDistrict != ''">
                                <DstrctNm>
                                    <xsl:value-of select="substring(string($crPtyAddrDistrict), '1', '35')"/>
                                </DstrctNm>
                            </xsl:if>
                            <xsl:if test="$crPtyAddrCountrySubDiv != ''">
                                <CtrySubDvsn>
                                    <xsl:value-of select="substring(string($crPtyAddrCountrySubDiv), '1', '35')"/>
                                </CtrySubDvsn>
                            </xsl:if>
                            <xsl:if test="$crPtyCountry != ''">
                                <Ctry>
                                    <xsl:value-of select="substring(string($crPtyCountry), '1', '2')"/>
                                </Ctry>
                            </xsl:if>
                            <xsl:if test="$crPtyAddressLine1 != ''">
                                <AdrLine>
                                    <xsl:value-of select="substring(string($crPtyAddressLine1), '1', '70')"/>
                                </AdrLine>
                            </xsl:if>
                            <xsl:if test="$crPtyAddressLine2 != ''">
                                <AdrLine>
                                    <xsl:value-of select="substring(string($crPtyAddressLine2), '1', '70')"/>
                                </AdrLine>
                            </xsl:if>
                        </PstlAdr>
                    </xsl:if>
                </FinInstnId>
            </Agt>
        </xsl:if>
    </xsl:template>
    <xsl:template name="mapDebitPartyDetails">
        <xsl:param name="dbPtyName"/>
        <xsl:param name="dbPtyAddrTownName"/>
        <xsl:param name="dbPtyAddrDept"/>
        <xsl:param name="dbPtyAddrSubdept"/>
        <xsl:param name="dbPtyCountry"/>
        <xsl:param name="dbPtyAddrStreetName"/>
        <xsl:param name="dbPtyAddrBldgNo"/>
        <xsl:param name="dbPtyAddrBldgName"/>
        <xsl:param name="dbPtyAddrBldgFloor"/>
        <xsl:param name="dbPtyAddrPostBox"/>
        <xsl:param name="dbPtyAddrRoom"/>
        <xsl:param name="dbPtyAddrPostCode"/>
        <xsl:param name="dbPtyAddrCountrySubDiv"/>
        <xsl:param name="dbPtyAddrDistrict"/>
        <xsl:param name="dbPtyAddrTownLocation"/>
        <xsl:param name="dbPtyAddressLine1"/>
        <xsl:param name="dbPtyAddressLine2"/>
        <xsl:if test="$dbPtyName != '' or $dbPtyAddrTownName != '' or $dbPtyAddrDept != '' or $dbPtyAddrSubdept != '' or $dbPtyCountry != '' or $dbPtyAddrStreetName != '' or $dbPtyAddrBldgNo != '' or $dbPtyAddrBldgName != '' or $dbPtyAddrBldgFloor != '' or $dbPtyAddrPostBox != '' or $dbPtyAddrRoom != '' or $dbPtyAddrPostCode != '' or $dbPtyAddrCountrySubDiv != '' or $dbPtyAddrDistrict != '' or $dbPtyAddrTownLocation != '' or $dbPtyAddressLine1 != '' or $dbPtyAddressLine2 != ''">
            <Pty xmlns="urn:iso:std:iso:20022:tech:xsd:camt.111.001.02">
                <xsl:if test="$dbPtyName != ''">
                    <Nm>
                        <xsl:value-of select="substring(string($dbPtyName), '1', '140')"/>
                    </Nm>
                </xsl:if>
                <xsl:if test="$dbPtyAddrTownName != '' and $dbPtyCountry != ''">
                    <PstlAdr>
                        <xsl:if test="$dbPtyAddrDept">
                            <Dept>
                                <xsl:value-of select="substring(string($dbPtyAddrDept), '1', '70')"/>
                            </Dept>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddrSubdept != ''">
                            <SubDept>
                                <xsl:value-of select="substring(string($dbPtyAddrSubdept), '1', '70')"/>
                            </SubDept>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddrStreetName != ''">
                            <StrtNm>
                                <xsl:value-of select="substring(string($dbPtyAddrStreetName), '1', '70')"/>
                            </StrtNm>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddrBldgNo != ''">
                            <BldgNb>
                                <xsl:value-of select="substring(string($dbPtyAddrBldgNo), '1', '16')"/>
                            </BldgNb>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddrBldgName != ''">
                            <BldgNm>
                                <xsl:value-of select="substring(string($dbPtyAddrBldgName), '1', '35')"/>
                            </BldgNm>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddrBldgFloor != ''">
                            <Flr>
                                <xsl:value-of select="substring(string($dbPtyAddrBldgFloor), '1', '70')"/>
                            </Flr>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddrPostBox != ''">
                            <PstBx>
                                <xsl:value-of select="substring(string($dbPtyAddrPostBox), '1', '16')"/>
                            </PstBx>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddrRoom != ''">
                            <Room>
                                <xsl:value-of select="substring(string($dbPtyAddrRoom), '1', '70')"/>
                            </Room>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddrPostCode != ''">
                            <PstCd>
                                <xsl:value-of select="substring(string($dbPtyAddrPostCode), '1', '16')"/>
                            </PstCd>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddrTownName != ''">
                            <TwnNm>
                                <xsl:value-of select="substring(string($dbPtyAddrTownName), '1', '35')"/>
                            </TwnNm>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddrTownLocation != ''">
                            <TwnLctnNm>
                                <xsl:value-of select="substring(string($dbPtyAddrTownLocation), '1', '35')"/>
                            </TwnLctnNm>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddrDistrict != ''">
                            <DstrctNm>
                                <xsl:value-of select="substring(string($dbPtyAddrDistrict), '1', '35')"/>
                            </DstrctNm>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddrCountrySubDiv != ''">
                            <CtrySubDvsn>
                                <xsl:value-of select="substring(string($dbPtyAddrCountrySubDiv), '1', '35')"/>
                            </CtrySubDvsn>
                        </xsl:if>
                        <xsl:if test="$dbPtyCountry != ''">
                            <Ctry>
                                <xsl:value-of select="substring(string($dbPtyCountry), '1', '2')"/>
                            </Ctry>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddressLine1 != ''">
                            <AdrLine>
                                <xsl:value-of select="substring(string($dbPtyAddressLine1), '1', '70')"/>
                            </AdrLine>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddressLine2 != ''">
                            <AdrLine>
                                <xsl:value-of select="substring(string($dbPtyAddressLine2), '1', '70')"/>
                            </AdrLine>
                        </xsl:if>
                    </PstlAdr>
                </xsl:if>
            </Pty>
        </xsl:if>
    </xsl:template>
    <xsl:template name="mapCreditPartyDetailsPty">
        <xsl:param name="dbPtyName"/>
        <xsl:param name="dbPtyAddrTownName"/>
        <xsl:param name="dbPtyAddrDept"/>
        <xsl:param name="dbPtyAddrSubdept"/>
        <xsl:param name="dbPtyCountry"/>
        <xsl:param name="dbPtyAddrStreetName"/>
        <xsl:param name="dbPtyAddrBldgNo"/>
        <xsl:param name="dbPtyAddrBldgName"/>
        <xsl:param name="dbPtyAddrBldgFloor"/>
        <xsl:param name="dbPtyAddrPostBox"/>
        <xsl:param name="dbPtyAddrRoom"/>
        <xsl:param name="dbPtyAddrPostCode"/>
        <xsl:param name="dbPtyAddrCountrySubDiv"/>
        <xsl:param name="dbPtyAddrDistrict"/>
        <xsl:param name="dbPtyAddrTownLocation"/>
        <xsl:param name="dbPtyAddressLine1"/>
        <xsl:param name="dbPtyAddressLine2"/>
        <xsl:if test="$dbPtyName != '' or $dbPtyAddrTownName != '' or $dbPtyAddrDept != '' or $dbPtyAddrSubdept != '' or $dbPtyCountry != '' or $dbPtyAddrStreetName != '' or $dbPtyAddrBldgNo != '' or $dbPtyAddrBldgName != '' or $dbPtyAddrBldgFloor != '' or $dbPtyAddrPostBox != '' or $dbPtyAddrRoom != '' or $dbPtyAddrPostCode != '' or $dbPtyAddrCountrySubDiv != '' or $dbPtyAddrDistrict != '' or $dbPtyAddrTownLocation != '' or $dbPtyAddressLine1 != '' or $dbPtyAddressLine2 != ''">
            <Pty xmlns="urn:iso:std:iso:20022:tech:xsd:camt.111.001.02">
                <xsl:if test="$dbPtyName != ''">
                    <Nm>
                        <xsl:value-of select="substring(string($dbPtyName), '1', '140')"/>
                    </Nm>
                </xsl:if>
                <xsl:if test="$dbPtyAddrTownName != '' and $dbPtyCountry != ''">
                    <PstlAdr>
                        <xsl:if test="$dbPtyAddrDept">
                            <Dept>
                                <xsl:value-of select="substring(string($dbPtyAddrDept), '1', '70')"/>
                            </Dept>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddrSubdept != ''">
                            <SubDept>
                                <xsl:value-of select="substring(string($dbPtyAddrSubdept), '1', '70')"/>
                            </SubDept>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddrStreetName != ''">
                            <StrtNm>
                                <xsl:value-of select="substring(string($dbPtyAddrStreetName), '1', '70')"/>
                            </StrtNm>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddrBldgNo != ''">
                            <BldgNb>
                                <xsl:value-of select="substring(string($dbPtyAddrBldgNo), '1', '16')"/>
                            </BldgNb>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddrBldgName != ''">
                            <BldgNm>
                                <xsl:value-of select="substring(string($dbPtyAddrBldgName), '1', '35')"/>
                            </BldgNm>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddrBldgFloor != ''">
                            <Flr>
                                <xsl:value-of select="substring(string($dbPtyAddrBldgFloor), '1', '70')"/>
                            </Flr>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddrPostBox != ''">
                            <PstBx>
                                <xsl:value-of select="substring(string($dbPtyAddrPostBox), '1', '16')"/>
                            </PstBx>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddrRoom != ''">
                            <Room>
                                <xsl:value-of select="substring(string($dbPtyAddrRoom), '1', '70')"/>
                            </Room>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddrPostCode != ''">
                            <PstCd>
                                <xsl:value-of select="substring(string($dbPtyAddrPostCode), '1', '16')"/>
                            </PstCd>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddrTownName != ''">
                            <TwnNm>
                                <xsl:value-of select="substring(string($dbPtyAddrTownName), '1', '35')"/>
                            </TwnNm>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddrTownLocation != ''">
                            <TwnLctnNm>
                                <xsl:value-of select="substring(string($dbPtyAddrTownLocation), '1', '35')"/>
                            </TwnLctnNm>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddrDistrict != ''">
                            <DstrctNm>
                                <xsl:value-of select="substring(string($dbPtyAddrDistrict), '1', '35')"/>
                            </DstrctNm>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddrCountrySubDiv != ''">
                            <CtrySubDvsn>
                                <xsl:value-of select="substring(string($dbPtyAddrCountrySubDiv), '1', '35')"/>
                            </CtrySubDvsn>
                        </xsl:if>
                        <xsl:if test="$dbPtyCountry != ''">
                            <Ctry>
                                <xsl:value-of select="substring(string($dbPtyCountry), '1', '2')"/>
                            </Ctry>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddressLine1 != ''">
                            <AdrLine>
                                <xsl:value-of select="substring(string($dbPtyAddressLine1), '1', '70')"/>
                            </AdrLine>
                        </xsl:if>
                        <xsl:if test="$dbPtyAddressLine2 != ''">
                            <AdrLine>
                                <xsl:value-of select="substring(string($dbPtyAddressLine2), '1', '70')"/>
                            </AdrLine>
                        </xsl:if>
                    </PstlAdr>
                </xsl:if>
            </Pty>
        </xsl:if>
    </xsl:template>
    <xsl:template name="mapDebitPartyDetailsAgt">
        <xsl:param name="dbPtyIdentifierCode"/>
        <xsl:param name="dbPtyClearingMemberId"/>
        <xsl:param name="dbPtyClearingSystemIdCode"/>
        <xsl:param name="dbPtyLei"/>
        <xsl:param name="dbPtyName"/>
        <xsl:param name="dbPtyAddrDept"/>
        <xsl:param name="dbPtyAddrSubdept"/>
        <xsl:param name="dbPtyAddrStreetName"/>
        <xsl:param name="dbPtyAddrBldgNo"/>
        <xsl:param name="dbPtyAddrBldgName"/>
        <xsl:param name="dbPtyAddrBldgFloor"/>
        <xsl:param name="dbPtyAddrPostBox"/>
        <xsl:param name="dbPtyAddrRoom"/>
        <xsl:param name="dbPtyAddrPostCode"/>
        <xsl:param name="dbPtyAddrTownName"/>
        <xsl:param name="dbPtyAddrTownLocation"/>
        <xsl:param name="dbPtyAddrDistrict"/>
        <xsl:param name="dbPtyAddrCountrySubDiv"/>
        <xsl:param name="dbPtyCountry"/>
        <xsl:param name="dbPtyAddressLine1"/>
        <xsl:param name="dbPtyAddressLine2"/>
        <xsl:if test="$dbPtyIdentifierCode != '' or $dbPtyClearingMemberId != '' or $dbPtyClearingSystemIdCode != '' or $dbPtyLei != '' or $dbPtyName != '' or $dbPtyAddrDept != '' or $dbPtyAddrSubdept != '' or $dbPtyAddrStreetName != '' or $dbPtyAddrBldgNo != '' or $dbPtyAddrBldgName != '' or $dbPtyAddrBldgFloor != '' or $dbPtyAddrPostBox != '' or $dbPtyAddrRoom != '' or $dbPtyAddrPostCode != '' or $dbPtyCountry != '' or $dbPtyAddrCountrySubDiv != '' or $dbPtyAddrDistrict != '' or $dbPtyAddrTownLocation != '' or $dbPtyAddrTownName != '' or $dbPtyAddressLine1 != '' or $dbPtyAddressLine2 != ''">
            <Agt xmlns="urn:iso:std:iso:20022:tech:xsd:camt.111.001.02">
                <FinInstnId>
                    <xsl:if test="$dbPtyIdentifierCode != ''">
                        <BICFI>
                            <xsl:value-of select="$dbPtyIdentifierCode"/>
                        </BICFI>
                    </xsl:if>
                    <xsl:if test="($dbPtyClearingMemberId != '') and ($dbPtyClearingSystemIdCode != '')">
                        <ClrSysMmbId>
                            <xsl:if test="$dbPtyClearingSystemIdCode">
                                <ClrSysId>
                                    <Cd>
                                        <xsl:value-of select="$dbPtyClearingSystemIdCode"/>
                                    </Cd>
                                </ClrSysId>
                            </xsl:if>
                            <xsl:if test="$dbPtyClearingMemberId != ''">
                                <MmbId>
                                    <xsl:value-of select="$dbPtyClearingMemberId"/>
                                </MmbId>
                            </xsl:if>
                        </ClrSysMmbId>
                    </xsl:if>
                    <xsl:if test="$dbPtyLei != ''">
                        <LEI>
                            <xsl:value-of select="$dbPtyLei"/>
                        </LEI>
                    </xsl:if>
                    <xsl:if test="$dbPtyName != ''">
                        <Nm>
                            <xsl:value-of select="$dbPtyName"/>
                        </Nm>
                    </xsl:if>
                    <xsl:if test="$dbPtyAddrDept != '' or $dbPtyAddrSubdept != '' or $dbPtyAddrStreetName != '' or $dbPtyAddrBldgNo != '' or $dbPtyAddrBldgName != '' or $dbPtyAddrBldgFloor != '' or $dbPtyAddrPostBox != '' or $dbPtyAddrRoom != '' or $dbPtyAddrPostCode != '' or $dbPtyCountry != '' or $dbPtyAddrCountrySubDiv != '' or $dbPtyAddrDistrict != '' or $dbPtyAddrTownLocation != '' or $dbPtyAddrTownName != '' or $dbPtyAddressLine1 != '' or $dbPtyAddressLine2 != ''">
                        <PstlAdr>
                            <xsl:if test="$dbPtyAddrDept != ''">
                                <Dept>
                                    <xsl:value-of select="substring(string($dbPtyAddrDept), '1', '70')"/>
                                </Dept>
                            </xsl:if>
                            <xsl:if test="$dbPtyAddrSubdept != ''">
                                <SubDept>
                                    <xsl:value-of select="substring(string($dbPtyAddrSubdept), '1', '70')"/>
                                </SubDept>
                            </xsl:if>
                            <xsl:if test="$dbPtyAddrStreetName != ''">
                                <StrtNm>
                                    <xsl:value-of select="substring(string($dbPtyAddrStreetName), '1', '70')"/>
                                </StrtNm>
                            </xsl:if>
                            <xsl:if test="$dbPtyAddrBldgNo != ''">
                                <BldgNb>
                                    <xsl:value-of select="substring(string($dbPtyAddrBldgNo), '1', '16')"/>
                                </BldgNb>
                            </xsl:if>
                            <xsl:if test="$dbPtyAddrBldgName != ''">
                                <BldgNm>
                                    <xsl:value-of select="substring(string($dbPtyAddrBldgName), '1', '35')"/>
                                </BldgNm>
                            </xsl:if>
                            <xsl:if test="$dbPtyAddrBldgFloor != ''">
                                <Flr>
                                    <xsl:value-of select="substring(string($dbPtyAddrBldgFloor), '1', '70')"/>
                                </Flr>
                            </xsl:if>
                            <xsl:if test="$dbPtyAddrPostBox != ''">
                                <PstBx>
                                    <xsl:value-of select="substring(string($dbPtyAddrPostBox), '1', '16')"/>
                                </PstBx>
                            </xsl:if>
                            <xsl:if test="$dbPtyAddrRoom != ''">
                                <Room>
                                    <xsl:value-of select="substring(string($dbPtyAddrRoom), '1', '70')"/>
                                </Room>
                            </xsl:if>
                            <xsl:if test="$dbPtyAddrPostCode != ''">
                                <PstCd>
                                    <xsl:value-of select="substring(string($dbPtyAddrPostCode), '1', '16')"/>
                                </PstCd>
                            </xsl:if>
                            <xsl:if test="$dbPtyAddrTownName != ''">
                                <TwnNm>
                                    <xsl:value-of select="substring(string($dbPtyAddrTownName), '1', '35')"/>
                                </TwnNm>
                            </xsl:if>
                            <xsl:if test="$dbPtyAddrTownLocation != ''">
                                <TwnLctnNm>
                                    <xsl:value-of select="substring(string($dbPtyAddrTownLocation), '1', '35')"/>
                                </TwnLctnNm>
                            </xsl:if>
                            <xsl:if test="$dbPtyAddrDistrict != ''">
                                <DstrctNm>
                                    <xsl:value-of select="substring(string($dbPtyAddrDistrict), '1', '35')"/>
                                </DstrctNm>
                            </xsl:if>
                            <xsl:if test="$dbPtyAddrCountrySubDiv != ''">
                                <CtrySubDvsn>
                                    <xsl:value-of select="substring(string($dbPtyAddrCountrySubDiv), '1', '35')"/>
                                </CtrySubDvsn>
                            </xsl:if>
                            <xsl:if test="$dbPtyCountry != ''">
                                <Ctry>
                                    <xsl:value-of select="substring(string($dbPtyCountry), '1', '2')"/>
                                </Ctry>
                            </xsl:if>
                            <xsl:if test="$dbPtyAddressLine1 != ''">
                                <AdrLine>
                                    <xsl:value-of select="substring(string($dbPtyAddressLine1), '1', '70')"/>
                                </AdrLine>
                            </xsl:if>
                            <xsl:if test="$dbPtyAddressLine2 != ''">
                                <AdrLine>
                                    <xsl:value-of select="substring(string($dbPtyAddressLine2), '1', '70')"/>
                                </AdrLine>
                            </xsl:if>
                        </PstlAdr>
                    </xsl:if>
                </FinInstnId>
            </Agt>
        </xsl:if>
    </xsl:template>
    <xsl:template name="mapStatusRsnInfo">
        <xsl:param name="txnStsRsnCode"/>
        <xsl:param name="addRespInfo"/>
        <xsl:choose>
            <xsl:when test="not(contains($txnStsRsnCode, 'CORESM'))">
                <xsl:if test="$txnStsRsnCode != '' or $addRespInfo != ''">
                    <StsRsnInf xmlns="urn:iso:std:iso:20022:tech:xsd:camt.111.001.02">
                        <xsl:if test="$txnStsRsnCode != ''">
                            <Rsn>
                                <Cd>
                                    <xsl:value-of select="$txnStsRsnCode"/>
                                </Cd>
                            </Rsn>
                        </xsl:if>
                        <xsl:if test="$addRespInfo != ''">
                            <xsl:variable name="firstPart" select="substring($addRespInfo, 1, 105)"/>
                            <xsl:variable name="secondPart" select="substring($addRespInfo, 106, 105)"/>
                            <AddtlInf>
                                <xsl:value-of select="$firstPart"/>
                            </AddtlInf>
                            <xsl:if test="string-length($secondPart) &gt; 0">
                                <AddtlInf>
                                    <xsl:value-of select="$secondPart"/>
                                </AddtlInf>
                            </xsl:if>
                        </xsl:if>
                    </StsRsnInf>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="currentTxnRsnCd" select="substring-before($txnStsRsnCode, 'CORESM')"/>
                <xsl:variable name="remainingTxnRsnCd" select="substring-after($txnStsRsnCode, 'CORESM')"/>
                <xsl:variable name="currentAddRespInfo" select="substring-before($addRespInfo, 'CORESM')"/>
                <xsl:variable name="remainingAddRespInfo" select="substring-after($addRespInfo, 'CORESM')"/>
                <xsl:if test="$currentTxnRsnCd">
                    <StsRsnInf xmlns="urn:iso:std:iso:20022:tech:xsd:camt.111.001.02">
                        <xsl:if test="$currentTxnRsnCd != ''">
                            <Rsn>
                                <Cd>
                                    <xsl:value-of select="$currentTxnRsnCd"/>
                                </Cd>
                            </Rsn>
                        </xsl:if>
                        <xsl:if test="$currentAddRespInfo != ''">
                            <xsl:variable name="firstPart" select="substring($currentAddRespInfo, 1, 105)"/>
                            <xsl:variable name="secondPart" select="substring($currentAddRespInfo, 106, 105)"/>
                            <AddtlInf>
                                <xsl:value-of select="$firstPart"/>
                            </AddtlInf>
                            <xsl:if test="string-length($secondPart) &gt; 0">
                                <AddtlInf>
                                    <xsl:value-of select="$secondPart"/>
                                </AddtlInf>
                            </xsl:if>
                        </xsl:if>
                    </StsRsnInf>
                    <xsl:call-template name="mapStatusRsnInfo">
                        <xsl:with-param name="txnStsRsnCode" select="$remainingTxnRsnCd"/>
                        <xsl:with-param name="addRespInfo" select="$remainingAddRespInfo"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="/">
        <Document xmlns="urn:iso:std:iso:20022:tech:xsd:camt.111.001.02" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <InvstgtnRspn>
                <InvstgtnRspn>
                    <xsl:if test="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:canReqInvestigationId != ''">
                        <MsgId>
                            <xsl:value-of select="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:canReqInvestigationId"/>
                        </MsgId>
                    </xsl:if>
                    <xsl:if test="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:respAssignmentId != ''">
                        <RspndrInvstgtnId>
                            <xsl:value-of select="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:respAssignmentId"/>
                        </RspndrInvstgtnId>
                    </xsl:if>
                    <InvstgtnSts>
                        <xsl:if test="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:answer != ''">
                            <Sts>
                                <xsl:value-of select="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:answer"/>
                            </Sts>
                        </xsl:if>
                        <xsl:variable name="InvStsRsnPrtry">
                            <xsl:for-each select="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:requestCodeInfo">
                                <xsl:call-template name="findValue">
                                    <xsl:with-param name="data" select="ns3:responseData"/>
                                    <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                    <xsl:with-param name="searchKey" select="'Inv Sts Rsn Prtry'"/>
                                </xsl:call-template>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:if test="$InvStsRsnPrtry != '' or ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:canReqInvestigationStatusRsnCode != ''">
                            <StsRsn>
                                <xsl:choose>
                                    <xsl:when test="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:canReqInvestigationStatusRsnCode != ''">
                                        <Cd>
                                            <xsl:value-of select="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:canReqInvestigationStatusRsnCode"/>
                                        </Cd>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:if test="$InvStsRsnPrtry != ''">
                                            <Prtry>
                                                <xsl:value-of select="$InvStsRsnPrtry"/>
                                            </Prtry>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </StsRsn>
                        </xsl:if>
                    </InvstgtnSts>
                    <xsl:variable name="UnstrdRmtInf1">
                        <xsl:for-each select="ns18:doOutwardMappingForCR/ns18:iorgporaddinfo[ns10:additionalInformationCode = 'RMTINF' and ns10:additionalInfLine !='']">
                            <xsl:if test="string((position() = '1')) != 'false'">
                                <xsl:value-of select="ns10:additionalInfLine"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="UnstrdRmtInf2">
                        <xsl:for-each select="ns18:doOutwardMappingForCR/ns18:iorgporaddinfo[ns10:additionalInformationCode = 'RMTINF' and ns10:additionalInfLine !='']">
                            <xsl:if test="string((position() = '2')) != 'false'">
                                <xsl:value-of select="ns10:additionalInfLine"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="UnstrdRmtInf3">
                        <xsl:for-each select="ns18:doOutwardMappingForCR/ns18:iorgporaddinfo[ns10:additionalInformationCode = 'RMTINF' and ns10:additionalInfLine !='']">
                            <xsl:if test="string((position() = '3')) != 'false'">
                                <xsl:value-of select="ns10:additionalInfLine"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="UnstrdRmtInf4">
                        <xsl:for-each select="ns18:doOutwardMappingForCR/ns18:iorgporaddinfo[ns10:additionalInformationCode = 'RMTINF' and ns10:additionalInfLine !='']">
                            <xsl:if test="string((position() = '4')) != 'false'">
                                <xsl:value-of select="ns10:additionalInfLine"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="UnstrdRmtInf">
                        <xsl:choose>
                            <xsl:when test="string-length($UnstrdRmtInf1) &lt;= 35 or string-length($UnstrdRmtInf2) &lt;= 35 or string-length($UnstrdRmtInf3) &lt;= 35 or string-length($UnstrdRmtInf4) &lt;= 35">
                                <xsl:value-of select="concat($UnstrdRmtInf1,$UnstrdRmtInf2,$UnstrdRmtInf3,$UnstrdRmtInf4)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:for-each select="ns18:doOutwardMappingForCR/ns18:iorgporaddinfo[ns10:additionalInformationCode = 'RMTINF' and ns10:additionalInfLine !='']">
                                    <xsl:value-of select="ns10:additionalInfLine"/>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="StrdRmtInf">
                        <xsl:choose>
                            <xsl:when test="ns18:doOutwardMappingForCR/ns18:iremittanceinfopart2[ns15:messageData != '']">
                                <xsl:for-each select="ns18:doOutwardMappingForCR/ns18:iremittanceinfopart2[ns15:messageData != '']">
                                    <xsl:value-of select="ns15:messageData" disable-output-escaping="yes"/>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:for-each select="ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo[ns15:messageData != '']">
                                    <xsl:value-of select="ns16:messageData" disable-output-escaping="yes"/>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="isRltdRemImfoPresent">
                        <xsl:for-each select="ns18:doOutwardMappingForCR/ns18:irelatedremittanceinfo[ns17:relRemInfRmtLocMthd!='']">
                            <xsl:value-of select="'TRUE'"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="isRltdRemIdPrsnt">
                        <xsl:for-each select="ns18:doOutwardMappingForCR/ns18:irelatedremittanceinfo[ns17:relRemInfoRemId!='']">
                            <xsl:value-of select="'TRUE'"/>
                        </xsl:for-each>
                    </xsl:variable>
					<xsl:variable name="InvestigationStatusRsnCode">
                        <xsl:value-of select="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:canReqInvestigationStatusRsnCode"/>
                    </xsl:variable>
                    <xsl:if test="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:answer = 'CLSD' and ($InvestigationStatusRsnCode != 'NOAS' and $InvestigationStatusRsnCode != 'RR04' and $InvestigationStatusRsnCode != 'LEGL' and $InvestigationStatusRsnCode != 'NOAD' and $InvestigationStatusRsnCode != 'CACR' and $InvestigationStatusRsnCode != 'CAPR' and $InvestigationStatusRsnCode != 'ARDT' and $InvestigationStatusRsnCode != 'ARJT')">
                        <xsl:choose>
                            <xsl:when test="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:canReqRequestType = 'CCNR' or ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:canReqRequestType = 'CONR'">
                                <xsl:variable name="RequestCode">
                                    <xsl:for-each select="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:requestCodeInfo">
                                        <xsl:value-of select="ns3:requestCode"/>
                                    </xsl:for-each>
                                </xsl:variable>
                                <xsl:variable name="TrnStatusCode">
                                    <xsl:for-each select="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:requestCodeInfo">
                                        <xsl:if test="position() = '1'">
                                            <xsl:value-of select="ns3:trnStatusCode"/>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:variable>
                                <xsl:variable name="RespOrgtrBic">
                                    <xsl:for-each select="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:requestCodeInfo">
                                        <xsl:if test="position() = '1'">
                                            <xsl:call-template name="findValue">
                                                <xsl:with-param name="data" select="ns3:responseData"/>
                                                <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                <xsl:with-param name="searchKey" select="'Resp. Orgtr BIC'"/>
                                            </xsl:call-template>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:variable>
                                <InvstgtnData>
                                    <xsl:if test="$RequestCode != ''">
                                        <OrgnlInvstgtnRsn>
                                            <Cd>
                                                <xsl:value-of select="$RequestCode"/>
                                            </Cd>
                                        </OrgnlInvstgtnRsn>
                                    </xsl:if>
                                    <RspnData>
                                        <xsl:choose>
                                            <xsl:when test="$TrnStatusCode = ''">
                                                <Conf>
                                                    <xsl:if test="ns18:doOutwardMappingForCR/ns18:ipaymentdetailsa/ns1:confAmt != '' and ns18:doOutwardMappingForCR/ns18:iorgpaymentrecord/ns7:creditMainAccountCurrencyCode != ''">
                                                        <Amt>
                                                            <xsl:attribute name="Ccy" namespace="">
                                                                <xsl:value-of select="ns18:doOutwardMappingForCR/ns18:iorgpaymentrecord/ns7:creditMainAccountCurrencyCode"/>
                                                            </xsl:attribute>
                                                            <xsl:value-of select="ns18:doOutwardMappingForCR/ns18:ipaymentdetailsa/ns1:confAmt"/>
                                                        </Amt>
                                                    </xsl:if>
                                                    <CdtDbtInd>CRDT</CdtDbtInd>
                                                    <xsl:if test="ns18:doOutwardMappingForCR/ns18:iorgpaymentrecord/ns7:creditExchangeRate != ''">
                                                        <XchgRate>
                                                            <xsl:value-of select="ns18:doOutwardMappingForCR/ns18:iorgpaymentrecord/ns7:creditExchangeRate"/>
                                                        </XchgRate>
                                                    </xsl:if>
                                                    <xsl:for-each select="ns18:doOutwardMappingForCR/ns18:ipartycredit[ns12:crPtyRole = 'BENFCY' and ns12:crPtyRoleIndicator = 'R']">
                                                        <Acct>
                                                            <xsl:if test="ns12:crPtyIban != '' or ns12:crPtyAccountLine != ''">
                                                                <Id>
                                                                    <xsl:choose>
                                                                        <xsl:when test="ns12:crPtyIban">
                                                                            <IBAN>
                                                                                <xsl:value-of select="ns12:crPtyIban"/>
                                                                            </IBAN>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                            <Othr>
                                                                                <Id>
                                                                                    <xsl:value-of select="ns12:crPtyAccountLine"/>
                                                                                </Id>
                                                                            </Othr>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </Id>
                                                            </xsl:if>
                                                            <xsl:if test="ns12:crPtyAccCurrency != ''">
                                                                <Ccy>
                                                                    <xsl:value-of select="ns12:crPtyAccCurrency"/>
                                                                </Ccy>
                                                            </xsl:if>
                                                            <xsl:if test="ns12:crPtyAccProxyTypeCode != '' or ns12:crPtyAccProxyTypeProp != '' or ns12:crPtyAccProxyId != ''">
                                                                <Prxy>
                                                                    <xsl:if test="ns12:crPtyAccProxyTypeCode != '' or ns12:crPtyAccProxyTypeProp != ''">
                                                                        <Tp>
                                                                            <xsl:choose>
                                                                                <xsl:when test="ns12:crPtyAccProxyTypeCode != ''">
                                                                                    <Cd>
                                                                                        <xsl:value-of select="ns12:crPtyAccProxyTypeCode"/>
                                                                                    </Cd>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                    <xsl:if test="ns12:crPtyAccProxyTypeProp != ''">
                                                                                        <Prtry>
                                                                                            <xsl:value-of select="ns12:crPtyAccProxyTypeProp"/>
                                                                                        </Prtry>
                                                                                    </xsl:if>
                                                                                </xsl:otherwise>
                                                                            </xsl:choose>
                                                                        </Tp>
                                                                    </xsl:if>
                                                                    <xsl:if test="ns12:crPtyAccProxyId != ''">
                                                                        <Id>
                                                                            <xsl:value-of select="ns12:crPtyAccProxyTypeProp"/>
                                                                        </Id>
                                                                    </xsl:if>
                                                                </Prxy>
                                                            </xsl:if>
                                                        </Acct>
                                                    </xsl:for-each>
                                                    <xsl:for-each select="ns18:doOutwardMappingForCR/ns18:ipartycredit[ns12:crPtyRole = 'BENINS' and ns12:crPtyRoleIndicator = 'R']">
                                                        <Acct>
                                                            <xsl:if test="ns12:crPtyIban != '' or ns12:crPtyAccountLine != ''">
                                                                <Id>
                                                                    <xsl:choose>
                                                                        <xsl:when test="ns12:crPtyIban != ''">
                                                                            <IBAN>
                                                                                <xsl:value-of select="ns12:crPtyIban"/>
                                                                            </IBAN>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                            <Othr>
                                                                                <Id>
                                                                                    <xsl:value-of select="ns12:crPtyAccountLine"/>
                                                                                </Id>
                                                                            </Othr>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </Id>
                                                            </xsl:if>
                                                            <xsl:if test="ns12:crPtyAccCurrency != ''">
                                                                <Ccy>
                                                                    <xsl:value-of select="ns12:crPtyAccCurrency"/>
                                                                </Ccy>
                                                            </xsl:if>
                                                            <xsl:if test="ns12:crPtyAccProxyTypeCode != '' or ns12:crPtyAccProxyTypeProp != '' or ns12:crPtyAccProxyId != ''">
                                                                <Prxy>
                                                                    <xsl:if test="ns12:crPtyAccProxyTypeCode != '' or ns12:crPtyAccProxyTypeProp != ''">
                                                                        <Tp>
                                                                            <xsl:choose>
                                                                                <xsl:when test="ns12:crPtyAccProxyTypeCode != ''">
                                                                                    <Cd>
                                                                                        <xsl:value-of select="ns12:crPtyAccProxyTypeCode"/>
                                                                                    </Cd>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                    <xsl:if test="ns12:crPtyAccProxyTypeProp != ''">
                                                                                        <Prtry>
                                                                                            <xsl:value-of select="ns12:crPtyAccProxyTypeProp"/>
                                                                                        </Prtry>
                                                                                    </xsl:if>
                                                                                </xsl:otherwise>
                                                                            </xsl:choose>
                                                                        </Tp>
                                                                    </xsl:if>
                                                                    <xsl:if test="ns12:crPtyAccProxyId != ''">
                                                                        <Id>
                                                                            <xsl:value-of select="ns12:crPtyAccProxyTypeProp"/>
                                                                        </Id>
                                                                    </xsl:if>
                                                                </Prxy>
                                                            </xsl:if>
                                                        </Acct>
                                                    </xsl:for-each>
                                                    <xsl:if test="ns18:doOutwardMappingForCR/ns18:iorgpaymentrecord/ns7:bookDate != ''">
                                                        <BookgDt>
                                                            <Dt>
                                                                <xsl:value-of select="concat(substring(string(ns18:doOutwardMappingForCR/ns18:iorgpaymentrecord/ns7:bookDate),'1','4'),'-',substring(string(ns18:doOutwardMappingForCR/ns18:iorgpaymentrecord/ns7:bookDate),'5','2'),'-',substring(string(ns18:doOutwardMappingForCR/ns18:iorgpaymentrecord/ns7:bookDate),'7','2'))"/>
                                                            </Dt>
                                                        </BookgDt>
                                                    </xsl:if>
                                                    <xsl:if test="ns18:doOutwardMappingForCR/ns18:iorgpaymentrecord/ns7:creditValueDate != ''">
                                                        <ValDt>
                                                            <Dt>
                                                                <xsl:value-of select="concat(substring(string(ns18:doOutwardMappingForCR/ns18:iorgpaymentrecord/ns7:creditValueDate),'1','4'),'-',substring(string(ns18:doOutwardMappingForCR/ns18:iorgpaymentrecord/ns7:creditValueDate),'5','2'),'-',substring(string(ns18:doOutwardMappingForCR/ns18:iorgpaymentrecord/ns7:creditValueDate),'7','2'))"/>
                                                            </Dt>
                                                        </ValDt>
                                                    </xsl:if>
                                                    <Refs>
                                                        <xsl:if test="ns18:doOutwardMappingForCR/ns18:iorgadditionalpaymentrecord/ns8:bulkSendersReference != ''">
                                                            <MsgId>
                                                                <xsl:value-of select="ns18:doOutwardMappingForCR/ns18:iorgadditionalpaymentrecord/ns8:bulkSendersReference"/>
                                                            </MsgId>
                                                        </xsl:if>
                                                        <xsl:if test="ns18:doOutwardMappingForCR/ns18:iorgpaymentrecord/ns7:sendersReferenceIncoming != ''">
                                                            <InstrId>
                                                                <xsl:value-of select="ns18:doOutwardMappingForCR/ns18:iorgpaymentrecord/ns7:sendersReferenceIncoming"/>
                                                            </InstrId>
                                                        </xsl:if>
                                                        <xsl:if test="ns18:doOutwardMappingForCR/ns18:iorgpaymentrecord/ns7:customerSpecifiedReference != '' or ns18:doOutwardMappingForCR/ns18:iorgpaymentrecord/ns7:transactionReferenceIncoming != ''">
                                                            <xsl:choose>
                                                                <xsl:when test="ns18:doOutwardMappingForCR/ns18:iorgpaymentrecord/ns7:ctrBtrIndicator = 'B' and (ns18:doOutwardMappingForCR/ns18:iorgpaymentrecord/ns7:validationFlag = 'COV' or ns18:doOutwardMappingForCR/ns18:iorgpaymentrecord/ns7:coverFlag = 'Y')">
                                                                    <EndToEndId>
                                                                        <xsl:value-of select="ns18:doOutwardMappingForCR/ns18:iorgpaymentrecord/ns7:transactionReferenceIncoming"/>
                                                                    </EndToEndId>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                    <EndToEndId>
                                                                        <xsl:value-of select="ns18:doOutwardMappingForCR/ns18:iorgpaymentrecord/ns7:customerSpecifiedReference"/>
                                                                    </EndToEndId>
                                                                </xsl:otherwise>
                                                            </xsl:choose>
                                                        </xsl:if>
                                                        <xsl:if test="ns18:doOutwardMappingForCR/ns18:iorgadditionalpaymentrecord/ns8:endToEndReference != ''">
                                                            <UETR>
                                                                <xsl:value-of select="ns18:doOutwardMappingForCR/ns18:iorgadditionalpaymentrecord/ns8:endToEndReference"/>
                                                            </UETR>
                                                        </xsl:if>
                                                        <xsl:if test="ns18:doOutwardMappingForCR/ns18:iorgpaymentrecord/ns7:messageUserReference != ''">
                                                            <TxId>
                                                                <xsl:value-of select="ns18:doOutwardMappingForCR/ns18:iorgpaymentrecord/ns7:messageUserReference"/>
                                                            </TxId>
                                                        </xsl:if>
                                                    </Refs>
                                                </Conf>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <TxSts>
                                                    <xsl:if test="$TrnStatusCode != ''">
                                                        <Sts>
                                                            <Cd>
                                                                <xsl:value-of select="substring($TrnStatusCode,1,4)"/>
                                                            </Cd>
                                                        </Sts>
                                                    </xsl:if>
                                                    <xsl:for-each select="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:requestCodeInfo">
                                                        <xsl:if test="ns3:trnStatusRsnCode != '' or ns3:additionalRespInfo != ''">
                                                            <xsl:call-template name="mapStatusRsnInfo">
                                                                <xsl:with-param name="txnStsRsnCode" select="ns3:trnStatusRsnCode"/>
                                                                <xsl:with-param name="addRespInfo" select="ns3:additionalRespInfo"/>
                                                            </xsl:call-template>
                                                        </xsl:if>
                                                    </xsl:for-each>
                                                </TxSts>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </RspnData>
                                    <xsl:if test="$RespOrgtrBic != ''">
                                        <RspnOrgtr>
                                            <Agt>
                                                <FinInstnId>
                                                    <BICFI>
                                                        <xsl:value-of select="$RespOrgtrBic"/>
                                                    </BICFI>
                                                </FinInstnId>
                                            </Agt>
                                        </RspnOrgtr>
                                    </xsl:if>
                                </InvstgtnData>
                            </xsl:when>
                            <xsl:when test="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:canReqRequestType = 'UTAP'">
                                <xsl:for-each select="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:requestCodeInfo">
                                    <xsl:if test="ns3:responseData != '' or ns3:responseNarrative != ''">
                                        <InvstgtnData>
                                            <xsl:if test="ns3:requestCode != ''">
                                                <OrgnlInvstgtnRsn>
                                                    <Cd>
                                                        <xsl:value-of select="ns3:requestCode"/>
                                                    </Cd>
                                                </OrgnlInvstgtnRsn>
                                            </xsl:if>
                                            <xsl:variable name="ResponseNarrative">
                                                <xsl:if test="ns3:responseNarrative != ''">
                                                    <xsl:value-of select="ns3:responseNarrative"/>
                                                </xsl:if>
                                            </xsl:variable>
                                            <xsl:variable name="RespDataPath">
                                                <xsl:call-template name="findValue">
                                                    <xsl:with-param name="data" select="ns3:responseData"/>
                                                    <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                    <xsl:with-param name="searchKey" select="'Path'"/>
                                                </xsl:call-template>
                                            </xsl:variable>
                                            <xsl:variable name="RespDataRemittance">
                                                <xsl:call-template name="findValue">
                                                    <xsl:with-param name="data" select="ns3:responseData"/>
                                                    <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                    <xsl:with-param name="searchKey" select="'Remittance'"/>
                                                </xsl:call-template>
                                            </xsl:variable>
                                            <xsl:if test="$ResponseNarrative != '' or $RespDataPath != '' or $RespDataRemittance = 'Remittance'">
                                                <RspnData>
                                                    <xsl:choose>
                                                        <xsl:when test="$ResponseNarrative = '' and ($RespDataPath != '' or $RespDataRemittance = 'Remittance')">
                                                            <TxData>
                                                                <xsl:if test="$RespDataPath != ''">
                                                                    <Pth>
                                                                        <xsl:value-of select="$RespDataPath"/>
                                                                    </Pth>
                                                                </xsl:if>
                                                                <Rcrd>
                                                                    <xsl:if test="$RespDataRemittance = 'Remittance'">
                                                                        <Rmt>
                                                                            <xsl:choose>
                                                                                <xsl:when test="$UnstrdRmtInf != '' ">
                                                                                    <Ustrd>
                                                                                        <xsl:value-of select="normalize-space(substring($UnstrdRmtInf ,'1','140'))"/>
                                                                                    </Ustrd>
                                                                                </xsl:when>
                                                                                <xsl:when test="$UnstrdRmtInf = '' and $StrdRmtInf != ''">
                                                                                    <xsl:value-of select="$StrdRmtInf" disable-output-escaping="yes"/>
                                                                                </xsl:when>
                                                                                <xsl:when test="$UnstrdRmtInf = '' and $StrdRmtInf = '' and ((/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:rfrDocInfTpCdOrPropCd) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:rfrDocInfNr) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:rfrDocAmCrNoteAm) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:adRmttInf1) or /ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:crdRefInfTpCdOrPropCd or /ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:crdRefInfTpCdOrPropProp or /ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:crdRefInfTpIssuer or /ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:crdRefInfRef or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:rfrDocAmRemittedAm) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:rfrDocAmCrNoteAmCcy) or(/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:rfrDocAmRemittedAmCcy))">
                                                                                    <xsl:if test=" (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:rfrDocInfTpCdOrPropCd) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:rfrDocInfNr) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:rfrDocAmCrNoteAm) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:adRmttInf1) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:adRmttInf2) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:adRmttInf3) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:rfrDocAmRemittedAm) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:crdRefInfTpCdOrPropCd) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:crdRefInfTpCdOrPropProp) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:crdRefInfTpIssuer) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:crdRefInfRef) or /ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:crdRefInfTpCdOrPropCd or /ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:crdRefInfTpCdOrPropProp or /ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:crdRefInfTpIssuer or /ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:crdRefInfRef">
                                                                                        <xsl:for-each select="/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo">
                                                                                            <Strd>
                                                                                                <xsl:if test="(ns16:rfrDocInfTpCdOrPropCd) or (ns16:rfrDocInfNr) ">
                                                                                                    <xsl:variable name="refrdocCount">
                                                                                                        <xsl:choose>
                                                                                                            <xsl:when test="ns16:rfrDocInfTpCdOrPropCd and ns16:rfrDocInfNr">
                                                                                                                <xsl:if test="count(ns16:rfrDocInfTpCdOrPropCd) &gt; count(ns16:rfrDocInfNr)">
                                                                                                                    <xsl:value-of select="count(ns16:rfrDocInfTpCdOrPropCd)"/>
                                                                                                                </xsl:if>
                                                                                                                <xsl:if test="count(ns16:rfrDocInfTpCdOrPropCd) &lt; count(ns16:rfrDocInfNr)">
                                                                                                                    <xsl:value-of select="count(ns16:rfrDocInfNr)"/>
                                                                                                                </xsl:if>
                                                                                                                <xsl:if test="count(ns16:rfrDocInfTpCdOrPropCd) = count(ns16:rfrDocInfNr)">
                                                                                                                    <xsl:value-of select="count(ns16:rfrDocInfNr)"/>
                                                                                                                </xsl:if>
                                                                                                            </xsl:when>
                                                                                                            <xsl:when test="ns16:rfrDocInfTpCdOrPropCd">
                                                                                                                <xsl:value-of select="count(ns16:rfrDocInfTpCdOrPropCd)"/>
                                                                                                            </xsl:when>
                                                                                                            <xsl:when test="ns16:rfrDocInfNr">
                                                                                                                <xsl:value-of select="count(ns16:rfrDocInfNr)"/>
                                                                                                            </xsl:when>
                                                                                                        </xsl:choose>
                                                                                                    </xsl:variable>
                                                                                                    <xsl:if test="$refrdocCount &gt; 0">
                                                                                                        <xsl:call-template name="RfrdDocinf">
                                                                                                            <xsl:with-param name="element" select="$refrdocCount"/>
                                                                                                            <xsl:with-param name="count" select="1"/>
                                                                                                        </xsl:call-template>
                                                                                                    </xsl:if>
                                                                                                </xsl:if>
                                                                                                <xsl:if test="(ns16:rfrDocAmCrNoteAm) or (ns16:rfrDocAmRemittedAm) or (ns16:rfrDocAmDuePayableAm) or (ns16:rfrDocAmDiscApplAmAm) or (ns16:rfrDocAmTaxAmAm) or (ns16:rfrDocAmAdjAmRsnAm)">
                                                                                                    <RfrdDocAmt>
                                                                                                        <xsl:if test="ns16:rfrDocAmCrNoteAm">
                                                                                                            <CdtNoteAmt>
                                                                                                                <xsl:attribute name="Ccy" namespace="">
                                                                                                                    <xsl:value-of select="ns16:rfrDocAmCrNoteAmCcy"/>
                                                                                                                </xsl:attribute>
                                                                                                                <xsl:choose>
                                                                                                                    <xsl:when test="ns16:rfrDocAmCrNoteAmCcy = 'JPY' and contains(ns16:rfrDocAmCrNoteAm, '.') = 'TRUE'">
                                                                                                                        <xsl:value-of select="(substring-before(ns16:rfrDocAmCrNoteAm, '.'))"/>
                                                                                                                    </xsl:when>
                                                                                                                    <xsl:otherwise>
                                                                                                                        <xsl:value-of select="ns16:rfrDocAmCrNoteAm"/>
                                                                                                                    </xsl:otherwise>
                                                                                                                </xsl:choose>
                                                                                                            </CdtNoteAmt>
                                                                                                        </xsl:if>
                                                                                                        <xsl:if test="ns16:rfrDocAmRemittedAm">
                                                                                                            <RmtdAmt>
                                                                                                                <xsl:attribute name="Ccy" namespace="">
                                                                                                                    <xsl:value-of select="ns16:rfrDocAmRemittedAmCcy"/>
                                                                                                                </xsl:attribute>
                                                                                                                <xsl:choose>
                                                                                                                    <xsl:when test="ns16:rfrDocAmRemittedAmCcy = 'JPY' and contains(ns16:rfrDocAmRemittedAm, '.') = 'TRUE'">
                                                                                                                        <xsl:value-of select="(substring-before(ns16:rfrDocAmRemittedAm, '.'))"/>
                                                                                                                    </xsl:when>
                                                                                                                    <xsl:otherwise>
                                                                                                                        <xsl:value-of select="ns16:rfrDocAmRemittedAm"/>
                                                                                                                    </xsl:otherwise>
                                                                                                                </xsl:choose>
                                                                                                            </RmtdAmt>
                                                                                                        </xsl:if>
                                                                                                    </RfrdDocAmt>
                                                                                                </xsl:if>
                                                                                                <xsl:if test="(ns16:crdRefInfTpCdOrPropCd) or (ns16:crdRefInfTpCdOrPropProp) or (ns16:crdRefInfTpIssuer) or (ns16:crdRefInfRef) ">
                                                                                                    <CdtrRefInf>
                                                                                                        <xsl:if test="(ns16:crdRefInfTpCdOrPropCd) or (ns16:crdRefInfTpCdOrPropProp) ">
                                                                                                            <Tp>
                                                                                                                <xsl:if test="ns16:crdRefInfTpCdOrPropCd">
                                                                                                                    <CdOrPrtry>
                                                                                                                        <Cd>
                                                                                                                            <xsl:value-of select="ns16:crdRefInfTpCdOrPropCd"/>
                                                                                                                        </Cd>
                                                                                                                    </CdOrPrtry>
                                                                                                                </xsl:if>
                                                                                                                <xsl:if test="ns16:crdRefInfTpCdOrPropProp">
                                                                                                                    <CdOrPrtry>
                                                                                                                        <Prtry>
                                                                                                                            <xsl:value-of select="substring(string(ns16:crdRefInfTpCdOrPropProp), '1', '35')"/>
                                                                                                                        </Prtry>
                                                                                                                    </CdOrPrtry>
                                                                                                                </xsl:if>
                                                                                                                <xsl:if test="ns16:crdRefInfTpIssuer">
                                                                                                                    <Issr>
                                                                                                                        <xsl:value-of select="substring(string(ns16:crdRefInfTpIssuer), '1', '35')"/>
                                                                                                                    </Issr>
                                                                                                                </xsl:if>
                                                                                                            </Tp>
                                                                                                        </xsl:if>
                                                                                                        <xsl:if test="ns16:crdRefInfRef">
                                                                                                            <Ref>
                                                                                                                <xsl:value-of select="substring(string(ns16:crdRefInfRef), '1', '35')"/>
                                                                                                            </Ref>
                                                                                                        </xsl:if>
                                                                                                    </CdtrRefInf>
                                                                                                </xsl:if>
                                                                                                <xsl:if test="ns16:adRmttInf1">
                                                                                                    <AddtlRmtInf>
                                                                                                        <xsl:value-of select="substring(string(ns16:adRmttInf1), '1', '140')"/>
                                                                                                    </AddtlRmtInf>
                                                                                                </xsl:if>
                                                                                                <xsl:if test="ns16:adRmttInf2">
                                                                                                    <AddtlRmtInf>
                                                                                                        <xsl:value-of select="substring(string(ns16:adRmttInf2), '1', '140')"/>
                                                                                                    </AddtlRmtInf>
                                                                                                </xsl:if>
                                                                                                <xsl:if test="ns16:adRmttInf3">
                                                                                                    <AddtlRmtInf>
                                                                                                        <xsl:value-of select="substring(string(ns16:adRmttInf3), '1', '140')"/>
                                                                                                    </AddtlRmtInf>
                                                                                                </xsl:if>
                                                                                            </Strd>
                                                                                        </xsl:for-each>
                                                                                    </xsl:if>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                    <xsl:if test="$isRltdRemImfoPresent = 'TRUE' or $isRltdRemIdPrsnt = 'TRUE'">
                                                                                        <Rltd>
                                                                                            <xsl:for-each select="/ns18:doOutwardMappingForCR/ns18:irelatedremittanceinfo[ns17:relRemInfoRemId or ns17:relRemInfRmtLocMthd or ns17:relRemInfRmtLocElectAddr or ns17:relRemInfRmtLocAddrName or ns17:relRemInfRmtLocAddrTownName or ns17:relRemInfRmtLocCountry]">
                                                                                                <xsl:if test="string((position() = '1')) != 'false'">
                                                                                                    <xsl:if test="ns17:relRemInfoRemId">
                                                                                                        <RmtId>
                                                                                                            <xsl:value-of select="substring(string(ns17:relRemInfoRemId), '1', '35')"/>
                                                                                                        </RmtId>
                                                                                                    </xsl:if>
                                                                                                </xsl:if>
                                                                                                <xsl:if test="string((position() = '1')) != 'false' or string((position() = '2')) != 'false'">
                                                                                                    <xsl:if test="ns17:relRemInfRmtLocMthd or ns17:relRemInfRmtLocElectAddr or ns17:relRemInfRmtLocAddrName or ns17:relRemInfRmtLocAddrTownName or ns17:relRemInfRmtLocCountry">
                                                                                                        <RmtLctnDtls>
                                                                                                            <xsl:if test="ns17:relRemInfRmtLocMthd">
                                                                                                                <Mtd>
                                                                                                                    <xsl:value-of select="substring(string(ns17:relRemInfRmtLocMthd), '1', '35')"/>
                                                                                                                </Mtd>
                                                                                                            </xsl:if>
                                                                                                            <xsl:if test="ns17:relRemInfRmtLocElectAddr">
                                                                                                                <ElctrncAdr>
                                                                                                                    <xsl:value-of select="ns17:relRemInfRmtLocElectAddr"/>
                                                                                                                </ElctrncAdr>
                                                                                                            </xsl:if>
                                                                                                            <xsl:if test="ns17:relRemInfRmtLocAddrName or ns17:relRemInfRmtLocAddrTownName or ns17:relRemInfRmtLocCountry">
                                                                                                                <PstlAdr>
                                                                                                                    <xsl:if test="ns17:relRemInfRmtLocAddrName">
                                                                                                                        <Nm>
                                                                                                                            <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrName), '1', '140')"/>
                                                                                                                        </Nm>
                                                                                                                    </xsl:if>
                                                                                                                    <xsl:choose>
                                                                                                                        <xsl:when test="ns17:relRemInfRmtLocAddrTownName and ns17:relRemInfRmtLocAddrCountry">
                                                                                                                            <Adr>
                                                                                                                                <xsl:if test="ns17:relRemInfRmtLocAddrDept">
                                                                                                                                    <Dept>
                                                                                                                                        <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrDept), '1', '70')"/>
                                                                                                                                    </Dept>
                                                                                                                                </xsl:if>
                                                                                                                                <xsl:if test="ns17:relRemInfRmtLocAddrSubDept">
                                                                                                                                    <SubDept>
                                                                                                                                        <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrSubDept), '1', '70')"/>
                                                                                                                                    </SubDept>
                                                                                                                                </xsl:if>
                                                                                                                                <xsl:if test="ns17:relRemInfRmtLocAddrStreetName">
                                                                                                                                    <StrtNm>
                                                                                                                                        <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrStreetName), '1', '70')"/>
                                                                                                                                    </StrtNm>
                                                                                                                                </xsl:if>
                                                                                                                                <xsl:if test="ns17:relRemInfRmtLocAddrBldgNo">
                                                                                                                                    <BldgNb>
                                                                                                                                        <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrBldgNo), '1', '16')"/>
                                                                                                                                    </BldgNb>
                                                                                                                                </xsl:if>
                                                                                                                                <xsl:if test="ns17:relRemInfRmtLocAddrBldgName">
                                                                                                                                    <BldgNm>
                                                                                                                                        <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrBldgName), '1', '35')"/>
                                                                                                                                    </BldgNm>
                                                                                                                                </xsl:if>
                                                                                                                                <xsl:if test="ns17:relRemInfRmtLocAddrBldgFloor">
                                                                                                                                    <Flr>
                                                                                                                                        <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrBldgFloor), '1', '70')"/>
                                                                                                                                    </Flr>
                                                                                                                                </xsl:if>
                                                                                                                                <xsl:if test="ns17:relRemInfRmtLocAddrPostBox">
                                                                                                                                    <PstBx>
                                                                                                                                        <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrPostBox), '1', '16')"/>
                                                                                                                                    </PstBx>
                                                                                                                                </xsl:if>
                                                                                                                                <xsl:if test="ns17:relRemInfRmtLocAddrRoom">
                                                                                                                                    <Room>
                                                                                                                                        <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrRoom), '1', '70')"/>
                                                                                                                                    </Room>
                                                                                                                                </xsl:if>
                                                                                                                                <xsl:if test="ns17:relRemInfRmtLocAddrPostCode">
                                                                                                                                    <PstCd>
                                                                                                                                        <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrPostCode), '1', '16')"/>
                                                                                                                                    </PstCd>
                                                                                                                                </xsl:if>
                                                                                                                                <xsl:if test="ns17:relRemInfRmtLocAddrTownName">
                                                                                                                                    <TwnNm>
                                                                                                                                        <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrTownName), '1', '35')"/>
                                                                                                                                    </TwnNm>
                                                                                                                                </xsl:if>
                                                                                                                                <xsl:if test="ns17:relRemInfRmtLocAddrTownLocation">
                                                                                                                                    <TwnLctnNm>
                                                                                                                                        <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrTownLocation), '1', '35')"/>
                                                                                                                                    </TwnLctnNm>
                                                                                                                                </xsl:if>
                                                                                                                                <xsl:if test="ns17:relRemInfRmtLocAddrDistrict">
                                                                                                                                    <DstrctNm>
                                                                                                                                        <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrDistrict), '1', '35')"/>
                                                                                                                                    </DstrctNm>
                                                                                                                                </xsl:if>
                                                                                                                                <xsl:if test="ns17:relRemInfRmtLocAddrCountrySubDiv">
                                                                                                                                    <CtrySubDvsn>
                                                                                                                                        <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrCountrySubDiv), '1', '35')"/>
                                                                                                                                    </CtrySubDvsn>
                                                                                                                                </xsl:if>
                                                                                                                                <xsl:if test="ns17:relRemInfRmtLocAddrCountry">
                                                                                                                                    <Ctry>
                                                                                                                                        <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrCountry), '1', '2')"/>
                                                                                                                                    </Ctry>
                                                                                                                                </xsl:if>
                                                                                                                            </Adr>
                                                                                                                        </xsl:when>
                                                                                                                        <xsl:otherwise>
                                                                                                                            <xsl:if test="ns17:relRemInfRmtLocAddrLine1 or ns17:relRemInfRmtLocAddrLine2 or ns17:relRemInfRmtLocAddrLine3">
                                                                                                                                <Adr>
                                                                                                                                    <xsl:if test="ns17:relRemInfRmtLocAddrLine1">
                                                                                                                                        <AdrLine>
                                                                                                                                            <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrLine1), '1', '35')"/>
                                                                                                                                        </AdrLine>
                                                                                                                                    </xsl:if>
                                                                                                                                    <xsl:if test="ns17:relRemInfRmtLocAddrLine2">
                                                                                                                                        <AdrLine>
                                                                                                                                            <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrLine2), '1', '35')"/>
                                                                                                                                        </AdrLine>
                                                                                                                                    </xsl:if>
                                                                                                                                    <xsl:if test="ns17:relRemInfRmtLocAddrLine3">
                                                                                                                                        <AdrLine>
                                                                                                                                            <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrLine3), '1', '35')"/>
                                                                                                                                        </AdrLine>
                                                                                                                                    </xsl:if>
                                                                                                                                </Adr>
                                                                                                                            </xsl:if>
                                                                                                                        </xsl:otherwise>
                                                                                                                    </xsl:choose>
                                                                                                                </PstlAdr>
                                                                                                            </xsl:if>
                                                                                                        </RmtLctnDtls>
                                                                                                    </xsl:if>
                                                                                                </xsl:if>
                                                                                            </xsl:for-each>
                                                                                        </Rltd>
                                                                                    </xsl:if>
                                                                                </xsl:otherwise>
                                                                            </xsl:choose>
                                                                        </Rmt>
                                                                    </xsl:if>
                                                                </Rcrd>
                                                            </TxData>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <RspnNrrtv>
                                                                <xsl:value-of select="substring($ResponseNarrative,1,500)"/>
                                                            </RspnNrrtv>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </RspnData>
                                            </xsl:if>
                                            <xsl:variable name="RespOrgtrBic">
                                                <xsl:call-template name="findValue">
                                                    <xsl:with-param name="data" select="ns3:responseData"/>
                                                    <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                    <xsl:with-param name="searchKey" select="'Resp. Orgtr BIC'"/>
                                                </xsl:call-template>
                                            </xsl:variable>
                                            <xsl:if test="$RespOrgtrBic != ''">
                                                <RspnOrgtr>
                                                    <Agt>
                                                        <FinInstnId>
                                                            <BICFI>
                                                                <xsl:value-of select="$RespOrgtrBic"/>
                                                            </BICFI>
                                                        </FinInstnId>
                                                    </Agt>
                                                </RspnOrgtr>
                                            </xsl:if>
                                        </InvstgtnData>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:canReqRequestType = 'RQFI'">
                                    <xsl:for-each select="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:requestCodeInfo">
                                        <xsl:if test="ns3:responseData or ns3:responseNarrative">
                                            <InvstgtnData>
                                                <OrgnlInvstgtnSeq>
                                                    <xsl:value-of select="position()"/>
                                                </OrgnlInvstgtnSeq>
                                                <xsl:if test="ns3:requestCode != ''">
                                                    <OrgnlInvstgtnRsn>
                                                        <Cd>
                                                            <xsl:value-of select="ns3:requestCode"/>
                                                        </Cd>
                                                    </OrgnlInvstgtnRsn>
                                                </xsl:if>
                                                <xsl:if test="ns3:reasonSubType != ''">
                                                    <OrgnlInvstgtnRsnSubTp>
                                                        <Cd>
                                                            <xsl:value-of select="ns3:reasonSubType"/>
                                                        </Cd>
                                                    </OrgnlInvstgtnRsnSubTp>
                                                </xsl:if>
                                                <xsl:variable name="ResponseNarrative">
                                                    <xsl:if test="ns3:responseNarrative">
                                                        <xsl:value-of select="ns3:responseNarrative"/>
                                                    </xsl:if>
                                                </xsl:variable>
                                                <xsl:variable name="RespDataPath">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Path'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="RespDataRemittance">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Remittance'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="RespDataInstAgt">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Agent - Instructed agent'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="RespDataInstngAgt">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Agent - Instructing agent'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="RespDataCrdtAgt">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Agent - Creditor agent'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="RespDataInstReimAgt">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Agent - Instructing reimbursement agent'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="RespDataInstrReimAgt">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Agent - Instructed reimbursement agent'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="RespDataThirdReimAgt">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Agent - Third reimbursement agent'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="RespDataIntinAgt1">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Agent - Intermediary agent 1'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="RespDataIntinAgt2">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Agent - Intermediary agent 2'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="RespDataIntinAgt3">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Agent - Intermediary agent 3'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="RespDataDebtorAgt">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Agent - Debtor agent'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="RespDataPrevAgt1">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Agent - Previous instructing agent 1'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="RespDataPrevAgt2">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Agent - Previous instructing agent 2'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="RespDataPrevAgt3">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Agent - Previous instructing agent 3'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="RespDataUltDbtPty">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Party - Ultimate Debtor'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="RespDataDebtorPty">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Party - Debtor'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="RespDataInitPty">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Party - Initiating Party'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="RespDataCreditorPty">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Party - Creditor'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="RespDataUltCdtPty">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Party - Ultimate Creditor'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="RespDataOther">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Other'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="contextAmount">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Amount'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="contextAmountCurrency">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Amount currency'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="contextAnyBic">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Any BIC'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="contextBICFI">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'BICFI'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="contextCashAcctIBAN">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Cash account iban'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="contextCashAcctOthrId">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Cash account other id'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="contextCashAcctSchmNmCode">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Cash account schemename code'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="contextCashAcctSchmNmProp">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Cash account schemename prop'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="contextCashAcctIdIssuer">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Cash account ID Issuer'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="contextCashAcctTypeCode">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Cash account type code'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="contextCashAcctTypeProp">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Cash account type prop'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="contextCashAcctCurrency">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Cash account currency'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="contextCashAcctName">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Cash account name'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="contextCashAcctProxyTypeCode">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Cash account proxy type code'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="contextCashAcctProxyTypeProp">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Cash account proxy type prop'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="contextCashAcctProxyId">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Cash account proxy id'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="contextCode">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Code'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="contextDate">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Date'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:variable name="contextDateTime">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Date Time'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:if test="$ResponseNarrative != '' or $RespDataPath != '' or $RespDataRemittance = 'Remittance' or $RespDataOther != '' or $RespDataInstngAgt != '' or $RespDataInstAgt != '' or $RespDataCrdtAgt != '' or $RespDataInstReimAgt != '' or $RespDataInstrReimAgt != '' or $RespDataIntinAgt1 != '' or $RespDataIntinAgt2 != '' or $RespDataIntinAgt3 != '' or $RespDataDebtorAgt != '' or $RespDataPrevAgt1 != '' or $RespDataPrevAgt2 != '' or $RespDataPrevAgt3 != '' or $RespDataUltDbtPty != '' or $RespDataDebtorPty != '' or $RespDataInitPty != '' or $RespDataCreditorPty != '' or $RespDataUltCdtPty != '' or $contextCashAcctIBAN != '' or $contextCashAcctOthrId != '' or $contextCashAcctSchmNmCode != '' or $contextCashAcctSchmNmProp != '' or $contextCashAcctIdIssuer != '' or $contextCashAcctProxyId != '' or $contextCashAcctProxyTypeProp != '' or $contextCashAcctProxyTypeCode != '' or $contextCashAcctName != '' or $contextCashAcctCurrency != '' or $contextCashAcctTypeProp != '' or $contextCashAcctTypeCode != '' or $contextAmountCurrency != '' or $contextAmount != '' or $contextAnyBic != '' or $contextBICFI != '' or $contextCode != '' or $contextDate != '' or $contextDateTime != '' or $RespDataOther != ''">
                                                    <RspnData>
                                                        <xsl:choose>
                                                            <xsl:when test="$ResponseNarrative = '' and ($RespDataPath != '' or $RespDataRemittance = 'Remittance' or $RespDataOther != '' or $RespDataInstngAgt != '' or $RespDataInstAgt != '' or $RespDataCrdtAgt != '' or $RespDataInstReimAgt != '' or $RespDataInstrReimAgt != '' or $RespDataIntinAgt1 != '' or $RespDataIntinAgt2 != '' or $RespDataIntinAgt3 != '' or $RespDataDebtorAgt != '' or $RespDataPrevAgt1 != '' or $RespDataPrevAgt2 != '' or $RespDataPrevAgt3 != '' or $RespDataUltDbtPty != '' or $RespDataDebtorPty != '' or $RespDataInitPty != '' or $RespDataCreditorPty != '' or $RespDataUltCdtPty != '' or $contextCashAcctIBAN != '' or $contextCashAcctOthrId != '' or $contextCashAcctSchmNmCode != '' or $contextCashAcctSchmNmProp != '' or $contextCashAcctIdIssuer != '' or $contextCashAcctProxyId != '' or $contextCashAcctProxyTypeProp != '' or $contextCashAcctProxyTypeCode != '' or $contextCashAcctName != '' or $contextCashAcctCurrency != '' or $contextCashAcctTypeProp != '' or $contextCashAcctTypeCode != '' or $contextAmountCurrency or $contextAmount != '' or $contextAnyBic != '' or $contextBICFI != '' or $contextCode != '' or $contextDate != '' or $contextDateTime != '' or $RespDataOther != '')">
                                                                <TxData>
                                                                    <xsl:if test="$RespDataPath != ''">
                                                                        <Pth>
                                                                            <xsl:value-of select="$RespDataPath"/>
                                                                        </Pth>
                                                                    </xsl:if>
                                                                    <Rcrd>
                                                                        <xsl:choose>
                                                                            <xsl:when test="$RespDataInstngAgt = 'Agent - Instructing agent' or $RespDataInstAgt = 'Agent - Instructed agent' or $RespDataCrdtAgt = 'Agent - Creditor agent' or $RespDataInstReimAgt = 'Agent - Instructing reimbursement agent' or $RespDataThirdReimAgt = 'Agent - Third reimbursement agent' or $RespDataIntinAgt1 = 'Agent - Intermediary agent 1' or $RespDataIntinAgt2 = 'Agent - Intermediary agent 2' or $RespDataIntinAgt1 = 'Agent - Intermediary agent 3' or $RespDataDebtorAgt = 'Agent - Debtor agent' or $RespDataPrevAgt1 = 'Agent - Previous instructing agent 1' or $RespDataPrevAgt2 = 'Agent - Previous instructing agent 2' or $RespDataPrevAgt3 = 'Agent - Previous instructing agent 3'">
                                                                                <xsl:choose>
                                                                                    <xsl:when test="$RespDataInstAgt = 'Agent - Instructed agent'">
                                                                                        <xsl:variable name="recverGPos">
                                                                                            <xsl:for-each select="/ns18:doOutwardMappingForCR/ns18:ipartycredit[ns12:crPtyRole = 'RECVER' and ns12:crPtyRoleIndicator = 'G']">
                                                                                                <xsl:value-of select="position()"/>
                                                                                            </xsl:for-each>
                                                                                        </xsl:variable>
                                                                                        <xsl:variable name="roleIndicator">
                                                                                            <xsl:choose>
                                                                                                <xsl:when test="$recverGPos != ''">
                                                                                                    <xsl:value-of select="'G'"/>
                                                                                                </xsl:when>
                                                                                                <xsl:otherwise>
                                                                                                    <xsl:value-of select="'D'"/>
                                                                                                </xsl:otherwise>
                                                                                            </xsl:choose>
                                                                                        </xsl:variable>
                                                                                        <xsl:for-each select="/ns18:doOutwardMappingForCR/ns18:ipartycredit[ns12:crPtyRole = 'RECVER' and ns12:crPtyRoleIndicator = $roleIndicator]">
                                                                                            <xsl:call-template name="mapCreditPartyDetails">
                                                                                                <xsl:with-param name="crPtyIdentifierCode" select="ns12:crPtyIdentifierCode"/>
                                                                                                <xsl:with-param name="crPtyClearingMemberId" select="ns12:crPtyClearingMemberId"/>
                                                                                                <xsl:with-param name="crPtyClearingSystemIdCode" select="ns12:crPtyClearingSystemIdCode"/>
                                                                                                <xsl:with-param name="crPtyLei" select="ns12:crPtyLei"/>
                                                                                                <xsl:with-param name="crPtyName" select="ns12:crPtyName"/>
                                                                                                <xsl:with-param name="crPtyAddrDept" select="ns12:crPtyAddrDept"/>
                                                                                                <xsl:with-param name="crPtyAddrSubdept" select="ns12:crPtyAddrSubdept"/>
                                                                                                <xsl:with-param name="crPtyAddrStreetName" select="ns12:crPtyAddrStreetName"/>
                                                                                                <xsl:with-param name="crPtyAddrBldgNo" select="ns12:crPtyAddrBldgNo"/>
                                                                                                <xsl:with-param name="crPtyAddrBldgName" select="ns12:crPtyAddrBldgName"/>
                                                                                                <xsl:with-param name="crPtyAddrBldgFloor" select="ns12:crPtyAddrBldgFloor"/>
                                                                                                <xsl:with-param name="crPtyAddrPostBox" select="ns12:crPtyAddrBldgFloor"/>
                                                                                                <xsl:with-param name="crPtyAddrRoom" select="ns12:crPtyAddrPostCode"/>
                                                                                                <xsl:with-param name="crPtyAddrPostCode" select="ns12:crPtyAddrTownName"/>
                                                                                                <xsl:with-param name="crPtyAddrTownName" select="ns12:crPtyAddrTownLocation"/>
                                                                                                <xsl:with-param name="crPtyAddrTownLocation" select="ns12:crPtyAddrCountrySubDiv"/>
                                                                                                <xsl:with-param name="crPtyAddrDistrict" select="ns12:crPtyAddrDistrict"/>
                                                                                                <xsl:with-param name="crPtyAddrCountrySubDiv" select="ns12:crPtyAddrCountrySubDiv"/>
                                                                                                <xsl:with-param name="crPtyCountry" select="ns12:crPtyCountry"/>
                                                                                                <xsl:with-param name="crPtyAddressLine1" select="ns12:crPtyAddressLine1"/>
                                                                                                <xsl:with-param name="crPtyAddressLine2" select="ns12:crPtyAddressLine2"/>
                                                                                            </xsl:call-template>
                                                                                        </xsl:for-each>
                                                                                    </xsl:when>
                                                                                    <xsl:when test="$RespDataCrdtAgt = 'Agent - Creditor agent'">
                                                                                        <xsl:variable name="acwinsGPos">
                                                                                            <xsl:for-each select="/ns18:doOutwardMappingForCR/ns18:ipartycredit[ns12:crPtyRole = 'ACWINS' and ns12:crPtyRoleIndicator = 'G']">
                                                                                                <xsl:value-of select="position()"/>
                                                                                            </xsl:for-each>
                                                                                        </xsl:variable>
                                                                                        <xsl:variable name="roleValue">
                                                                                            <xsl:choose>
                                                                                                <xsl:when test="$acwinsGPos != ''">
                                                                                                    <xsl:value-of select="'ACWINS'"/>
                                                                                                </xsl:when>
                                                                                                <xsl:otherwise>
                                                                                                    <xsl:value-of select="'RECVER'"/>
                                                                                                </xsl:otherwise>
                                                                                            </xsl:choose>
                                                                                        </xsl:variable>
                                                                                        <xsl:for-each select="/ns18:doOutwardMappingForCR/ns18:ipartycredit[ns12:crPtyRole = $roleValue and ns12:crPtyRoleIndicator = 'G']">
                                                                                            <xsl:call-template name="mapCreditPartyDetails">
                                                                                                <xsl:with-param name="crPtyIdentifierCode" select="ns12:crPtyIdentifierCode"/>
                                                                                                <xsl:with-param name="crPtyClearingMemberId" select="ns12:crPtyClearingMemberId"/>
                                                                                                <xsl:with-param name="crPtyClearingSystemIdCode" select="ns12:crPtyClearingSystemIdCode"/>
                                                                                                <xsl:with-param name="crPtyLei" select="ns12:crPtyLei"/>
                                                                                                <xsl:with-param name="crPtyName" select="ns12:crPtyName"/>
                                                                                                <xsl:with-param name="crPtyAddrDept" select="ns12:crPtyAddrDept"/>
                                                                                                <xsl:with-param name="crPtyAddrSubdept" select="ns12:crPtyAddrSubdept"/>
                                                                                                <xsl:with-param name="crPtyAddrStreetName" select="ns12:crPtyAddrStreetName"/>
                                                                                                <xsl:with-param name="crPtyAddrBldgNo" select="ns12:crPtyAddrBldgNo"/>
                                                                                                <xsl:with-param name="crPtyAddrBldgName" select="ns12:crPtyAddrBldgName"/>
                                                                                                <xsl:with-param name="crPtyAddrBldgFloor" select="ns12:crPtyAddrBldgFloor"/>
                                                                                                <xsl:with-param name="crPtyAddrPostBox" select="ns12:crPtyAddrBldgFloor"/>
                                                                                                <xsl:with-param name="crPtyAddrRoom" select="ns12:crPtyAddrPostCode"/>
                                                                                                <xsl:with-param name="crPtyAddrPostCode" select="ns12:crPtyAddrTownName"/>
                                                                                                <xsl:with-param name="crPtyAddrTownName" select="ns12:crPtyAddrTownLocation"/>
                                                                                                <xsl:with-param name="crPtyAddrTownLocation" select="ns12:crPtyAddrCountrySubDiv"/>
                                                                                                <xsl:with-param name="crPtyAddrDistrict" select="ns12:crPtyAddrDistrict"/>
                                                                                                <xsl:with-param name="crPtyAddrCountrySubDiv" select="ns12:crPtyAddrCountrySubDiv"/>
                                                                                                <xsl:with-param name="crPtyCountry" select="ns12:crPtyCountry"/>
                                                                                                <xsl:with-param name="crPtyAddressLine1" select="ns12:crPtyAddressLine1"/>
                                                                                                <xsl:with-param name="crPtyAddressLine2" select="ns12:crPtyAddressLine2"/>
                                                                                            </xsl:call-template>
                                                                                        </xsl:for-each>
                                                                                    </xsl:when>
                                                                                    <xsl:when test="$RespDataInstngAgt = 'Agent - Instructing agent'">
                                                                                        <Agt>
                                                                                            <FinInstnId>
                                                                                                <xsl:if test="ns18:doOutwardMappingForCR/ns18:iorgpaymentrecord/ns7:companyBic != ''">
                                                                                                    <BICFI>
                                                                                                        <xsl:value-of select="ns18:doOutwardMappingForCR/ns18:iorgpaymentrecord/ns7:companyBic"/>
                                                                                                    </BICFI>
                                                                                                </xsl:if>
                                                                                            </FinInstnId>
                                                                                        </Agt>
                                                                                    </xsl:when>
                                                                                    <xsl:otherwise>
                                                                                        <xsl:choose>
                                                                                            <xsl:when test="$RespDataInstReimAgt = 'Agent - Instructing reimbursement agent'">
                                                                                                <xsl:variable name="agentRoleValue">
                                                                                                    <xsl:call-template name="getAgentRole">
                                                                                                        <xsl:with-param name="agentName" select="$RespDataInstReimAgt"/>
                                                                                                    </xsl:call-template>
                                                                                                </xsl:variable>
                                                                                                <xsl:variable name="agentRoleValueBeforeD">
                                                                                                    <xsl:value-of select="substring-before($agentRoleValue,'$')"/>
                                                                                                </xsl:variable>
                                                                                                <xsl:variable name="agentRoleValueAfterD">
                                                                                                    <xsl:value-of select="substring-after($agentRoleValue,'$')"/>
                                                                                                </xsl:variable>
                                                                                                <xsl:for-each select="/ns18:doOutwardMappingForCR/ns18:ipartycredit[ns12:crPtyRole = $agentRoleValueBeforeD and ns12:crPtyRoleIndicator = $agentRoleValueAfterD]">
                                                                                                    <xsl:call-template name="mapCreditPartyDetails">
                                                                                                        <xsl:with-param name="crPtyIdentifierCode" select="ns12:crPtyIdentifierCode"/>
                                                                                                        <xsl:with-param name="crPtyClearingMemberId" select="ns12:crPtyClearingMemberId"/>
                                                                                                        <xsl:with-param name="crPtyClearingSystemIdCode" select="ns12:crPtyClearingSystemIdCode"/>
                                                                                                        <xsl:with-param name="crPtyLei" select="ns12:crPtyLei"/>
                                                                                                        <xsl:with-param name="crPtyName" select="ns12:crPtyName"/>
                                                                                                        <xsl:with-param name="crPtyAddrDept" select="ns12:crPtyAddrDept"/>
                                                                                                        <xsl:with-param name="crPtyAddrSubdept" select="ns12:crPtyAddrSubdept"/>
                                                                                                        <xsl:with-param name="crPtyAddrStreetName" select="ns12:crPtyAddrStreetName"/>
                                                                                                        <xsl:with-param name="crPtyAddrBldgNo" select="ns12:crPtyAddrBldgNo"/>
                                                                                                        <xsl:with-param name="crPtyAddrBldgName" select="ns12:crPtyAddrBldgName"/>
                                                                                                        <xsl:with-param name="crPtyAddrBldgFloor" select="ns12:crPtyAddrBldgFloor"/>
                                                                                                        <xsl:with-param name="crPtyAddrPostBox" select="ns12:crPtyAddrBldgFloor"/>
                                                                                                        <xsl:with-param name="crPtyAddrRoom" select="ns12:crPtyAddrPostCode"/>
                                                                                                        <xsl:with-param name="crPtyAddrPostCode" select="ns12:crPtyAddrTownName"/>
                                                                                                        <xsl:with-param name="crPtyAddrTownName" select="ns12:crPtyAddrTownLocation"/>
                                                                                                        <xsl:with-param name="crPtyAddrTownLocation" select="ns12:crPtyAddrCountrySubDiv"/>
                                                                                                        <xsl:with-param name="crPtyAddrDistrict" select="ns12:crPtyAddrDistrict"/>
                                                                                                        <xsl:with-param name="crPtyAddrCountrySubDiv" select="ns12:crPtyAddrCountrySubDiv"/>
                                                                                                        <xsl:with-param name="crPtyCountry" select="ns12:crPtyCountry"/>
                                                                                                        <xsl:with-param name="crPtyAddressLine1" select="ns12:crPtyAddressLine1"/>
                                                                                                        <xsl:with-param name="crPtyAddressLine2" select="ns12:crPtyAddressLine2"/>
                                                                                                    </xsl:call-template>
                                                                                                </xsl:for-each>
                                                                                            </xsl:when>
                                                                                            <xsl:when test="$RespDataInstrReimAgt = 'Agent - Instructed reimbursement agent'">
                                                                                                <xsl:variable name="agentRoleValue">
                                                                                                    <xsl:call-template name="getAgentRole">
                                                                                                        <xsl:with-param name="agentName" select="$RespDataInstrReimAgt"/>
                                                                                                    </xsl:call-template>
                                                                                                </xsl:variable>
                                                                                                <xsl:variable name="agentRoleValueBeforeD">
                                                                                                    <xsl:value-of select="substring-before($agentRoleValue,'$')"/>
                                                                                                </xsl:variable>
                                                                                                <xsl:variable name="agentRoleValueAfterD">
                                                                                                    <xsl:value-of select="substring-after($agentRoleValue,'$')"/>
                                                                                                </xsl:variable>
                                                                                                <xsl:for-each select="/ns18:doOutwardMappingForCR/ns18:ipartycredit[ns12:crPtyRole = $agentRoleValueBeforeD and ns12:crPtyRoleIndicator = $agentRoleValueAfterD]">
                                                                                                    <xsl:call-template name="mapCreditPartyDetails">
                                                                                                        <xsl:with-param name="crPtyIdentifierCode" select="ns12:crPtyIdentifierCode"/>
                                                                                                        <xsl:with-param name="crPtyClearingMemberId" select="ns12:crPtyClearingMemberId"/>
                                                                                                        <xsl:with-param name="crPtyClearingSystemIdCode" select="ns12:crPtyClearingSystemIdCode"/>
                                                                                                        <xsl:with-param name="crPtyLei" select="ns12:crPtyLei"/>
                                                                                                        <xsl:with-param name="crPtyName" select="ns12:crPtyName"/>
                                                                                                        <xsl:with-param name="crPtyAddrDept" select="ns12:crPtyAddrDept"/>
                                                                                                        <xsl:with-param name="crPtyAddrSubdept" select="ns12:crPtyAddrSubdept"/>
                                                                                                        <xsl:with-param name="crPtyAddrStreetName" select="ns12:crPtyAddrStreetName"/>
                                                                                                        <xsl:with-param name="crPtyAddrBldgNo" select="ns12:crPtyAddrBldgNo"/>
                                                                                                        <xsl:with-param name="crPtyAddrBldgName" select="ns12:crPtyAddrBldgName"/>
                                                                                                        <xsl:with-param name="crPtyAddrBldgFloor" select="ns12:crPtyAddrBldgFloor"/>
                                                                                                        <xsl:with-param name="crPtyAddrPostBox" select="ns12:crPtyAddrBldgFloor"/>
                                                                                                        <xsl:with-param name="crPtyAddrRoom" select="ns12:crPtyAddrPostCode"/>
                                                                                                        <xsl:with-param name="crPtyAddrPostCode" select="ns12:crPtyAddrTownName"/>
                                                                                                        <xsl:with-param name="crPtyAddrTownName" select="ns12:crPtyAddrTownLocation"/>
                                                                                                        <xsl:with-param name="crPtyAddrTownLocation" select="ns12:crPtyAddrCountrySubDiv"/>
                                                                                                        <xsl:with-param name="crPtyAddrDistrict" select="ns12:crPtyAddrDistrict"/>
                                                                                                        <xsl:with-param name="crPtyAddrCountrySubDiv" select="ns12:crPtyAddrCountrySubDiv"/>
                                                                                                        <xsl:with-param name="crPtyCountry" select="ns12:crPtyCountry"/>
                                                                                                        <xsl:with-param name="crPtyAddressLine1" select="ns12:crPtyAddressLine1"/>
                                                                                                        <xsl:with-param name="crPtyAddressLine2" select="ns12:crPtyAddressLine2"/>
                                                                                                    </xsl:call-template>
                                                                                                </xsl:for-each>
                                                                                            </xsl:when>
                                                                                            <xsl:when test="$RespDataThirdReimAgt = 'Agent - Third reimbursement agent'">
                                                                                                <xsl:variable name="agentRoleValue">
                                                                                                    <xsl:call-template name="getAgentRole">
                                                                                                        <xsl:with-param name="agentName" select="$RespDataInstrReimAgt"/>
                                                                                                    </xsl:call-template>
                                                                                                </xsl:variable>
                                                                                                <xsl:variable name="agentRoleValueBeforeD">
                                                                                                    <xsl:value-of select="substring-before($agentRoleValue,'$')"/>
                                                                                                </xsl:variable>
                                                                                                <xsl:variable name="agentRoleValueAfterD">
                                                                                                    <xsl:value-of select="substring-after($agentRoleValue,'$')"/>
                                                                                                </xsl:variable>
                                                                                                <xsl:for-each select="/ns18:doOutwardMappingForCR/ns18:ipartycredit[ns12:crPtyRole = $agentRoleValueBeforeD and ns12:crPtyRoleIndicator = $agentRoleValueAfterD]">
                                                                                                    <xsl:call-template name="mapCreditPartyDetails">
                                                                                                        <xsl:with-param name="crPtyIdentifierCode" select="ns12:crPtyIdentifierCode"/>
                                                                                                        <xsl:with-param name="crPtyClearingMemberId" select="ns12:crPtyClearingMemberId"/>
                                                                                                        <xsl:with-param name="crPtyClearingSystemIdCode" select="ns12:crPtyClearingSystemIdCode"/>
                                                                                                        <xsl:with-param name="crPtyLei" select="ns12:crPtyLei"/>
                                                                                                        <xsl:with-param name="crPtyName" select="ns12:crPtyName"/>
                                                                                                        <xsl:with-param name="crPtyAddrDept" select="ns12:crPtyAddrDept"/>
                                                                                                        <xsl:with-param name="crPtyAddrSubdept" select="ns12:crPtyAddrSubdept"/>
                                                                                                        <xsl:with-param name="crPtyAddrStreetName" select="ns12:crPtyAddrStreetName"/>
                                                                                                        <xsl:with-param name="crPtyAddrBldgNo" select="ns12:crPtyAddrBldgNo"/>
                                                                                                        <xsl:with-param name="crPtyAddrBldgName" select="ns12:crPtyAddrBldgName"/>
                                                                                                        <xsl:with-param name="crPtyAddrBldgFloor" select="ns12:crPtyAddrBldgFloor"/>
                                                                                                        <xsl:with-param name="crPtyAddrPostBox" select="ns12:crPtyAddrBldgFloor"/>
                                                                                                        <xsl:with-param name="crPtyAddrRoom" select="ns12:crPtyAddrPostCode"/>
                                                                                                        <xsl:with-param name="crPtyAddrPostCode" select="ns12:crPtyAddrTownName"/>
                                                                                                        <xsl:with-param name="crPtyAddrTownName" select="ns12:crPtyAddrTownLocation"/>
                                                                                                        <xsl:with-param name="crPtyAddrTownLocation" select="ns12:crPtyAddrCountrySubDiv"/>
                                                                                                        <xsl:with-param name="crPtyAddrDistrict" select="ns12:crPtyAddrDistrict"/>
                                                                                                        <xsl:with-param name="crPtyAddrCountrySubDiv" select="ns12:crPtyAddrCountrySubDiv"/>
                                                                                                        <xsl:with-param name="crPtyCountry" select="ns12:crPtyCountry"/>
                                                                                                        <xsl:with-param name="crPtyAddressLine1" select="ns12:crPtyAddressLine1"/>
                                                                                                        <xsl:with-param name="crPtyAddressLine2" select="ns12:crPtyAddressLine2"/>
                                                                                                    </xsl:call-template>
                                                                                                </xsl:for-each>
                                                                                            </xsl:when>
                                                                                            <xsl:when test="$RespDataIntinAgt1 = 'Agent - Intermediary agent 1'">
                                                                                                <xsl:variable name="agentRoleValue">
                                                                                                    <xsl:call-template name="getAgentRole">
                                                                                                        <xsl:with-param name="agentName" select="$RespDataIntinAgt1"/>
                                                                                                    </xsl:call-template>
                                                                                                </xsl:variable>
                                                                                                <xsl:variable name="agentRoleValueBeforeD">
                                                                                                    <xsl:value-of select="substring-before($agentRoleValue,'$')"/>
                                                                                                </xsl:variable>
                                                                                                <xsl:variable name="agentRoleValueAfterD">
                                                                                                    <xsl:value-of select="substring-after($agentRoleValue,'$')"/>
                                                                                                </xsl:variable>
                                                                                                <xsl:for-each select="/ns18:doOutwardMappingForCR/ns18:ipartycredit[ns12:crPtyRole = $agentRoleValueBeforeD and ns12:crPtyRoleIndicator = $agentRoleValueAfterD]">
                                                                                                    <xsl:call-template name="mapCreditPartyDetails">
                                                                                                        <xsl:with-param name="crPtyIdentifierCode" select="ns12:crPtyIdentifierCode"/>
                                                                                                        <xsl:with-param name="crPtyClearingMemberId" select="ns12:crPtyClearingMemberId"/>
                                                                                                        <xsl:with-param name="crPtyClearingSystemIdCode" select="ns12:crPtyClearingSystemIdCode"/>
                                                                                                        <xsl:with-param name="crPtyLei" select="ns12:crPtyLei"/>
                                                                                                        <xsl:with-param name="crPtyName" select="ns12:crPtyName"/>
                                                                                                        <xsl:with-param name="crPtyAddrDept" select="ns12:crPtyAddrDept"/>
                                                                                                        <xsl:with-param name="crPtyAddrSubdept" select="ns12:crPtyAddrSubdept"/>
                                                                                                        <xsl:with-param name="crPtyAddrStreetName" select="ns12:crPtyAddrStreetName"/>
                                                                                                        <xsl:with-param name="crPtyAddrBldgNo" select="ns12:crPtyAddrBldgNo"/>
                                                                                                        <xsl:with-param name="crPtyAddrBldgName" select="ns12:crPtyAddrBldgName"/>
                                                                                                        <xsl:with-param name="crPtyAddrBldgFloor" select="ns12:crPtyAddrBldgFloor"/>
                                                                                                        <xsl:with-param name="crPtyAddrPostBox" select="ns12:crPtyAddrBldgFloor"/>
                                                                                                        <xsl:with-param name="crPtyAddrRoom" select="ns12:crPtyAddrPostCode"/>
                                                                                                        <xsl:with-param name="crPtyAddrPostCode" select="ns12:crPtyAddrTownName"/>
                                                                                                        <xsl:with-param name="crPtyAddrTownName" select="ns12:crPtyAddrTownLocation"/>
                                                                                                        <xsl:with-param name="crPtyAddrTownLocation" select="ns12:crPtyAddrCountrySubDiv"/>
                                                                                                        <xsl:with-param name="crPtyAddrDistrict" select="ns12:crPtyAddrDistrict"/>
                                                                                                        <xsl:with-param name="crPtyAddrCountrySubDiv" select="ns12:crPtyAddrCountrySubDiv"/>
                                                                                                        <xsl:with-param name="crPtyCountry" select="ns12:crPtyCountry"/>
                                                                                                        <xsl:with-param name="crPtyAddressLine1" select="ns12:crPtyAddressLine1"/>
                                                                                                        <xsl:with-param name="crPtyAddressLine2" select="ns12:crPtyAddressLine2"/>
                                                                                                    </xsl:call-template>
                                                                                                </xsl:for-each>
                                                                                            </xsl:when>
                                                                                            <xsl:when test="$RespDataIntinAgt2 = 'Agent - Intermediary agent 2'">
                                                                                                <xsl:variable name="agentRoleValue">
                                                                                                    <xsl:call-template name="getAgentRole">
                                                                                                        <xsl:with-param name="agentName" select="$RespDataIntinAgt2"/>
                                                                                                    </xsl:call-template>
                                                                                                </xsl:variable>
                                                                                                <xsl:variable name="agentRoleValueBeforeD">
                                                                                                    <xsl:value-of select="substring-before($agentRoleValue,'$')"/>
                                                                                                </xsl:variable>
                                                                                                <xsl:variable name="agentRoleValueAfterD">
                                                                                                    <xsl:value-of select="substring-after($agentRoleValue,'$')"/>
                                                                                                </xsl:variable>
                                                                                                <xsl:for-each select="/ns18:doOutwardMappingForCR/ns18:ipartycredit[ns12:crPtyRole = $agentRoleValueBeforeD and ns12:crPtyRoleIndicator = $agentRoleValueAfterD]">
                                                                                                    <xsl:call-template name="mapCreditPartyDetails">
                                                                                                        <xsl:with-param name="crPtyIdentifierCode" select="ns12:crPtyIdentifierCode"/>
                                                                                                        <xsl:with-param name="crPtyClearingMemberId" select="ns12:crPtyClearingMemberId"/>
                                                                                                        <xsl:with-param name="crPtyClearingSystemIdCode" select="ns12:crPtyClearingSystemIdCode"/>
                                                                                                        <xsl:with-param name="crPtyLei" select="ns12:crPtyLei"/>
                                                                                                        <xsl:with-param name="crPtyName" select="ns12:crPtyName"/>
                                                                                                        <xsl:with-param name="crPtyAddrDept" select="ns12:crPtyAddrDept"/>
                                                                                                        <xsl:with-param name="crPtyAddrSubdept" select="ns12:crPtyAddrSubdept"/>
                                                                                                        <xsl:with-param name="crPtyAddrStreetName" select="ns12:crPtyAddrStreetName"/>
                                                                                                        <xsl:with-param name="crPtyAddrBldgNo" select="ns12:crPtyAddrBldgNo"/>
                                                                                                        <xsl:with-param name="crPtyAddrBldgName" select="ns12:crPtyAddrBldgName"/>
                                                                                                        <xsl:with-param name="crPtyAddrBldgFloor" select="ns12:crPtyAddrBldgFloor"/>
                                                                                                        <xsl:with-param name="crPtyAddrPostBox" select="ns12:crPtyAddrBldgFloor"/>
                                                                                                        <xsl:with-param name="crPtyAddrRoom" select="ns12:crPtyAddrPostCode"/>
                                                                                                        <xsl:with-param name="crPtyAddrPostCode" select="ns12:crPtyAddrTownName"/>
                                                                                                        <xsl:with-param name="crPtyAddrTownName" select="ns12:crPtyAddrTownLocation"/>
                                                                                                        <xsl:with-param name="crPtyAddrTownLocation" select="ns12:crPtyAddrCountrySubDiv"/>
                                                                                                        <xsl:with-param name="crPtyAddrDistrict" select="ns12:crPtyAddrDistrict"/>
                                                                                                        <xsl:with-param name="crPtyAddrCountrySubDiv" select="ns12:crPtyAddrCountrySubDiv"/>
                                                                                                        <xsl:with-param name="crPtyCountry" select="ns12:crPtyCountry"/>
                                                                                                        <xsl:with-param name="crPtyAddressLine1" select="ns12:crPtyAddressLine1"/>
                                                                                                        <xsl:with-param name="crPtyAddressLine2" select="ns12:crPtyAddressLine2"/>
                                                                                                    </xsl:call-template>
                                                                                                </xsl:for-each>
                                                                                            </xsl:when>
                                                                                            <xsl:when test="$RespDataIntinAgt3 = 'Agent - Intermediary agent 3'">
                                                                                                <xsl:variable name="agentRoleValue">
                                                                                                    <xsl:call-template name="getAgentRole">
                                                                                                        <xsl:with-param name="agentName" select="$RespDataIntinAgt3"/>
                                                                                                    </xsl:call-template>
                                                                                                </xsl:variable>
                                                                                                <xsl:variable name="agentRoleValueBeforeD">
                                                                                                    <xsl:value-of select="substring-before($agentRoleValue,'$')"/>
                                                                                                </xsl:variable>
                                                                                                <xsl:variable name="agentRoleValueAfterD">
                                                                                                    <xsl:value-of select="substring-after($agentRoleValue,'$')"/>
                                                                                                </xsl:variable>
                                                                                                <xsl:for-each select="/ns18:doOutwardMappingForCR/ns18:ipartycredit[ns12:crPtyRole = $agentRoleValueBeforeD and ns12:crPtyRoleIndicator = $agentRoleValueAfterD]">
                                                                                                    <xsl:call-template name="mapCreditPartyDetails">
                                                                                                        <xsl:with-param name="crPtyIdentifierCode" select="ns12:crPtyIdentifierCode"/>
                                                                                                        <xsl:with-param name="crPtyClearingMemberId" select="ns12:crPtyClearingMemberId"/>
                                                                                                        <xsl:with-param name="crPtyClearingSystemIdCode" select="ns12:crPtyClearingSystemIdCode"/>
                                                                                                        <xsl:with-param name="crPtyLei" select="ns12:crPtyLei"/>
                                                                                                        <xsl:with-param name="crPtyName" select="ns12:crPtyName"/>
                                                                                                        <xsl:with-param name="crPtyAddrDept" select="ns12:crPtyAddrDept"/>
                                                                                                        <xsl:with-param name="crPtyAddrSubdept" select="ns12:crPtyAddrSubdept"/>
                                                                                                        <xsl:with-param name="crPtyAddrStreetName" select="ns12:crPtyAddrStreetName"/>
                                                                                                        <xsl:with-param name="crPtyAddrBldgNo" select="ns12:crPtyAddrBldgNo"/>
                                                                                                        <xsl:with-param name="crPtyAddrBldgName" select="ns12:crPtyAddrBldgName"/>
                                                                                                        <xsl:with-param name="crPtyAddrBldgFloor" select="ns12:crPtyAddrBldgFloor"/>
                                                                                                        <xsl:with-param name="crPtyAddrPostBox" select="ns12:crPtyAddrBldgFloor"/>
                                                                                                        <xsl:with-param name="crPtyAddrRoom" select="ns12:crPtyAddrPostCode"/>
                                                                                                        <xsl:with-param name="crPtyAddrPostCode" select="ns12:crPtyAddrTownName"/>
                                                                                                        <xsl:with-param name="crPtyAddrTownName" select="ns12:crPtyAddrTownLocation"/>
                                                                                                        <xsl:with-param name="crPtyAddrTownLocation" select="ns12:crPtyAddrCountrySubDiv"/>
                                                                                                        <xsl:with-param name="crPtyAddrDistrict" select="ns12:crPtyAddrDistrict"/>
                                                                                                        <xsl:with-param name="crPtyAddrCountrySubDiv" select="ns12:crPtyAddrCountrySubDiv"/>
                                                                                                        <xsl:with-param name="crPtyCountry" select="ns12:crPtyCountry"/>
                                                                                                        <xsl:with-param name="crPtyAddressLine1" select="ns12:crPtyAddressLine1"/>
                                                                                                        <xsl:with-param name="crPtyAddressLine2" select="ns12:crPtyAddressLine2"/>
                                                                                                    </xsl:call-template>
                                                                                                </xsl:for-each>
                                                                                            </xsl:when>
                                                                                            <xsl:when test="$RespDataDebtorAgt = 'Agent - Debtor agent'">
                                                                                                <xsl:variable name="agentRoleValue">
                                                                                                    <xsl:call-template name="getAgentRole">
                                                                                                        <xsl:with-param name="agentName" select="$RespDataDebtorAgt"/>
                                                                                                    </xsl:call-template>
                                                                                                </xsl:variable>
                                                                                                <xsl:variable name="agentRoleValueBeforeD">
                                                                                                    <xsl:value-of select="substring-before($agentRoleValue,'$')"/>
                                                                                                </xsl:variable>
                                                                                                <xsl:variable name="agentRoleValueAfterD">
                                                                                                    <xsl:value-of select="substring-after($agentRoleValue,'$')"/>
                                                                                                </xsl:variable>
                                                                                                <xsl:for-each select="/ns18:doOutwardMappingForCR/ns18:ipartydebit[ns13:dbPtyRole = $agentRoleValueBeforeD and ns13:dbPtyRoleIndicator = $agentRoleValueAfterD]">
                                                                                                    <xsl:call-template name="mapDebitPartyDetailsAgt">
                                                                                                        <xsl:with-param name="dbPtyIdentifierCode" select="ns13:dbPtyIdentifierCode"/>
                                                                                                        <xsl:with-param name="dbPtyClearingMemberId" select="ns13:dbPtyClearingMemberId"/>
                                                                                                        <xsl:with-param name="dbPtyClearingSystemIdCode" select="ns13:dbPtyClearingSystemIdCode"/>
                                                                                                        <xsl:with-param name="dbPtyLei" select="ns13:dbPtyLei"/>
                                                                                                        <xsl:with-param name="dbPtyName" select="ns13:dbPtyName"/>
                                                                                                        <xsl:with-param name="dbPtyAddrDept" select="ns13:dbPtyAddrDept"/>
                                                                                                        <xsl:with-param name="dbPtyAddrSubdept" select="ns13:dbPtyAddrSubdept"/>
                                                                                                        <xsl:with-param name="dbPtyAddrStreetName" select="ns13:dbPtyAddrStreetName"/>
                                                                                                        <xsl:with-param name="dbPtyAddrBldgNo" select="ns13:dbPtyAddrBldgNo"/>
                                                                                                        <xsl:with-param name="dbPtyAddrBldgName" select="ns13:dbPtyAddrBldgName"/>
                                                                                                        <xsl:with-param name="dbPtyAddrBldgFloor" select="ns13:dbPtyAddrBldgFloor"/>
                                                                                                        <xsl:with-param name="dbPtyAddrPostBox" select="ns13:dbPtyAddrPostBox"/>
                                                                                                        <xsl:with-param name="dbPtyAddrRoom" select="ns13:dbPtyAddrRoom"/>
                                                                                                        <xsl:with-param name="dbPtyAddrPostCode" select="ns13:dbPtyAddrPostCode"/>
                                                                                                        <xsl:with-param name="dbPtyAddrTownName" select="ns13:dbPtyAddrTownName"/>
                                                                                                        <xsl:with-param name="dbPtyAddrTownLocation" select="ns13:dbPtyAddrTownLocation"/>
                                                                                                        <xsl:with-param name="dbPtyAddrDistrict" select="ns13:dbPtyAddrDistrict"/>
                                                                                                        <xsl:with-param name="dbPtyAddrCountrySubDiv" select="ns13:dbPtyAddrCountrySubDiv"/>
                                                                                                        <xsl:with-param name="dbPtyCountry" select="ns13:dbPtyCountry"/>
                                                                                                        <xsl:with-param name="dbPtyAddressLine1" select="ns13:dbPtyAddressLine1"/>
                                                                                                        <xsl:with-param name="dbPtyAddressLine2" select="ns13:dbPtyAddressLine2"/>
                                                                                                    </xsl:call-template>
                                                                                                </xsl:for-each>
                                                                                            </xsl:when>
                                                                                            <xsl:when test="$RespDataPrevAgt1 = 'Agent - Previous instructing agent 1'">
                                                                                                <xsl:variable name="agentRoleValue">
                                                                                                    <xsl:call-template name="getAgentRole">
                                                                                                        <xsl:with-param name="agentName" select="$RespDataPrevAgt1"/>
                                                                                                    </xsl:call-template>
                                                                                                </xsl:variable>
                                                                                                <xsl:variable name="agentRoleValueBeforeD">
                                                                                                    <xsl:value-of select="substring-before($agentRoleValue,'$')"/>
                                                                                                </xsl:variable>
                                                                                                <xsl:variable name="agentRoleValueAfterD">
                                                                                                    <xsl:value-of select="substring-after($agentRoleValue,'$')"/>
                                                                                                </xsl:variable>
                                                                                                <xsl:for-each select="/ns18:doOutwardMappingForCR/ns18:ipartydebit[ns13:dbPtyRole = $agentRoleValueBeforeD and ns13:dbPtyRoleIndicator = $agentRoleValueAfterD]">
                                                                                                    <xsl:call-template name="mapDebitPartyDetails">
                                                                                                        <xsl:with-param name="dbPtyName" select="ns13:dbPtyName"/>
                                                                                                        <xsl:with-param name="dbPtyAddrTownName" select="ns13:dbPtyAddrTownName"/>
                                                                                                        <xsl:with-param name="dbPtyAddrDept" select="ns13:dbPtyAddrDept"/>
                                                                                                        <xsl:with-param name="dbPtyAddrSubdept" select="ns13:dbPtyAddrSubdept"/>
                                                                                                        <xsl:with-param name="dbPtyCountry" select="ns13:dbPtyCountry"/>
                                                                                                        <xsl:with-param name="dbPtyAddrStreetName" select="ns13:dbPtyAddrStreetName"/>
                                                                                                        <xsl:with-param name="dbPtyAddrBldgNo" select="ns13:dbPtyAddrBldgNo"/>
                                                                                                        <xsl:with-param name="dbPtyAddrBldgName" select="ns13:dbPtyAddrBldgName"/>
                                                                                                        <xsl:with-param name="dbPtyAddrBldgFloor" select="ns13:dbPtyAddrBldgFloor"/>
                                                                                                        <xsl:with-param name="dbPtyAddrPostBox" select="ns13:dbPtyAddrPostBox"/>
                                                                                                        <xsl:with-param name="dbPtyAddrRoom" select="ns13:dbPtyAddrRoom"/>
                                                                                                        <xsl:with-param name="dbPtyAddrPostCode" select="ns13:dbPtyAddrPostCode"/>
                                                                                                        <xsl:with-param name="dbPtyAddrCountrySubDiv" select="ns13:dbPtyAddrCountrySubDiv"/>
                                                                                                        <xsl:with-param name="dbPtyAddrDistrict" select="ns13:dbPtyAddrDistrict"/>
                                                                                                        <xsl:with-param name="dbPtyAddrTownLocation" select="ns13:dbPtyAddrTownLocation"/>
                                                                                                        <xsl:with-param name="dbPtyAddressLine1" select="ns13:dbPtyAddressLine1"/>
                                                                                                        <xsl:with-param name="dbPtyAddressLine2" select="ns13:dbPtyAddressLine2"/>
                                                                                                    </xsl:call-template>
                                                                                                </xsl:for-each>
                                                                                            </xsl:when>
                                                                                            <xsl:when test="$RespDataPrevAgt2 = 'Agent - Previous instructing agent 2'">
                                                                                                <xsl:variable name="agentRoleValue">
                                                                                                    <xsl:call-template name="getAgentRole">
                                                                                                        <xsl:with-param name="agentName" select="$RespDataPrevAgt2"/>
                                                                                                    </xsl:call-template>
                                                                                                </xsl:variable>
                                                                                                <xsl:variable name="agentRoleValueBeforeD">
                                                                                                    <xsl:value-of select="substring-before($agentRoleValue,'$')"/>
                                                                                                </xsl:variable>
                                                                                                <xsl:variable name="agentRoleValueAfterD">
                                                                                                    <xsl:value-of select="substring-after($agentRoleValue,'$')"/>
                                                                                                </xsl:variable>
                                                                                                <xsl:for-each select="/ns18:doOutwardMappingForCR/ns18:ipartydebit[ns13:dbPtyRole = $agentRoleValueBeforeD and ns13:dbPtyRoleIndicator = $agentRoleValueAfterD]">
                                                                                                    <xsl:call-template name="mapDebitPartyDetails">
                                                                                                        <xsl:with-param name="dbPtyName" select="ns13:dbPtyName"/>
                                                                                                        <xsl:with-param name="dbPtyAddrTownName" select="ns13:dbPtyAddrTownName"/>
                                                                                                        <xsl:with-param name="dbPtyAddrDept" select="ns13:dbPtyAddrDept"/>
                                                                                                        <xsl:with-param name="dbPtyAddrSubdept" select="ns13:dbPtyAddrSubdept"/>
                                                                                                        <xsl:with-param name="dbPtyCountry" select="ns13:dbPtyCountry"/>
                                                                                                        <xsl:with-param name="dbPtyAddrStreetName" select="ns13:dbPtyAddrStreetName"/>
                                                                                                        <xsl:with-param name="dbPtyAddrBldgNo" select="ns13:dbPtyAddrBldgNo"/>
                                                                                                        <xsl:with-param name="dbPtyAddrBldgName" select="ns13:dbPtyAddrBldgName"/>
                                                                                                        <xsl:with-param name="dbPtyAddrBldgFloor" select="ns13:dbPtyAddrBldgFloor"/>
                                                                                                        <xsl:with-param name="dbPtyAddrPostBox" select="ns13:dbPtyAddrPostBox"/>
                                                                                                        <xsl:with-param name="dbPtyAddrRoom" select="ns13:dbPtyAddrRoom"/>
                                                                                                        <xsl:with-param name="dbPtyAddrPostCode" select="ns13:dbPtyAddrPostCode"/>
                                                                                                        <xsl:with-param name="dbPtyAddrCountrySubDiv" select="ns13:dbPtyAddrCountrySubDiv"/>
                                                                                                        <xsl:with-param name="dbPtyAddrDistrict" select="ns13:dbPtyAddrDistrict"/>
                                                                                                        <xsl:with-param name="dbPtyAddrTownLocation" select="ns13:dbPtyAddrTownLocation"/>
                                                                                                        <xsl:with-param name="dbPtyAddressLine1" select="ns13:dbPtyAddressLine1"/>
                                                                                                        <xsl:with-param name="dbPtyAddressLine2" select="ns13:dbPtyAddressLine2"/>
                                                                                                    </xsl:call-template>
                                                                                                </xsl:for-each>
                                                                                            </xsl:when>
                                                                                            <xsl:when test="$RespDataPrevAgt3 = 'Agent - Previous instructing agent 3'">
                                                                                                <xsl:variable name="agentRoleValue">
                                                                                                    <xsl:call-template name="getAgentRole">
                                                                                                        <xsl:with-param name="agentName" select="$RespDataPrevAgt3"/>
                                                                                                    </xsl:call-template>
                                                                                                </xsl:variable>
                                                                                                <xsl:variable name="agentRoleValueBeforeD">
                                                                                                    <xsl:value-of select="substring-before($agentRoleValue,'$')"/>
                                                                                                </xsl:variable>
                                                                                                <xsl:variable name="agentRoleValueAfterD">
                                                                                                    <xsl:value-of select="substring-after($agentRoleValue,'$')"/>
                                                                                                </xsl:variable>
                                                                                                <xsl:for-each select="/ns18:doOutwardMappingForCR/ns18:ipartydebit[ns13:dbPtyRole = $agentRoleValueBeforeD and ns13:dbPtyRoleIndicator = $agentRoleValueAfterD]">
                                                                                                    <xsl:call-template name="mapDebitPartyDetails">
                                                                                                        <xsl:with-param name="dbPtyName" select="ns13:dbPtyName"/>
                                                                                                        <xsl:with-param name="dbPtyAddrTownName" select="ns13:dbPtyAddrTownName"/>
                                                                                                        <xsl:with-param name="dbPtyAddrDept" select="ns13:dbPtyAddrDept"/>
                                                                                                        <xsl:with-param name="dbPtyAddrSubdept" select="ns13:dbPtyAddrSubdept"/>
                                                                                                        <xsl:with-param name="dbPtyCountry" select="ns13:dbPtyCountry"/>
                                                                                                        <xsl:with-param name="dbPtyAddrStreetName" select="ns13:dbPtyAddrStreetName"/>
                                                                                                        <xsl:with-param name="dbPtyAddrBldgNo" select="ns13:dbPtyAddrBldgNo"/>
                                                                                                        <xsl:with-param name="dbPtyAddrBldgName" select="ns13:dbPtyAddrBldgName"/>
                                                                                                        <xsl:with-param name="dbPtyAddrBldgFloor" select="ns13:dbPtyAddrBldgFloor"/>
                                                                                                        <xsl:with-param name="dbPtyAddrPostBox" select="ns13:dbPtyAddrPostBox"/>
                                                                                                        <xsl:with-param name="dbPtyAddrRoom" select="ns13:dbPtyAddrRoom"/>
                                                                                                        <xsl:with-param name="dbPtyAddrPostCode" select="ns13:dbPtyAddrPostCode"/>
                                                                                                        <xsl:with-param name="dbPtyAddrCountrySubDiv" select="ns13:dbPtyAddrCountrySubDiv"/>
                                                                                                        <xsl:with-param name="dbPtyAddrDistrict" select="ns13:dbPtyAddrDistrict"/>
                                                                                                        <xsl:with-param name="dbPtyAddrTownLocation" select="ns13:dbPtyAddrTownLocation"/>
                                                                                                        <xsl:with-param name="dbPtyAddressLine1" select="ns13:dbPtyAddressLine1"/>
                                                                                                        <xsl:with-param name="dbPtyAddressLine2" select="ns13:dbPtyAddressLine2"/>
                                                                                                    </xsl:call-template>
                                                                                                </xsl:for-each>
                                                                                            </xsl:when>
                                                                                        </xsl:choose>
                                                                                    </xsl:otherwise>
                                                                                </xsl:choose>
                                                                            </xsl:when>
                                                                            <xsl:when test="$contextAmountCurrency != '' and $contextAmount != ''">
                                                                                <Amt>
                                                                                    <xsl:attribute name="Ccy" namespace="">
                                                                                        <xsl:value-of select="$contextAmountCurrency"/>
                                                                                    </xsl:attribute>
                                                                                    <xsl:value-of select="$contextAmount"/>
                                                                                </Amt>
                                                                            </xsl:when>
                                                                            <xsl:when test="$contextAnyBic != ''">
                                                                                <AnyBIC>
                                                                                    <xsl:value-of select="$contextAnyBic"/>
                                                                                </AnyBIC>
                                                                            </xsl:when>
                                                                            <xsl:when test="$contextBICFI != ''">
                                                                                <BICFI>
                                                                                    <xsl:value-of select="$contextBICFI"/>
                                                                                </BICFI>
                                                                            </xsl:when>
                                                                            <xsl:when test="$contextCashAcctIBAN != '' or $contextCashAcctOthrId != '' or $contextCashAcctSchmNmCode != '' or $contextCashAcctSchmNmProp != '' or $contextCashAcctIdIssuer != '' or $contextCashAcctProxyId != '' or $contextCashAcctProxyTypeProp != '' or $contextCashAcctProxyTypeCode != '' or $contextCashAcctName != '' or $contextCashAcctCurrency != '' or $contextCashAcctTypeProp != '' or $contextCashAcctTypeCode != ''">
                                                                                <CshAcct>
                                                                                    <xsl:if test="$contextCashAcctIBAN != '' or $contextCashAcctOthrId != '' or $contextCashAcctSchmNmCode != '' or $contextCashAcctSchmNmProp != '' or $contextCashAcctIdIssuer != ''">
                                                                                        <Id>
                                                                                            <xsl:choose>
                                                                                                <xsl:when test="$contextCashAcctIBAN != ''">
                                                                                                    <IBAN>
                                                                                                        <xsl:value-of select="$contextCashAcctIBAN"/>
                                                                                                    </IBAN>
                                                                                                </xsl:when>
                                                                                                <xsl:otherwise>
                                                                                                    <xsl:if test="$contextCashAcctOthrId != '' or $contextCashAcctSchmNmCode != '' or $contextCashAcctSchmNmProp != '' or $contextCashAcctIdIssuer != ''">
                                                                                                        <Othr>
                                                                                                            <xsl:if test="$contextCashAcctOthrId != ''">
                                                                                                                <Id>
                                                                                                                    <xsl:value-of select="$contextCashAcctOthrId"/>
                                                                                                                </Id>
                                                                                                            </xsl:if>
                                                                                                            <xsl:if test="$contextCashAcctSchmNmCode != '' or $contextCashAcctSchmNmProp != ''">
                                                                                                                <SchmeNm>
                                                                                                                    <xsl:choose>
                                                                                                                        <xsl:when test="$contextCashAcctSchmNmCode != ''">
                                                                                                                            <Cd>
                                                                                                                                <xsl:value-of select="$contextCashAcctSchmNmCode"/>
                                                                                                                            </Cd>
                                                                                                                        </xsl:when>
                                                                                                                        <xsl:otherwise>
                                                                                                                            <xsl:if test="$contextCashAcctSchmNmProp != ''">
                                                                                                                                <Prtry>
                                                                                                                                    <xsl:value-of select="$contextCashAcctSchmNmProp"/>
                                                                                                                                </Prtry>
                                                                                                                            </xsl:if>
                                                                                                                        </xsl:otherwise>
                                                                                                                    </xsl:choose>
                                                                                                                </SchmeNm>
                                                                                                            </xsl:if>
                                                                                                            <xsl:if test="$contextCashAcctIdIssuer != ''">
                                                                                                                <Issr>
                                                                                                                    <xsl:value-of select="$contextCashAcctIdIssuer"/>
                                                                                                                </Issr>
                                                                                                            </xsl:if>
                                                                                                        </Othr>
                                                                                                    </xsl:if>
                                                                                                </xsl:otherwise>
                                                                                            </xsl:choose>
                                                                                        </Id>
                                                                                    </xsl:if>
                                                                                    <xsl:if test="$contextCashAcctTypeCode != '' or $contextCashAcctTypeProp != ''">
                                                                                        <Tp>
                                                                                            <xsl:choose>
                                                                                                <xsl:when test="$contextCashAcctTypeCode != ''">
                                                                                                    <Cd>
                                                                                                        <xsl:value-of select="$contextCashAcctTypeCode"/>
                                                                                                    </Cd>
                                                                                                </xsl:when>
                                                                                                <xsl:otherwise>
                                                                                                    <xsl:if test="$contextCashAcctTypeProp != ''">
                                                                                                        <Prtry>
                                                                                                            <xsl:value-of select="$contextCashAcctTypeProp"/>
                                                                                                        </Prtry>
                                                                                                    </xsl:if>
                                                                                                </xsl:otherwise>
                                                                                            </xsl:choose>
                                                                                        </Tp>
                                                                                    </xsl:if>
                                                                                    <xsl:if test="$contextCashAcctCurrency != ''">
                                                                                        <Ccy>
                                                                                            <xsl:value-of select="$contextCashAcctCurrency"/>
                                                                                        </Ccy>
                                                                                    </xsl:if>
                                                                                    <xsl:if test="$contextCashAcctName != ''">
                                                                                        <Nm>
                                                                                            <xsl:value-of select="$contextCashAcctName"/>
                                                                                        </Nm>
                                                                                    </xsl:if>
                                                                                    <xsl:if test="$contextCashAcctProxyTypeCode != '' or $contextCashAcctProxyTypeProp != '' or $contextCashAcctProxyId != ''">
                                                                                        <Prxy>
                                                                                            <xsl:if test="$contextCashAcctProxyTypeCode != '' or $contextCashAcctProxyTypeProp != ''">
                                                                                                <Tp>
                                                                                                    <xsl:if test="$contextCashAcctProxyTypeCode != ''">
                                                                                                        <Cd>
                                                                                                            <xsl:value-of select="$contextCashAcctProxyTypeCode"/>
                                                                                                        </Cd>
                                                                                                    </xsl:if>
                                                                                                    <xsl:if test="$contextCashAcctProxyTypeProp != ''">
                                                                                                        <Prtry>
                                                                                                            <xsl:value-of select="$contextCashAcctProxyTypeProp"/>
                                                                                                        </Prtry>
                                                                                                    </xsl:if>
                                                                                                </Tp>
                                                                                            </xsl:if>
                                                                                            <xsl:if test="$contextCashAcctProxyId != ''">
                                                                                                <Id>
                                                                                                    <xsl:value-of select="$contextCashAcctProxyId"/>
                                                                                                </Id>
                                                                                            </xsl:if>
                                                                                        </Prxy>
                                                                                    </xsl:if>
                                                                                </CshAcct>
                                                                            </xsl:when>
                                                                            <xsl:when test="$contextCode != ''">
                                                                                <Cd>
                                                                                    <xsl:value-of select="$contextCode"/>
                                                                                </Cd>
                                                                            </xsl:when>
                                                                            <xsl:when test="$contextDate != ''">
                                                                                <Dt>
                                                                                    <xsl:value-of select="concat(substring(string($contextDate),'1','4'),'-',substring(string($contextDate),'5','2'),'-',substring(string($contextDate),'7','2'))"/>
                                                                                </Dt>
                                                                            </xsl:when>
                                                                            <xsl:when test="$contextDateTime != ''">
                                                                                <DtTm>
                                                                                    <xsl:value-of select="concat(substring(string($contextDateTime), '1', '4'), '-', substring(string($contextDateTime), '5', '2'), '-', substring(string($contextDateTime), '7', '2'), 'T', substring(string($contextDateTime), '9', '2'), ':', substring(string($contextDateTime), '11', '2'), ':', substring(string($contextDateTime), '13', '2'), substring(string($contextDateTime), '18', '23'))"/>
                                                                                </DtTm>
                                                                            </xsl:when>
                                                                            <xsl:when test="$RespDataUltDbtPty != '' or $RespDataDebtorPty != '' or $RespDataInitPty != '' or $RespDataCreditorPty != '' or $RespDataUltCdtPty != ''">
                                                                                <xsl:choose>
                                                                                    <xsl:when test="$RespDataUltDbtPty = 'Party - Ultimate Debtor'">
                                                                                        <xsl:variable name="agentRoleValue">
                                                                                            <xsl:call-template name="getAgentRole">
                                                                                                <xsl:with-param name="agentName" select="$RespDataUltDbtPty"/>
                                                                                            </xsl:call-template>
                                                                                        </xsl:variable>
                                                                                        <xsl:variable name="agentRoleValueBeforeD">
                                                                                            <xsl:value-of select="substring-before($agentRoleValue,'$')"/>
                                                                                        </xsl:variable>
                                                                                        <xsl:variable name="agentRoleValueAfterD">
                                                                                            <xsl:value-of select="substring-after($agentRoleValue,'$')"/>
                                                                                        </xsl:variable>
                                                                                        <xsl:for-each select="/ns18:doOutwardMappingForCR/ns18:ipartydebit[ns13:dbPtyRole = $agentRoleValueBeforeD and ns13:dbPtyRoleIndicator = $agentRoleValueAfterD]">
                                                                                            <xsl:call-template name="mapDebitPartyDetails">
                                                                                                <xsl:with-param name="dbPtyName" select="ns13:dbPtyName"/>
                                                                                                <xsl:with-param name="dbPtyAddrTownName" select="ns13:dbPtyAddrTownName"/>
                                                                                                <xsl:with-param name="dbPtyAddrDept" select="ns13:dbPtyAddrDept"/>
                                                                                                <xsl:with-param name="dbPtyAddrSubdept" select="ns13:dbPtyAddrSubdept"/>
                                                                                                <xsl:with-param name="dbPtyCountry" select="ns13:dbPtyCountry"/>
                                                                                                <xsl:with-param name="dbPtyAddrStreetName" select="ns13:dbPtyAddrStreetName"/>
                                                                                                <xsl:with-param name="dbPtyAddrBldgNo" select="ns13:dbPtyAddrBldgNo"/>
                                                                                                <xsl:with-param name="dbPtyAddrBldgName" select="ns13:dbPtyAddrBldgName"/>
                                                                                                <xsl:with-param name="dbPtyAddrBldgFloor" select="ns13:dbPtyAddrBldgFloor"/>
                                                                                                <xsl:with-param name="dbPtyAddrPostBox" select="ns13:dbPtyAddrPostBox"/>
                                                                                                <xsl:with-param name="dbPtyAddrRoom" select="ns13:dbPtyAddrRoom"/>
                                                                                                <xsl:with-param name="dbPtyAddrPostCode" select="ns13:dbPtyAddrPostCode"/>
                                                                                                <xsl:with-param name="dbPtyAddrCountrySubDiv" select="ns13:dbPtyAddrCountrySubDiv"/>
                                                                                                <xsl:with-param name="dbPtyAddrDistrict" select="ns13:dbPtyAddrDistrict"/>
                                                                                                <xsl:with-param name="dbPtyAddrTownLocation" select="ns13:dbPtyAddrTownLocation"/>
                                                                                                <xsl:with-param name="dbPtyAddressLine1" select="ns13:dbPtyAddressLine1"/>
                                                                                                <xsl:with-param name="dbPtyAddressLine2" select="ns13:dbPtyAddressLine2"/>
                                                                                            </xsl:call-template>
                                                                                        </xsl:for-each>
                                                                                    </xsl:when>
                                                                                    <xsl:when test="$RespDataDebtorPty = 'Party - Debtor'">
                                                                                        <xsl:variable name="agentRoleValue">
                                                                                            <xsl:call-template name="getAgentRole">
                                                                                                <xsl:with-param name="agentName" select="$RespDataDebtorPty"/>
                                                                                            </xsl:call-template>
                                                                                        </xsl:variable>
                                                                                        <xsl:variable name="agentRoleValueBeforeD">
                                                                                            <xsl:value-of select="substring-before($agentRoleValue,'$')"/>
                                                                                        </xsl:variable>
                                                                                        <xsl:variable name="agentRoleValueAfterD">
                                                                                            <xsl:value-of select="substring-after($agentRoleValue,'$')"/>
                                                                                        </xsl:variable>
                                                                                        <xsl:for-each select="/ns18:doOutwardMappingForCR/ns18:ipartydebit[ns13:dbPtyRole = $agentRoleValueBeforeD and ns13:dbPtyRoleIndicator = $agentRoleValueAfterD]">
                                                                                            <xsl:call-template name="mapDebitPartyDetails">
                                                                                                <xsl:with-param name="dbPtyName" select="ns13:dbPtyName"/>
                                                                                                <xsl:with-param name="dbPtyAddrTownName" select="ns13:dbPtyAddrTownName"/>
                                                                                                <xsl:with-param name="dbPtyAddrDept" select="ns13:dbPtyAddrDept"/>
                                                                                                <xsl:with-param name="dbPtyAddrSubdept" select="ns13:dbPtyAddrSubdept"/>
                                                                                                <xsl:with-param name="dbPtyCountry" select="ns13:dbPtyCountry"/>
                                                                                                <xsl:with-param name="dbPtyAddrStreetName" select="ns13:dbPtyAddrStreetName"/>
                                                                                                <xsl:with-param name="dbPtyAddrBldgNo" select="ns13:dbPtyAddrBldgNo"/>
                                                                                                <xsl:with-param name="dbPtyAddrBldgName" select="ns13:dbPtyAddrBldgName"/>
                                                                                                <xsl:with-param name="dbPtyAddrBldgFloor" select="ns13:dbPtyAddrBldgFloor"/>
                                                                                                <xsl:with-param name="dbPtyAddrPostBox" select="ns13:dbPtyAddrPostBox"/>
                                                                                                <xsl:with-param name="dbPtyAddrRoom" select="ns13:dbPtyAddrRoom"/>
                                                                                                <xsl:with-param name="dbPtyAddrPostCode" select="ns13:dbPtyAddrPostCode"/>
                                                                                                <xsl:with-param name="dbPtyAddrCountrySubDiv" select="ns13:dbPtyAddrCountrySubDiv"/>
                                                                                                <xsl:with-param name="dbPtyAddrDistrict" select="ns13:dbPtyAddrDistrict"/>
                                                                                                <xsl:with-param name="dbPtyAddrTownLocation" select="ns13:dbPtyAddrTownLocation"/>
                                                                                                <xsl:with-param name="dbPtyAddressLine1" select="ns13:dbPtyAddressLine1"/>
                                                                                                <xsl:with-param name="dbPtyAddressLine2" select="ns13:dbPtyAddressLine2"/>
                                                                                            </xsl:call-template>
                                                                                        </xsl:for-each>
                                                                                    </xsl:when>
                                                                                    <xsl:when test="$RespDataInitPty = 'Party - Initiating Party'">
                                                                                        <xsl:variable name="agentRoleValue">
                                                                                            <xsl:call-template name="getAgentRole">
                                                                                                <xsl:with-param name="agentName" select="$RespDataInitPty"/>
                                                                                            </xsl:call-template>
                                                                                        </xsl:variable>
                                                                                        <xsl:variable name="agentRoleValueBeforeD">
                                                                                            <xsl:value-of select="substring-before($agentRoleValue,'$')"/>
                                                                                        </xsl:variable>
                                                                                        <xsl:variable name="agentRoleValueAfterD">
                                                                                            <xsl:value-of select="substring-after($agentRoleValue,'$')"/>
                                                                                        </xsl:variable>
                                                                                        <xsl:for-each select="/ns18:doOutwardMappingForCR/ns18:ipartydebit[ns13:dbPtyRole = $agentRoleValueBeforeD and ns13:dbPtyRoleIndicator = $agentRoleValueAfterD]">
                                                                                            <xsl:call-template name="mapDebitPartyDetails">
                                                                                                <xsl:with-param name="dbPtyName" select="ns13:dbPtyName"/>
                                                                                                <xsl:with-param name="dbPtyAddrTownName" select="ns13:dbPtyAddrTownName"/>
                                                                                                <xsl:with-param name="dbPtyAddrDept" select="ns13:dbPtyAddrDept"/>
                                                                                                <xsl:with-param name="dbPtyAddrSubdept" select="ns13:dbPtyAddrSubdept"/>
                                                                                                <xsl:with-param name="dbPtyCountry" select="ns13:dbPtyCountry"/>
                                                                                                <xsl:with-param name="dbPtyAddrStreetName" select="ns13:dbPtyAddrStreetName"/>
                                                                                                <xsl:with-param name="dbPtyAddrBldgNo" select="ns13:dbPtyAddrBldgNo"/>
                                                                                                <xsl:with-param name="dbPtyAddrBldgName" select="ns13:dbPtyAddrBldgName"/>
                                                                                                <xsl:with-param name="dbPtyAddrBldgFloor" select="ns13:dbPtyAddrBldgFloor"/>
                                                                                                <xsl:with-param name="dbPtyAddrPostBox" select="ns13:dbPtyAddrPostBox"/>
                                                                                                <xsl:with-param name="dbPtyAddrRoom" select="ns13:dbPtyAddrRoom"/>
                                                                                                <xsl:with-param name="dbPtyAddrPostCode" select="ns13:dbPtyAddrPostCode"/>
                                                                                                <xsl:with-param name="dbPtyAddrCountrySubDiv" select="ns13:dbPtyAddrCountrySubDiv"/>
                                                                                                <xsl:with-param name="dbPtyAddrDistrict" select="ns13:dbPtyAddrDistrict"/>
                                                                                                <xsl:with-param name="dbPtyAddrTownLocation" select="ns13:dbPtyAddrTownLocation"/>
                                                                                                <xsl:with-param name="dbPtyAddressLine1" select="ns13:dbPtyAddressLine1"/>
                                                                                                <xsl:with-param name="dbPtyAddressLine2" select="ns13:dbPtyAddressLine2"/>
                                                                                            </xsl:call-template>
                                                                                        </xsl:for-each>
                                                                                    </xsl:when>
                                                                                    <xsl:when test="$RespDataCreditorPty = 'Party - Creditor'">
                                                                                        <xsl:variable name="agentRoleValue">
                                                                                            <xsl:call-template name="getAgentRole">
                                                                                                <xsl:with-param name="agentName" select="$RespDataCreditorPty"/>
                                                                                            </xsl:call-template>
                                                                                        </xsl:variable>
                                                                                        <xsl:variable name="agentRoleValueBeforeD">
                                                                                            <xsl:value-of select="substring-before($agentRoleValue,'$')"/>
                                                                                        </xsl:variable>
                                                                                        <xsl:variable name="agentRoleValueAfterD">
                                                                                            <xsl:value-of select="substring-after($agentRoleValue,'$')"/>
                                                                                        </xsl:variable>
                                                                                        <xsl:for-each select="/ns18:doOutwardMappingForCR/ns18:ipartycredit[ns12:crPtyRole = $agentRoleValueBeforeD and ns12:crPtyRoleIndicator = $agentRoleValueAfterD]">
                                                                                            <xsl:call-template name="mapCreditPartyDetailsPty">
                                                                                                <xsl:with-param name="dbPtyName" select="ns12:crPtyName"/>
                                                                                                <xsl:with-param name="dbPtyAddrTownName" select="ns12:crPtyAddrTownName"/>
                                                                                                <xsl:with-param name="dbPtyAddrDept" select="ns12:crPtyAddrDept"/>
                                                                                                <xsl:with-param name="dbPtyAddrSubdept" select="ns12:crPtyAddrSubdept"/>
                                                                                                <xsl:with-param name="dbPtyCountry" select="ns12:crPtyCountry"/>
                                                                                                <xsl:with-param name="dbPtyAddrStreetName" select="ns12:crPtyAddrStreetName"/>
                                                                                                <xsl:with-param name="dbPtyAddrBldgNo" select="ns12:crPtyAddrBldgNo"/>
                                                                                                <xsl:with-param name="dbPtyAddrBldgName" select="ns12:crPtyAddrBldgName"/>
                                                                                                <xsl:with-param name="dbPtyAddrBldgFloor" select="ns12:crPtyAddrBldgFloor"/>
                                                                                                <xsl:with-param name="dbPtyAddrPostBox" select="ns12:crPtyAddrPostBox"/>
                                                                                                <xsl:with-param name="dbPtyAddrRoom" select="ns12:crPtyAddrRoom"/>
                                                                                                <xsl:with-param name="dbPtyAddrPostCode" select="ns12:crPtyAddrPostCode"/>
                                                                                                <xsl:with-param name="dbPtyAddrCountrySubDiv" select="ns12:crPtyAddrCountrySubDiv"/>
                                                                                                <xsl:with-param name="dbPtyAddrDistrict" select="ns12:crPtyAddrDistrict"/>
                                                                                                <xsl:with-param name="dbPtyAddrTownLocation" select="ns12:crPtyAddrTownLocation"/>
                                                                                                <xsl:with-param name="dbPtyAddressLine1" select="ns12:crPtyAddressLine1"/>
                                                                                                <xsl:with-param name="dbPtyAddressLine2" select="ns12:crPtyAddressLine2"/>
                                                                                            </xsl:call-template>
                                                                                        </xsl:for-each>
                                                                                    </xsl:when>
                                                                                    <xsl:when test="$RespDataUltCdtPty = 'Party - Ultimate Creditor'">
                                                                                        <xsl:variable name="agentRoleValue">
                                                                                            <xsl:call-template name="getAgentRole">
                                                                                                <xsl:with-param name="agentName" select="$RespDataUltCdtPty"/>
                                                                                            </xsl:call-template>
                                                                                        </xsl:variable>
                                                                                        <xsl:variable name="agentRoleValueBeforeD">
                                                                                            <xsl:value-of select="substring-before($agentRoleValue,'$')"/>
                                                                                        </xsl:variable>
                                                                                        <xsl:variable name="agentRoleValueAfterD">
                                                                                            <xsl:value-of select="substring-after($agentRoleValue,'$')"/>
                                                                                        </xsl:variable>
                                                                                        <xsl:for-each select="/ns18:doOutwardMappingForCR/ns18:ipartycredit[ns12:crPtyRole = $agentRoleValueBeforeD and ns12:crPtyRoleIndicator = $agentRoleValueAfterD]">
                                                                                            <xsl:call-template name="mapCreditPartyDetailsPty">
                                                                                                <xsl:with-param name="dbPtyName" select="ns12:crPtyName"/>
                                                                                                <xsl:with-param name="dbPtyAddrTownName" select="ns12:crPtyAddrTownName"/>
                                                                                                <xsl:with-param name="dbPtyAddrDept" select="ns12:crPtyAddrDept"/>
                                                                                                <xsl:with-param name="dbPtyAddrSubdept" select="ns12:crPtyAddrSubdept"/>
                                                                                                <xsl:with-param name="dbPtyCountry" select="ns12:crPtyCountry"/>
                                                                                                <xsl:with-param name="dbPtyAddrStreetName" select="ns12:crPtyAddrStreetName"/>
                                                                                                <xsl:with-param name="dbPtyAddrBldgNo" select="ns12:crPtyAddrBldgNo"/>
                                                                                                <xsl:with-param name="dbPtyAddrBldgName" select="ns12:crPtyAddrBldgName"/>
                                                                                                <xsl:with-param name="dbPtyAddrBldgFloor" select="ns12:crPtyAddrBldgFloor"/>
                                                                                                <xsl:with-param name="dbPtyAddrPostBox" select="ns12:crPtyAddrPostBox"/>
                                                                                                <xsl:with-param name="dbPtyAddrRoom" select="ns12:crPtyAddrRoom"/>
                                                                                                <xsl:with-param name="dbPtyAddrPostCode" select="ns12:crPtyAddrPostCode"/>
                                                                                                <xsl:with-param name="dbPtyAddrCountrySubDiv" select="ns12:crPtyAddrCountrySubDiv"/>
                                                                                                <xsl:with-param name="dbPtyAddrDistrict" select="ns12:crPtyAddrDistrict"/>
                                                                                                <xsl:with-param name="dbPtyAddrTownLocation" select="ns12:crPtyAddrTownLocation"/>
                                                                                                <xsl:with-param name="dbPtyAddressLine1" select="ns12:crPtyAddressLine1"/>
                                                                                                <xsl:with-param name="dbPtyAddressLine2" select="ns12:crPtyAddressLine2"/>
                                                                                            </xsl:call-template>
                                                                                        </xsl:for-each>
                                                                                    </xsl:when>
                                                                                </xsl:choose>
                                                                            </xsl:when>
                                                                            <xsl:when test="$RespDataRemittance = 'Remittance'">
                                                                                <Rmt>
                                                                                    <xsl:choose>
                                                                                        <xsl:when test="$UnstrdRmtInf != '' ">
                                                                                            <Ustrd>
                                                                                                <xsl:value-of select="normalize-space(substring($UnstrdRmtInf ,'1','140'))"/>
                                                                                            </Ustrd>
                                                                                        </xsl:when>
                                                                                        <xsl:when test="$UnstrdRmtInf = '' and $StrdRmtInf != ''">
                                                                                            <xsl:value-of select="$StrdRmtInf"/>
                                                                                        </xsl:when>
                                                                                        <xsl:when test="$UnstrdRmtInf = '' and $StrdRmtInf = '' and ((/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:rfrDocInfTpCdOrPropCd) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:rfrDocInfNr) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:rfrDocAmCrNoteAm) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:adRmttInf1) or /ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:crdRefInfTpCdOrPropCd or /ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:crdRefInfTpCdOrPropProp or /ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:crdRefInfTpIssuer or /ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:crdRefInfRef or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:rfrDocAmRemittedAm) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:rfrDocAmCrNoteAmCcy) or(/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:rfrDocAmRemittedAmCcy))">
                                                                                            <xsl:if test=" (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:rfrDocInfTpCdOrPropCd) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:rfrDocInfNr) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:rfrDocAmCrNoteAm) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:adRmttInf1) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:adRmttInf2) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:adRmttInf3) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:rfrDocAmRemittedAm) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:crdRefInfTpCdOrPropCd) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:crdRefInfTpCdOrPropProp) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:crdRefInfTpIssuer) or (/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:crdRefInfRef) or /ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:crdRefInfTpCdOrPropCd or /ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:crdRefInfTpCdOrPropProp or /ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:crdRefInfTpIssuer or /ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo/ns16:crdRefInfRef">
                                                                                                <xsl:for-each select="/ns18:doOutwardMappingForCR/ns18:iextentedremittanceinfo">
                                                                                                    <Strd>
                                                                                                        <xsl:if test="(ns16:rfrDocInfTpCdOrPropCd) or (ns16:rfrDocInfNr) ">
                                                                                                            <xsl:variable name="refrdocCount">
                                                                                                                <xsl:choose>
                                                                                                                    <xsl:when test="ns16:rfrDocInfTpCdOrPropCd and ns16:rfrDocInfNr">
                                                                                                                        <xsl:if test="count(ns16:rfrDocInfTpCdOrPropCd) &gt; count(ns16:rfrDocInfNr)">
                                                                                                                            <xsl:value-of select="count(ns16:rfrDocInfTpCdOrPropCd)"/>
                                                                                                                        </xsl:if>
                                                                                                                        <xsl:if test="count(ns16:rfrDocInfTpCdOrPropCd) &lt; count(ns16:rfrDocInfNr)">
                                                                                                                            <xsl:value-of select="count(ns16:rfrDocInfNr)"/>
                                                                                                                        </xsl:if>
                                                                                                                        <xsl:if test="count(ns16:rfrDocInfTpCdOrPropCd) = count(ns16:rfrDocInfNr)">
                                                                                                                            <xsl:value-of select="count(ns16:rfrDocInfNr)"/>
                                                                                                                        </xsl:if>
                                                                                                                    </xsl:when>
                                                                                                                    <xsl:when test="ns16:rfrDocInfTpCdOrPropCd">
                                                                                                                        <xsl:value-of select="count(ns16:rfrDocInfTpCdOrPropCd)"/>
                                                                                                                    </xsl:when>
                                                                                                                    <xsl:when test="ns16:rfrDocInfNr">
                                                                                                                        <xsl:value-of select="count(ns16:rfrDocInfNr)"/>
                                                                                                                    </xsl:when>
                                                                                                                </xsl:choose>
                                                                                                            </xsl:variable>
                                                                                                            <xsl:if test="$refrdocCount &gt; 0">
                                                                                                                <xsl:call-template name="RfrdDocinf">
                                                                                                                    <xsl:with-param name="element" select="$refrdocCount"/>
                                                                                                                    <xsl:with-param name="count" select="1"/>
                                                                                                                </xsl:call-template>
                                                                                                            </xsl:if>
                                                                                                        </xsl:if>
                                                                                                        <xsl:if test="(ns16:rfrDocAmCrNoteAm) or (ns16:rfrDocAmRemittedAm) or (ns16:rfrDocAmDuePayableAm) or (ns16:rfrDocAmDiscApplAmAm) or (ns16:rfrDocAmTaxAmAm) or (ns16:rfrDocAmAdjAmRsnAm)">
                                                                                                            <RfrdDocAmt>
                                                                                                                <xsl:if test="ns16:rfrDocAmCrNoteAm">
                                                                                                                    <CdtNoteAmt>
                                                                                                                        <xsl:attribute name="Ccy" namespace="">
                                                                                                                            <xsl:value-of select="ns16:rfrDocAmCrNoteAmCcy"/>
                                                                                                                        </xsl:attribute>
                                                                                                                        <xsl:choose>
                                                                                                                            <xsl:when test="ns16:rfrDocAmCrNoteAmCcy = 'JPY' and contains(ns16:rfrDocAmCrNoteAm, '.') = 'TRUE'">
                                                                                                                                <xsl:value-of select="(substring-before(ns16:rfrDocAmCrNoteAm, '.'))"/>
                                                                                                                            </xsl:when>
                                                                                                                            <xsl:otherwise>
                                                                                                                                <xsl:value-of select="ns16:rfrDocAmCrNoteAm"/>
                                                                                                                            </xsl:otherwise>
                                                                                                                        </xsl:choose>
                                                                                                                    </CdtNoteAmt>
                                                                                                                </xsl:if>
                                                                                                                <xsl:if test="ns16:rfrDocAmRemittedAm">
                                                                                                                    <RmtdAmt>
                                                                                                                        <xsl:attribute name="Ccy" namespace="">
                                                                                                                            <xsl:value-of select="ns16:rfrDocAmRemittedAmCcy"/>
                                                                                                                        </xsl:attribute>
                                                                                                                        <xsl:choose>
                                                                                                                            <xsl:when test="ns16:rfrDocAmRemittedAmCcy = 'JPY' and contains(ns16:rfrDocAmRemittedAm, '.') = 'TRUE'">
                                                                                                                                <xsl:value-of select="(substring-before(ns16:rfrDocAmRemittedAm, '.'))"/>
                                                                                                                            </xsl:when>
                                                                                                                            <xsl:otherwise>
                                                                                                                                <xsl:value-of select="ns16:rfrDocAmRemittedAm"/>
                                                                                                                            </xsl:otherwise>
                                                                                                                        </xsl:choose>
                                                                                                                    </RmtdAmt>
                                                                                                                </xsl:if>
                                                                                                            </RfrdDocAmt>
                                                                                                        </xsl:if>
                                                                                                        <xsl:if test="(ns16:crdRefInfTpCdOrPropCd) or (ns16:crdRefInfTpCdOrPropProp) or (ns16:crdRefInfTpIssuer) or (ns16:crdRefInfRef) ">
                                                                                                            <CdtrRefInf>
                                                                                                                <xsl:if test="(ns16:crdRefInfTpCdOrPropCd) or (ns16:crdRefInfTpCdOrPropProp) ">
                                                                                                                    <Tp>
                                                                                                                        <xsl:if test="ns16:crdRefInfTpCdOrPropCd">
                                                                                                                            <CdOrPrtry>
                                                                                                                                <Cd>
                                                                                                                                    <xsl:value-of select="ns16:crdRefInfTpCdOrPropCd"/>
                                                                                                                                </Cd>
                                                                                                                            </CdOrPrtry>
                                                                                                                        </xsl:if>
                                                                                                                        <xsl:if test="ns16:crdRefInfTpCdOrPropProp">
                                                                                                                            <CdOrPrtry>
                                                                                                                                <Prtry>
                                                                                                                                    <xsl:value-of select="substring(string(ns16:crdRefInfTpCdOrPropProp), '1', '35')"/>
                                                                                                                                </Prtry>
                                                                                                                            </CdOrPrtry>
                                                                                                                        </xsl:if>
                                                                                                                        <xsl:if test="ns16:crdRefInfTpIssuer">
                                                                                                                            <Issr>
                                                                                                                                <xsl:value-of select="substring(string(ns16:crdRefInfTpIssuer), '1', '35')"/>
                                                                                                                            </Issr>
                                                                                                                        </xsl:if>
                                                                                                                    </Tp>
                                                                                                                </xsl:if>
                                                                                                                <xsl:if test="ns16:crdRefInfRef">
                                                                                                                    <Ref>
                                                                                                                        <xsl:value-of select="substring(string(ns16:crdRefInfRef), '1', '35')"/>
                                                                                                                    </Ref>
                                                                                                                </xsl:if>
                                                                                                            </CdtrRefInf>
                                                                                                        </xsl:if>
                                                                                                        <xsl:if test="ns16:adRmttInf1">
                                                                                                            <AddtlRmtInf>
                                                                                                                <xsl:value-of select="substring(string(ns16:adRmttInf1), '1', '140')"/>
                                                                                                            </AddtlRmtInf>
                                                                                                        </xsl:if>
                                                                                                        <xsl:if test="ns16:adRmttInf2">
                                                                                                            <AddtlRmtInf>
                                                                                                                <xsl:value-of select="substring(string(ns16:adRmttInf2), '1', '140')"/>
                                                                                                            </AddtlRmtInf>
                                                                                                        </xsl:if>
                                                                                                        <xsl:if test="ns16:adRmttInf3">
                                                                                                            <AddtlRmtInf>
                                                                                                                <xsl:value-of select="substring(string(ns16:adRmttInf3), '1', '140')"/>
                                                                                                            </AddtlRmtInf>
                                                                                                        </xsl:if>
                                                                                                    </Strd>
                                                                                                </xsl:for-each>
                                                                                            </xsl:if>
                                                                                        </xsl:when>
                                                                                        <xsl:otherwise>
                                                                                            <xsl:if test="$isRltdRemImfoPresent = 'TRUE' or $isRltdRemIdPrsnt = 'TRUE'">
                                                                                                <Rltd>
                                                                                                    <xsl:for-each select="/ns18:doOutwardMappingForCR/ns18:irelatedremittanceinfo[ns17:relRemInfoRemId or ns17:relRemInfRmtLocMthd or ns17:relRemInfRmtLocElectAddr or ns17:relRemInfRmtLocAddrName or ns17:relRemInfRmtLocAddrTownName or ns17:relRemInfRmtLocCountry]">
                                                                                                        <xsl:if test="string((position() = '1')) != 'false'">
                                                                                                            <xsl:if test="ns17:relRemInfoRemId">
                                                                                                                <RmtId>
                                                                                                                    <xsl:value-of select="substring(string(ns17:relRemInfoRemId), '1', '35')"/>
                                                                                                                </RmtId>
                                                                                                            </xsl:if>
                                                                                                        </xsl:if>
                                                                                                        <xsl:if test="string((position() = '1')) != 'false' or string((position() = '2')) != 'false'">
                                                                                                            <xsl:if test="ns17:relRemInfRmtLocMthd or ns17:relRemInfRmtLocElectAddr or ns17:relRemInfRmtLocAddrName or ns17:relRemInfRmtLocAddrTownName or ns17:relRemInfRmtLocCountry">
                                                                                                                <RmtLctnDtls>
                                                                                                                    <xsl:if test="ns17:relRemInfRmtLocMthd">
                                                                                                                        <Mtd>
                                                                                                                            <xsl:value-of select="substring(string(ns17:relRemInfRmtLocMthd), '1', '35')"/>
                                                                                                                        </Mtd>
                                                                                                                    </xsl:if>
                                                                                                                    <xsl:if test="ns17:relRemInfRmtLocElectAddr">
                                                                                                                        <ElctrncAdr>
                                                                                                                            <xsl:value-of select="ns17:relRemInfRmtLocElectAddr"/>
                                                                                                                        </ElctrncAdr>
                                                                                                                    </xsl:if>
                                                                                                                    <xsl:if test="ns17:relRemInfRmtLocAddrName or ns17:relRemInfRmtLocAddrTownName or ns17:relRemInfRmtLocCountry">
                                                                                                                        <PstlAdr>
                                                                                                                            <xsl:if test="ns17:relRemInfRmtLocAddrName">
                                                                                                                                <Nm>
                                                                                                                                    <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrName), '1', '140')"/>
                                                                                                                                </Nm>
                                                                                                                            </xsl:if>
                                                                                                                            <xsl:choose>
                                                                                                                                <xsl:when test="ns17:relRemInfRmtLocAddrTownName and ns17:relRemInfRmtLocAddrCountry">
                                                                                                                                    <Adr>
                                                                                                                                        <xsl:if test="ns17:relRemInfRmtLocAddrDept">
                                                                                                                                            <Dept>
                                                                                                                                                <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrDept), '1', '70')"/>
                                                                                                                                            </Dept>
                                                                                                                                        </xsl:if>
                                                                                                                                        <xsl:if test="ns17:relRemInfRmtLocAddrSubDept">
                                                                                                                                            <SubDept>
                                                                                                                                                <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrSubDept), '1', '70')"/>
                                                                                                                                            </SubDept>
                                                                                                                                        </xsl:if>
                                                                                                                                        <xsl:if test="ns17:relRemInfRmtLocAddrStreetName">
                                                                                                                                            <StrtNm>
                                                                                                                                                <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrStreetName), '1', '70')"/>
                                                                                                                                            </StrtNm>
                                                                                                                                        </xsl:if>
                                                                                                                                        <xsl:if test="ns17:relRemInfRmtLocAddrBldgNo">
                                                                                                                                            <BldgNb>
                                                                                                                                                <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrBldgNo), '1', '16')"/>
                                                                                                                                            </BldgNb>
                                                                                                                                        </xsl:if>
                                                                                                                                        <xsl:if test="ns17:relRemInfRmtLocAddrBldgName">
                                                                                                                                            <BldgNm>
                                                                                                                                                <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrBldgName), '1', '35')"/>
                                                                                                                                            </BldgNm>
                                                                                                                                        </xsl:if>
                                                                                                                                        <xsl:if test="ns17:relRemInfRmtLocAddrBldgFloor">
                                                                                                                                            <Flr>
                                                                                                                                                <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrBldgFloor), '1', '70')"/>
                                                                                                                                            </Flr>
                                                                                                                                        </xsl:if>
                                                                                                                                        <xsl:if test="ns17:relRemInfRmtLocAddrPostBox">
                                                                                                                                            <PstBx>
                                                                                                                                                <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrPostBox), '1', '16')"/>
                                                                                                                                            </PstBx>
                                                                                                                                        </xsl:if>
                                                                                                                                        <xsl:if test="ns17:relRemInfRmtLocAddrRoom">
                                                                                                                                            <Room>
                                                                                                                                                <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrRoom), '1', '70')"/>
                                                                                                                                            </Room>
                                                                                                                                        </xsl:if>
                                                                                                                                        <xsl:if test="ns17:relRemInfRmtLocAddrPostCode">
                                                                                                                                            <PstCd>
                                                                                                                                                <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrPostCode), '1', '16')"/>
                                                                                                                                            </PstCd>
                                                                                                                                        </xsl:if>
                                                                                                                                        <xsl:if test="ns17:relRemInfRmtLocAddrTownName">
                                                                                                                                            <TwnNm>
                                                                                                                                                <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrTownName), '1', '35')"/>
                                                                                                                                            </TwnNm>
                                                                                                                                        </xsl:if>
                                                                                                                                        <xsl:if test="ns17:relRemInfRmtLocAddrTownLocation">
                                                                                                                                            <TwnLctnNm>
                                                                                                                                                <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrTownLocation), '1', '35')"/>
                                                                                                                                            </TwnLctnNm>
                                                                                                                                        </xsl:if>
                                                                                                                                        <xsl:if test="ns17:relRemInfRmtLocAddrDistrict">
                                                                                                                                            <DstrctNm>
                                                                                                                                                <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrDistrict), '1', '35')"/>
                                                                                                                                            </DstrctNm>
                                                                                                                                        </xsl:if>
                                                                                                                                        <xsl:if test="ns17:relRemInfRmtLocAddrCountrySubDiv">
                                                                                                                                            <CtrySubDvsn>
                                                                                                                                                <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrCountrySubDiv), '1', '35')"/>
                                                                                                                                            </CtrySubDvsn>
                                                                                                                                        </xsl:if>
                                                                                                                                        <xsl:if test="ns17:relRemInfRmtLocAddrCountry">
                                                                                                                                            <Ctry>
                                                                                                                                                <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrCountry), '1', '2')"/>
                                                                                                                                            </Ctry>
                                                                                                                                        </xsl:if>
                                                                                                                                    </Adr>
                                                                                                                                </xsl:when>
                                                                                                                                <xsl:otherwise>
                                                                                                                                    <xsl:if test="ns17:relRemInfRmtLocAddrLine1 or ns17:relRemInfRmtLocAddrLine2 or ns17:relRemInfRmtLocAddrLine3">
                                                                                                                                        <Adr>
                                                                                                                                            <xsl:if test="ns17:relRemInfRmtLocAddrLine1">
                                                                                                                                                <AdrLine>
                                                                                                                                                    <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrLine1), '1', '35')"/>
                                                                                                                                                </AdrLine>
                                                                                                                                            </xsl:if>
                                                                                                                                            <xsl:if test="ns17:relRemInfRmtLocAddrLine2">
                                                                                                                                                <AdrLine>
                                                                                                                                                    <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrLine2), '1', '35')"/>
                                                                                                                                                </AdrLine>
                                                                                                                                            </xsl:if>
                                                                                                                                            <xsl:if test="ns17:relRemInfRmtLocAddrLine3">
                                                                                                                                                <AdrLine>
                                                                                                                                                    <xsl:value-of select="substring(string(ns17:relRemInfRmtLocAddrLine3), '1', '35')"/>
                                                                                                                                                </AdrLine>
                                                                                                                                            </xsl:if>
                                                                                                                                        </Adr>
                                                                                                                                    </xsl:if>
                                                                                                                                </xsl:otherwise>
                                                                                                                            </xsl:choose>
                                                                                                                        </PstlAdr>
                                                                                                                    </xsl:if>
                                                                                                                </RmtLctnDtls>
                                                                                                            </xsl:if>
                                                                                                        </xsl:if>
                                                                                                    </xsl:for-each>
                                                                                                </Rltd>
                                                                                            </xsl:if>
                                                                                        </xsl:otherwise>
                                                                                    </xsl:choose>
                                                                                </Rmt>
                                                                            </xsl:when>
                                                                            <xsl:when test="$RespDataOther != ''">
                                                                                <Othr>
                                                                                    <xsl:value-of select="$RespDataOther"/>
                                                                                </Othr>
                                                                            </xsl:when>
                                                                        </xsl:choose>
                                                                    </Rcrd>
                                                                </TxData>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:if test="$ResponseNarrative != ''">
                                                                    <RspnNrrtv>
                                                                        <xsl:value-of select="substring($ResponseNarrative,1,500)"/>
                                                                    </RspnNrrtv>
                                                                </xsl:if>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </RspnData>
                                                </xsl:if>
                                                <xsl:variable name="RespOrgtrBic">
                                                    <xsl:call-template name="findValue">
                                                        <xsl:with-param name="data" select="ns3:responseData"/>
                                                        <xsl:with-param name="values" select="ns3:responseDataValues"/>
                                                        <xsl:with-param name="searchKey" select="'Resp. Orgtr BIC'"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:if test="$RespOrgtrBic != ''">
                                                    <RspnOrgtr>
                                                        <Agt>
                                                            <FinInstnId>
                                                                <BICFI>
                                                                    <xsl:value-of select="$RespOrgtrBic"/>
                                                                </BICFI>
                                                            </FinInstnId>
                                                        </Agt>
                                                    </RspnOrgtr>
                                                </xsl:if>
                                            </InvstgtnData>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </InvstgtnRspn>
                <OrgnlInvstgtnReq>
                    <xsl:if test="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:caseId != ''">
                        <MsgId>
                            <xsl:value-of select="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:caseId"/>
                        </MsgId>
                    </xsl:if>
                    <xsl:if test="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:canReqAssignmentId != ''">
                        <RqstrInvstgtnId>
                            <xsl:value-of select="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:canReqAssignmentId"/>
                        </RqstrInvstgtnId>
                    </xsl:if>
                    <xsl:if test="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:endToEndInvRef != ''">
                        <EIR>
                            <xsl:value-of select="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:endToEndInvRef"/>
                        </EIR>
                    </xsl:if>
                    <xsl:variable name="RequestActionCode">
                        <xsl:value-of select="substring-before(ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:acceptReasonInfo,'_')"/>
                    </xsl:variable>
                    <xsl:variable name="RequestActionCodeAfter">
                        <xsl:value-of select="substring-after(ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:acceptReasonInfo,'_')"/>
                    </xsl:variable>
                    <xsl:variable name="RequestActionRsnCode">
                        <xsl:value-of select="substring-before($RequestActionCodeAfter,'_')"/>
                    </xsl:variable>
                    <xsl:variable name="RequestActionRsnCodeAfter">
                        <xsl:value-of select="substring-after($RequestActionCodeAfter,'_')"/>
                    </xsl:variable>
                    <xsl:variable name="RequestAddtlInfo">
                        <xsl:value-of select="substring-before($RequestActionRsnCodeAfter, '#$#')"/>
                    </xsl:variable>
                    <xsl:variable name="RequestAddtlInfo1">
                        <xsl:value-of select="substring-before($RequestAddtlInfo, '#&amp;#')"/>
                    </xsl:variable>
                    <xsl:variable name="RequestAddtlInfo2">
                        <xsl:value-of select="substring-after($RequestAddtlInfo,'#&amp;#')"/>
                    </xsl:variable>
                    <xsl:if test="$RequestActionCode != '' or $RequestActionRsnCode != '' or $RequestAddtlInfo1 != '' or $RequestAddtlInfo2 != ''">
                        <ReqActn>
                            <xsl:if test="$RequestActionCode != ''">
                                <Actn>
                                    <Cd>
                                        <xsl:value-of select="$RequestActionCode"/>
                                    </Cd>
                                </Actn>
                            </xsl:if>
                            <xsl:if test="$RequestActionRsnCode != '' or $RequestAddtlInfo1 != '' or $RequestAddtlInfo2 != ''">
                                <ActnRsn>
                                    <xsl:if test="$RequestActionRsnCode != ''">
                                        <Rsn>
                                            <Cd>
                                                <xsl:value-of select="$RequestActionRsnCode"/>
                                            </Cd>
                                        </Rsn>
                                    </xsl:if>
                                    <xsl:if test="$RequestAddtlInfo1 != '' or $RequestAddtlInfo2 != ''">
                                        <xsl:if test="$RequestAddtlInfo1">
                                            <AddtlInf>
                                                <xsl:value-of select="$RequestAddtlInfo1"/>
                                            </AddtlInf>
                                        </xsl:if>
                                        <xsl:if test="$RequestAddtlInfo2 != ''">
                                            <AddtlInf>
                                                <xsl:value-of select="$RequestAddtlInfo2"/>
                                            </AddtlInf>
                                        </xsl:if>
                                    </xsl:if>
                                </ActnRsn>
                            </xsl:if>
                        </ReqActn>
                    </xsl:if>
                    <xsl:if test="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:canReqRequestType != ''">
                        <InvstgtnTp>
                            <Cd>
                                <xsl:value-of select="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:canReqRequestType"/>
                            </Cd>
                        </InvstgtnTp>
                    </xsl:if>
                    <xsl:if test="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:canReqRequestSubType != ''">
                        <InvstgtnSubTp>
                            <Cd>
                                <xsl:value-of select="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:canReqRequestSubType"/>
                            </Cd>
                        </InvstgtnSubTp>
                    </xsl:if>
                    <xsl:if test="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:undrlyngInstrmCd != ''">
                        <UndrlygInstrm>
                            <Cd>
                                <xsl:value-of select="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:undrlyngInstrmCd"/>
                            </Cd>
                        </UndrlygInstrm>
                    </xsl:if>
                    <xsl:variable name="RequestorBic">
                        <xsl:for-each select="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:contextValuePair">
                            <xsl:if test="ns3:ContextName = 'camt.111-requestor'">
                                <xsl:value-of select="ns3:ContextValue"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="ResponderBic">
                        <xsl:for-each select="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:contextValuePair">
                            <xsl:if test="ns3:ContextName = 'camt.111-responder'">
                                <xsl:value-of select="ns3:ContextValue"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:if test="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:senderInstBIC != '' and $RequestorBic = ''">
                        <Rqstr>
                            <Agt>
                                <FinInstnId>
                                    <BICFI>
                                        <xsl:value-of select="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:senderInstBIC"/>
                                    </BICFI>
                                </FinInstnId>
                            </Agt>
                        </Rqstr>
                    </xsl:if>
                    <xsl:if test="$RequestorBic != ''">
                        <Rqstr>
                            <Agt>
                                <FinInstnId>
                                    <BICFI>
                                        <xsl:value-of select="$RequestorBic"/>
                                    </BICFI>
                                </FinInstnId>
                            </Agt>
                        </Rqstr>
                    </xsl:if>
                    <xsl:if test="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:receiverBic != '' and $ResponderBic = ''">
                        <Rspndr>
                            <Agt>
                                <FinInstnId>
                                    <BICFI>
                                        <xsl:value-of select="ns18:doOutwardMappingForCR/ns18:icancelreqrec/ns3:receiverBic"/>
                                    </BICFI>
                                </FinInstnId>
                            </Agt>
                        </Rspndr>
                    </xsl:if>
                    <xsl:if test="$ResponderBic != ''">
                        <Rspndr>
                            <Agt>
                                <FinInstnId>
                                    <BICFI>
                                        <xsl:value-of select="$ResponderBic"/>
                                    </BICFI>
                                </FinInstnId>
                            </Agt>
                        </Rspndr>
                    </xsl:if>
                </OrgnlInvstgtnReq>
            </InvstgtnRspn>
        </Document>
    </xsl:template>
</xsl:stylesheet>
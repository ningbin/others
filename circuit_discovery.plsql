set define off;
------------------------------------------------------------------------------------------------------------------------
------------------------------ The following is utiltity class for ciruit discovery       ------------------------------
------------------------------------------------------------------------------------------------------------------------
create or replace
PACKAGE circuit_util AS
    g_log_enable       BOOLEAN DEFAULT FALSE;
    g_print_log_time   BOOLEAN DEFAULT FALSE;
    g_print_log_start  BOOLEAN DEFAULT TRUE;
    g_print_log_end    BOOLEAN DEFAULT TRUE;
    g_debug_enable    BOOLEAN DEFAULT FALSE;
    
    TYPE facTribSlotTable IS TABLE OF cm_facility.fac_tribslot%type;

    PROCEDURE print_line(message IN VARCHAR);
    PROCEDURE print_start(procName IN VARCHAR);
    PROCEDURE print_end(procName IN VARCHAR);
    PROCEDURE who_call_me( o_owner OUT VARCHAR, o_object OUT VARCHAR, o_lineno OUT NUMBER, i_level NUMBER DEFAULT 5 );

    FUNCTION getVCGCardId(vcgId IN number) RETURN NUMBER;
    FUNCTION getVCGCardAid(vcgId IN number) RETURN VARCHAR;
    FUNCTION getVcNumberingBase(neId IN NUMBER) RETURN NUMBER;

    FUNCTION isOSMModule(ochpId IN NUMBER) RETURN BOOLEAN;
    FUNCTION getFacilityCardId(facParentId NUMBER, facIParentType VARCHAR2) RETURN NUMBER;
    FUNCTION getFacilityParentAid(facId IN NUMBER, facAid IN VARCHAR) RETURN VARCHAR;
    FUNCTION getFacilityChildAid(facId IN NUMBER, facAid IN VARCHAR) RETURN VARCHAR;
    FUNCTION getFacilityID(neId IN NUMBER, facilityAID IN VARCHAR) RETURN NUMBER;
    FUNCTION getFacAidType( facAid IN VARCHAR) RETURN VARCHAR;
    FUNCTION getFacCardId(facId IN number) RETURN NUMBER;
    FUNCTION getFacCardAid(facId IN NUMBER) RETURN VARCHAR;
    FUNCTION getFacCardType(facId IN NUMBER) RETURN VARCHAR;
    FUNCTION getFacSFP(neId IN NUMBER, facId IN NUMBER) RETURN NUMBER;
    FUNCTION getClientFacilityPort(facId IN NUMBER, facPort IN NUMBER) RETURN NUMBER;
    FUNCTION getFacAidById(oduId IN NUMBER) RETURN VARCHAR2;
    FUNCTION getNeTidById(neId IN NUMBER) RETURN VARCHAR2;

    FUNCTION isLineOdu(neId IN NUMBER, oduId IN NUMBER) RETURN BOOLEAN;
    FUNCTION isPortOdu(neId IN NUMBER, oduId IN NUMBER) RETURN BOOLEAN;
    FUNCTION isOdu2Crossconnected(oduId IN NUMBER) RETURN BOOLEAN;
    FUNCTION isOchFacility(ochId IN NUMBER) RETURN BOOLEAN;
    FUNCTION isPassthrLink(neId IN NUMBER, ochType IN VARCHAR, eqptOPSMProtId IN NUMBER, eqptSMTMProtId IN NUMBER) RETURN BOOLEAN;

    FUNCTION getOtherOCHCard(crsFromCard IN number, crsToCard IN number, crsFromId IN number, crsToId IN number, ochId IN NUMBER) RETURN NUMBER;
    FUNCTION getOtherOCHTimeSlot(crsFromId IN number, crsToId IN number, ochId IN NUMBER) RETURN VARCHAR;
    FUNCTION getOtherOCHAid(crsFromAid IN VARCHAR, crsToAid IN VARCHAR, crsFromId IN number, crsToId IN number, ochId IN NUMBER) RETURN VARCHAR;
    FUNCTION getOtherOCH(crsFromId IN NUMBER, crsToId IN NUMBER, ochId IN NUMBER) RETURN NUMBER;
    FUNCTION getOtherOCHDirection(crsFromId IN NUMBER, crsToId IN NUMBER, ochId IN NUMBER) RETURN VARCHAR;
    FUNCTION getOtherOCHNumber(crsFromId IN NUMBER, crsToId IN NUMBER, ochId IN NUMBER, numFrom IN NUMBER, numTo IN NUMBER) RETURN NUMBER;
    FUNCTION getOtherOCHString(crsFromId IN number, crsToId IN number, ochId IN NUMBER,  strFrom IN VARCHAR, strTo IN VARCHAR) RETURN VARCHAR;

    FUNCTION getCrsPRType(facFromId IN NUMBER,facToId IN NUMBER) RETURN VARCHAR;
    FUNCTION getDxUsage(omdId IN NUMBER) RETURN VARCHAR;
    FUNCTION getCMMChannel(
        neId NUMBER,        cmmId IN NUMBER,    cardId IN NUMBER,
        fromPort IN NUMBER, toPort IN NUMBER,   cmmAidType VARCHAR2,
        cmmShelf NUMBER,    cmmSlot NUMBER,     band NUMBER
    ) RETURN NUMBER;
    FUNCTION getConnectionSupportingEqpt(cpAid IN VARCHAR2, neId IN NUMBER, ochId IN number) RETURN VARCHAR;
    FUNCTION getConnectionEquipmentSide(neId IN NUMBER, ochId IN number) RETURN VARCHAR;
    FUNCTION getConnectionProtection(crsFromId IN NUMBER, crsToId IN NUMBER, ochId IN NUMBER, ochAid IN VARCHAR) RETURN VARCHAR;
    FUNCTION getNonforeignWavelengthOCH(neId IN NUMBER, neStype IN VARCHAR, crsId IN NUMBER, cpId IN NUMBER, ccPath IN VARCHAR) RETURN VARCHAR;
    FUNCTION getMultiplexerOCH(neId IN NUMBER, entityId IN NUMBER, ochType IN VARCHAR) RETURN NUMBER;
    FUNCTION getExpressDP(neId IN NUMBER, entityId IN NUMBER) RETURN NUMBER;

    FUNCTION getMappingFacFromOdu(neId IN NUMBER, oduId IN NUMBER) RETURN NUMBER;
    FUNCTION getMappingOduFromFac(neId IN NUMBER, facId IN NUMBER) RETURN NUMBER;
    FUNCTION getMappingOchPFromOdu(neId IN NUMBER, oduId IN NUMBER) RETURN NUMBER;
    FUNCTION getMappingOduFromOchP(neId IN NUMBER, ochpId IN NUMBER) RETURN NUMBER;
    --FUNCTION getMappingOdu2FromOdu1(p_ne_id IN NUMBER, p_lower_odu_id IN NUMBER, odu0_tribslot OUT VARCHAR2, odu1_tribslot OUT VARCHAR2, odu2_tribslot OUT VARCHAR2, middle_odu_list OUT V_B_STRING) RETURN NUMBER;
    --FUNCTION getMappingOdu1FromOdu2(v_ne_id IN NUMBER, v_odu2_id IN NUMBER, v_odu0_tribslot IN VARCHAR2, v_odu1_tribslot IN VARCHAR2, middle_odu_list OUT V_B_STRING) RETURN NUMBER;
    FUNCTION getTopMappingOduFromLower(p_ne_id IN NUMBER, p_lower_odu_id IN NUMBER, odu_mapping_list OUT V_B_STRING, odu_mapping_type_list OUT V_B_STRING, odu_mapping_tribslot_list OUT V_B_STRING) RETURN NUMBER;
    FUNCTION getBottomMappingOduFromHigher(v_ne_id IN NUMBER, v_higer_odu_id IN NUMBER, odu_mapping_tribslot_list IN V_B_STRING, middle_odu_list OUT V_B_STRING) RETURN NUMBER;
    FUNCTION getOduLayer(oduAid IN VARCHAR) RETURN PLS_INTEGER;
    --FUNCTION getOduMuxTo(oduAid IN VARCHAR) RETURN VARCHAR;
    FUNCTION isOduMuxTo(highOduAid IN VARCHAR, lowOduAid IN VARCHAR) RETURN NUMBER;
    FUNCTION getOduMuxNum( oduAid IN VARCHAR) RETURN VARCHAR;
    FUNCTION trimAidType(facAid IN VARCHAR2 ) RETURN VARCHAR2;
    FUNCTION isTribslotSubsetOf( highTribSlot IN VARCHAR, lowTribSlotTab IN facTribSlotTable) RETURN BOOLEAN;

    FUNCTION getOTNMXCedLineFacility(timeslots IN VARCHAR, neId IN NUMBER, cardAID IN VARCHAR) RETURN VARCHAR;
    FUNCTION getOTNMXCedAllLineFacility(timeslots IN VARCHAR, neId IN NUMBER, cardID IN NUMBER, cardAID IN VARCHAR) RETURN VARCHAR;

    FUNCTION determineConnectionWorkOrProt(ccType VARCHAR, fromCardId IN NUMBER, toCardId IN NUMBER, fromOch IN NUMBER, toOch IN NUMBER) RETURN VARCHAR;
    FUNCTION generateOLAOLUccPath(neType IN VARCHAR) RETURN VARCHAR;

    FUNCTION convertTimeslotToVC4(fromNeId IN NUMBER, toNeId IN NUMBER, timeslot IN VARCHAR) RETURN VARCHAR;
    FUNCTION convertTimeslotNonVC4ToVC4(timeSlot IN VARCHAR) RETURN VARCHAR;
    FUNCTION convertTimeslotVC4ToNonVC4(timeSlot IN VARCHAR) RETURN VARCHAR;

    FUNCTION constructLinkInfo(
        fromNeId IN NUMBER, toNeId IN NUMBER, fromOchDP IN VARCHAR,
        toOchDP IN VARCHAR, fromSide IN VARCHAR, toSide IN VARCHAR,
        xcchanNum IN NUMBER, g_delimiter CHAR
    ) RETURN VARCHAR2;
END circuit_util;
/
create or replace
PACKAGE BODY circuit_util AS
    TYPE IntTable IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
    TYPE EMS_REF_CURSOR IS REF CURSOR;

    PROCEDURE print_line(message IN VARCHAR) AS
        l_owner VARCHAR(30);
        l_object VARCHAR(30);
        l_timestr VARCHAR(30);
        l_lineno NUMBER;
    BEGIN
      IF g_log_enable THEN
          IF g_print_log_time THEN
             l_timestr := to_char(systimestamp, 'yyyy-mm-dd hh24:mi:ss.FF5');
          END IF;

          IF g_debug_enable THEN
             who_call_me( l_owner,l_object,l_lineno );
             dbms_output.put_line(l_object||'.'||l_lineno||': '||l_timestr|| ' ' || message);
          ELSE
             dbms_output.put_line(l_timestr || ' ' || message);
          END IF;
      END IF;
    END print_line;

    PROCEDURE print_start(procName IN VARCHAR) AS
        l_owner VARCHAR(30);
        l_object VARCHAR(30);
        l_timestr VARCHAR(30);
        l_lineno NUMBER;
    BEGIN
      IF g_log_enable AND g_print_log_start THEN
         IF g_print_log_time THEN
             l_timestr := to_char(systimestamp, 'yyyy-mm-dd hh24:mi:ss.FF5');
          END IF;

          IF g_debug_enable THEN
             who_call_me( l_owner,l_object,l_lineno,6 );
             dbms_output.put_line(l_object||'.'||l_lineno||': '||l_timestr||' Start ' || procName || '()');
          ELSE
             dbms_output.put_line(l_timestr||' :::Start ' || procName || '()');
          END IF;
      END IF;
    END print_start;

    PROCEDURE print_end(procName IN VARCHAR) AS
        l_owner VARCHAR(30);
        l_object VARCHAR(30);
        l_timestr VARCHAR(30);
        l_lineno NUMBER;
    BEGIN
      IF g_log_enable AND g_print_log_end THEN
         IF g_print_log_time THEN
             l_timestr := to_char(systimestamp, 'yyyy-mm-dd hh24:mi:ss.FF5');
          END IF;

          IF g_debug_enable THEN
             who_call_me( l_owner,l_object,l_lineno,6 );
             dbms_output.put_line(l_object||'.'||l_lineno||': '||l_timestr||' End ' || procName || '()');
          ELSE
             dbms_output.put_line(l_timestr||' :::End ' || procName || '()');
          END IF;
      END IF;
    END print_end;

    PROCEDURE who_call_me( o_owner OUT VARCHAR, o_object OUT VARCHAR, o_lineno OUT NUMBER, i_level NUMBER DEFAULT 5 ) AS
      l_call_stack long default dbms_utility.format_call_stack;
      l_line varchar2(4000);
    BEGIN
      for i in 1..i_level loop
        l_call_stack := substr( l_call_stack,
                        instr( l_call_stack, chr(10)) + 1 );
      end loop;

      l_line := ltrim( substr( l_call_stack,
                       1,
                       instr( l_call_stack, chr(10) )-1 ));

      l_line := ltrim( substr( l_line, instr( l_line, ' ')));
      o_lineno := to_number(substr( l_line, 1, instr(l_line, ' ')));
      l_line := ltrim( substr( l_line, instr( l_line, ' ')));
      l_line := ltrim( substr( l_line, instr( l_line, ' ')));

      if l_line like 'block%' or
         l_line like 'body%' then
        l_line := ltrim( substr( l_line, instr( l_line, ' ')));
      end if;

      o_owner := ltrim( rtrim( substr( l_line,
                            1,
                            instr(l_line, '.')-1 )));

      o_object := ltrim( rtrim( substr( l_line,
                             instr(l_line, '.')+1 )));

      if o_owner is null then
        o_owner := 'USER';
        o_object := 'ANONYMOUS';
      end if;

    END who_call_me;

    FUNCTION getVCGCardId(
            vcgId IN number
    ) RETURN NUMBER IS
        cur_v          EMS_REF_CURSOR;
        retVal    NUMBER := 0;
    BEGIN
        OPEN cur_v FOR select CARD_ID from CM_CARD, CM_INTERFACE, CM_VCG where CARD_ID=INTF_PARENT_ID AND INTF_ID=VCG_PARENT_ID AND VCG_ID=vcgId;
        FETCH cur_v INTO retVal;
        CLOSE cur_v;
        RETURN retVal;
    END getVCGCardId;
    FUNCTION getVCGCardAid(
            vcgId IN number
    ) RETURN VARCHAR IS
        cur_v          EMS_REF_CURSOR;
        retVal    VARCHAR(70) :='';
    BEGIN
        OPEN cur_v FOR select CARD_AID from CM_CARD, CM_INTERFACE, CM_VCG where CARD_ID=INTF_PARENT_ID AND INTF_ID=VCG_PARENT_ID AND VCG_ID=vcgId;
        FETCH cur_v INTO retVal;
        CLOSE cur_v;
        RETURN retVal;
    END getVCGCardAid;

    FUNCTION getVcNumberingBase(neId IN NUMBER) RETURN NUMBER IS
          v_ref_cursor1 EMS_REF_CURSOR;
          v_ne_version     VARCHAR2(30);
          v_ne_sts_vc_mode     VARCHAR2(10);
          v_converted_base  NUMBER := 48;
    BEGIN
        OPEN v_ref_cursor1 FOR select SW_VER, NE_STSVCMDE FROM EMS_NE, CM_SW      WHERE EMS_NE.NE_ID = neId AND CM_SW.NE_ID = neId;
        FETCH v_ref_cursor1 INTO v_ne_version, v_ne_sts_vc_mode;
        CLOSE v_ref_cursor1;
        IF v_ne_version IS NULL OR  v_ne_sts_vc_mode =  'STS' THEN
            RETURN v_converted_base;
        END IF;
        -- FP5.1.1 and above
        IF compareVersion(v_ne_version, '5.1.1') >= 0 THEN
            RETURN 16;
        END IF;
        RETURN v_converted_base;
    END getVcNumberingBase;

    FUNCTION isOSMModule(ochpId IN NUMBER) RETURN BOOLEAN
    AS
       v_card_aid VARCHAR2(50);
    BEGIN
        v_card_aid := getFacilityParentAid(ochpId, 'OCH-P');
        if v_card_aid LIKE 'OSM%' then
           return true;
        elsif v_card_aid LIKE 'HGTMM%' then
           return true;
        elsif v_card_aid LIKE 'OMMX%' then
           return true;
        else
           return false;
        end if;

    END isOSMModule;

    FUNCTION getFacilityCardId(facParentId NUMBER, facIParentType VARCHAR2) RETURN NUMBER
    AS
        v_card_id NUMBER;
        v_entity_id NUMBER;
        v_entity_parent_type VARCHAR2(20);
    BEGIN
        CASE facIParentType
            WHEN 'CARD' THEN
                SELECT card_id INTO v_card_id FROM cm_card WHERE card_id = facParentId;
            WHEN 'INTF' THEN
                SELECT intf_parent_id INTO v_card_id FROM cm_interface WHERE intf_id = facParentId;
            WHEN 'OTS' THEN
                SELECT ots_parent_id INTO v_card_id FROM cm_facility_ots WHERE ots_id = facParentId;
            WHEN 'OMS' THEN
                SELECT ots_parent_id INTO v_card_id FROM cm_facility_ots WHERE ots_id = (SELECT oms_parent_id FROM cm_facility_oms WHERE oms_id= facParentId);
            WHEN 'FACILITY' THEN
                SELECT fac_i_parent_type, fac_parent_id INTO v_entity_parent_type, v_entity_id FROM cm_facility WHERE fac_id=facParentId;
                RETURN getFacilityCardId(v_entity_id, v_entity_parent_type);
            WHEN 'OCH-DP' THEN
                SELECT och_i_parent_type, och_parent_id INTO v_entity_parent_type, v_entity_id FROM cm_channel_och WHERE och_id=facParentId;
                RETURN getFacilityCardId(v_entity_id, v_entity_parent_type);
            WHEN 'OCH' THEN
                SELECT card_id INTO v_card_id FROM cm_card WHERE card_id = (select och_parent_id FROM cm_channel_och WHERE och_id=facParentId);
            WHEN 'STS' THEN
                SELECT sts_i_parent_type, sts_parent_id INTO v_entity_parent_type, v_entity_id FROM cm_sts WHERE sts_id=facParentId;
                RETURN getFacilityCardId(v_entity_id, v_entity_parent_type);
        END CASE;
        RETURN v_card_id;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN facParentId;
    END getFacilityCardId;

    FUNCTION getFacilityParentAid(facId IN NUMBER, facAid IN VARCHAR) RETURN VARCHAR IS
      cur_v             EMS_REF_CURSOR;
      retVal            VARCHAR2(70);
    BEGIN circuit_util.print_start('getFacilityParentAid');
      retVal:='';

      IF facAid LIKE 'TTP%' THEN
         OPEN cur_v FOR select nvl(STS_TTP_VCG_AID,'0') FROM CM_STS WHERE STS_ID=facId;
         FETCH cur_v INTO retVal;
         CLOSE cur_v;
         IF retVal = '0' THEN
            OPEN cur_v FOR select nvl(FAC_IVCG_AID,'') FROM CM_FACILITY WHERE FAC_PARENT_ID=facId;
            FETCH cur_v INTO retVal;
            CLOSE cur_v;
         END IF;

      ELSIF facAid LIKE 'ODU2-%' THEN
         OPEN cur_v FOR SELECT pfac.FAC_AID FROM CM_FACILITY pfac, CM_FACILITY fac WHERE pfac.FAC_ID=fac.FAC_PARENT_ID AND fac.FAC_ID=facId;
         FETCH cur_v INTO retVal;
         CLOSE cur_v;
      ELSIF facAid LIKE 'OCH-P%' THEN
         OPEN cur_v FOR SELECT card.CARD_AID FROM CM_CARD card, CM_CHANNEL_OCH och WHERE och.OCH_ID = facId AND och.OCH_PARENT_ID = card.CARD_ID;
         FETCH cur_v INTO retVal;
         CLOSE cur_v;
      ELSE
         -- for STS
         OPEN cur_v FOR select fac2.FAC_AID FROM CM_STS fac1, CM_FACILITY fac2 WHERE fac2.FAC_ID=fac1.STS_PARENT_ID AND fac1.STS_ID=facId;
         FETCH cur_v INTO retVal;
         CLOSE cur_v;

         IF retVal is not null THEN -- for Port Facility
            OPEN cur_v FOR SELECT CARD_AID FROM CM_CARD, CM_FACILITY WHERE CARD_ID=FAC_PARENT_ID AND FAC_ID=facId;
            FETCH cur_v INTO retVal;
            CLOSE cur_v;
         ELSE -- parent may be aggegrate CNV
            OPEN cur_v FOR select fac2.STS_AID FROM CM_STS fac1, CM_STS fac2 WHERE fac2.STS_ID=fac1.STS_PARENT_ID AND fac1.STS_ID=facId;
            FETCH cur_v INTO retVal;
            CLOSE cur_v;
         END IF;
      END IF;
     circuit_util.print_end('getFacilityParentAid');
      RETURN retVal;
    END getFacilityParentAid;

    FUNCTION getFacilityChildAid(facId IN NUMBER, facAid IN VARCHAR) RETURN VARCHAR IS
      cur_v             EMS_REF_CURSOR;
      retVal            VARCHAR2(70);
    BEGIN circuit_util.print_start('getFacilityChildAid');
      retVal:='';

      IF facAid LIKE 'TTP%' THEN
         OPEN cur_v FOR select nvl(FAC_AID,'') FROM CM_FACILITY WHERE FAC_PARENT_ID=facId;
         FETCH cur_v INTO retVal;
         CLOSE cur_v;
      END IF;
     circuit_util.print_end('getFacilityChildAid');
      RETURN retVal;
    END getFacilityChildAid;

    FUNCTION getFacilityID(neId IN NUMBER, facilityAID IN VARCHAR) RETURN NUMBER IS
      cur_v           EMS_REF_CURSOR;
      facilityIDNum   NUMBER;
    -- This function will return a facility ID by looking up it's NE ID and facility aid.
    BEGIN circuit_util.print_start('getFacilityID');
      OPEN cur_v FOR select FAC_ID
            FROM CM_FACILITY
            WHERE NE_ID = neId AND FAC_AID=facilityAID;
      FETCH cur_v INTO facilityIDNum;
      CLOSE cur_v;
    circuit_util.print_end('getFacilityID');
      RETURN facilityIDNum;
    END getFacilityID;

    FUNCTION getFacAidType( facAid IN VARCHAR) RETURN VARCHAR IS
    BEGIN
      RETURN SUBSTR(facAid, 0, INSTR(facAid,'-')-1);
    END getFacAidType;

    FUNCTION getFacCardId(facId IN NUMBER) RETURN NUMBER IS
      cur_v          EMS_REF_CURSOR;
      retVal    NUMBER;
    BEGIN circuit_util.print_start('getFacCardId');
      retVal:=0;
      --exten other type of facilities later
      OPEN cur_v FOR select nvl(CARD_ID,0) from CM_CARD, CM_INTERFACE, CM_STS where CARD_ID=INTF_PARENT_ID AND INTF_ID=STS_PARENT_ID AND STS_ID=facId
                    UNION select nvl(CARD_ID,0) from CM_CARD, CM_FACILITY, CM_STS where CARD_ID=FAC_PARENT_ID AND FAC_ID=STS_PARENT_ID AND STS_ID=facId
                    UNION select nvl(CARD_ID,0) from CM_CARD, CM_FACILITY where CARD_ID=FAC_PARENT_ID AND FAC_ID=facId
                    UNION select nvl(CARD_ID,0) from CM_CARD, CM_FACILITY C1, CM_FACILITY C2 where CARD_ID=C1.FAC_PARENT_ID AND C1.FAC_ID=C2.FAC_PARENT_ID AND C2.FAC_ID=facId;
      FETCH cur_v INTO retVal;
      CLOSE cur_v;

    circuit_util.print_end('getFacCardId');
      RETURN retVal;
    END getFacCardId;

    FUNCTION getFacCardAid(facId IN NUMBER) RETURN VARCHAR IS
      cur_v          EMS_REF_CURSOR;
      retVal    VARCHAR(70);
    BEGIN circuit_util.print_start('getFacCardAid');
      retVal:='0';

      --exten other type of facilities later
      OPEN cur_v FOR select CARD_AID from CM_CARD, CM_INTERFACE, CM_STS where CARD_ID=INTF_PARENT_ID AND INTF_ID=STS_PARENT_ID AND STS_ID=facId
                    UNION select CARD_AID from CM_CARD, CM_FACILITY, CM_STS where CARD_ID=FAC_PARENT_ID AND FAC_ID=STS_PARENT_ID AND STS_ID=facId
                    UNION select CARD_AID from CM_CARD, CM_FACILITY where CARD_ID=FAC_PARENT_ID AND FAC_ID=facId
                    UNION select CARD_AID from CM_CARD, CM_FACILITY C1, CM_FACILITY C2 where CARD_ID=C1.FAC_PARENT_ID AND C1.FAC_ID=C2.FAC_PARENT_ID AND C2.FAC_ID=facId;
      FETCH cur_v INTO retVal;
      CLOSE cur_v;

      circuit_util.print_end('getFacCardAid');
      RETURN retVal;
    END getFacCardAid;

    FUNCTION getFacCardType(facId IN NUMBER) RETURN VARCHAR IS -- added from HGTMM
      cur_v          EMS_REF_CURSOR;
      retVal         VARCHAR(70);
    BEGIN circuit_util.print_start('getFacCardType');
      retVal:='0';

      --exten other type of facilities later
      /*OPEN cur_v FOR select CARD_AID_TYPE from CM_CARD, CM_INTERFACE, CM_STS where CARD_ID=INTF_PARENT_ID AND INTF_ID=STS_PARENT_ID AND STS_ID=facId
                    UNION select CARD_AID_TYPE from CM_CARD, CM_FACILITY, CM_STS where CARD_ID=FAC_PARENT_ID AND FAC_ID=STS_PARENT_ID AND STS_ID=facId
                    UNION select CARD_AID_TYPE from CM_CARD, CM_FACILITY where CARD_ID=FAC_PARENT_ID AND FAC_ID=facId
                    UNION select CARD_AID_TYPE from CM_CARD, CM_FACILITY C1, CM_FACILITY C2 where CARD_ID=C1.FAC_PARENT_ID AND C1.FAC_ID=C2.FAC_PARENT_ID AND C2.FAC_ID=facId;
      */
      OPEN cur_v FOR select CARD_AID_TYPE from CM_CARD, CM_STS where CARD_I_PARENT_TYPE='SHELF' AND CARD_AID_SHELF=STS_AID_SHELF AND CARD_AID_SLOT=STS_AID_SLOT AND CM_STS.NE_ID=CM_CARD.NE_ID AND STS_ID=facId
               UNION select CARD_AID_TYPE from CM_CARD, CM_FACILITY where CARD_I_PARENT_TYPE='SHELF' AND CARD_AID_SHELF=FAC_AID_SHELF AND CARD_AID_SLOT=FAC_AID_SLOT AND CM_FACILITY.NE_ID=CM_CARD.NE_ID AND FAC_ID=facId;
      FETCH cur_v INTO retVal;
      CLOSE cur_v;

      circuit_util.print_end('getFacCardType');
      RETURN retVal;
    END getFacCardType;

    FUNCTION getFacSFP(neId IN NUMBER, facId IN NUMBER) RETURN NUMBER IS
        retVal     NUMBER;
        cur_v      EMS_REF_CURSOR;
    BEGIN
       IF LENGTH(facId) <> 13 THEN RETURN 0; END IF;
       OPEN cur_v FOR select c.ID from CARD_CM_VW c, FACILITY_CM_VW f
             WHERE f.NE_ID=neId AND f.ID=facId AND f.PARENT_TYPE='CARD'
             AND c.NE_ID = neId AND c.SHELFNO=f.SHELFNO AND c.SLOTNO=f.SLOTNO AND c.PORTNO=f.PORTNO
             AND (c.AID_TYPE LIKE '_FP' OR c.AID_TYPE LIKE '%SFPP');
        FETCH cur_v INTO retVal;
        CLOSE cur_v;
        RETURN retVal;
    END getFacSFP;

    FUNCTION getClientFacilityPort(facId IN NUMBER, facPort IN NUMBER) RETURN NUMBER IS
        cur_v             EMS_REF_CURSOR;
        retVal            NUMBER;
        scheme            VARCHAR2(33);
        v_cardId          NUMBER;
        v_cardAid         VARCHAR2(20);
        v_ochAid          VARCHAR2(20);
        v_odu2Aid         VARCHAR2(20);
        v_portOdu2Aid     VARCHAR2(20);
    BEGIN circuit_util.print_start('getClientFacilityPort');
        retVal:=facPort+1; -- default
        OPEN cur_v FOR select OCH_SCHEME from CM_CHANNEL_OCH WHERE OCH_ID=facId;
        FETCH cur_v INTO scheme;
        CLOSE cur_v;

        IF scheme = 'DPRING' THEN
           IF facPort=5 OR facPort=9 THEN
              retVal:=facPort-1;
           END IF;
        END IF;

        OPEN cur_v FOR SELECT CARD_ID, CARD_AID, och.OCH_AID FROM CM_CHANNEL_OCH och, CM_CARD card where och.OCH_ID = facId and och.OCH_PARENT_ID = card.CARD_ID;
        FETCH cur_v INTO v_cardId, v_cardAid, v_ochAid;
        CLOSE cur_v;

        IF v_cardAid LIKE 'OSM%' OR v_cardAid LIKE 'OMMX%' THEN
           v_odu2Aid := 'ODU2-' || substr(v_ochAid, 7, length(v_ochAid) - 6) || '-1';
           OPEN cur_v FOR select a.fac_aid
                          from cm_facility a, cm_facility b, cm_crs_odu crs
                          where ((crs.crs_odu_from_id = b.fac_id and crs.crs_odu_to_id = a.fac_id) or (crs.crs_odu_from_id = a.fac_id and crs.crs_odu_to_id = b.fac_id))
                          and b.fac_aid = v_odu2Aid;
           FETCH cur_v INTO v_portOdu2Aid;
           IF cur_v%NOTFOUND THEN
               retVal := 0;
           ELSE
               retVal := substr(v_portOdu2Aid, length(v_cardAid) + 1, length(v_portOdu2Aid) - 2 - length(v_cardAid));
           END IF;
        END IF;
        --circuit_util.print_end('getClientFacilityPort');
        RETURN retVal;
    END getClientFacilityPort;
    FUNCTION getFacAidById(oduId IN NUMBER) RETURN VARCHAR2 IS
        oduAid       VARCHAR2(40);
        cur_v        EMS_REF_CURSOR;
    BEGIN
        oduAid := '';
        OPEN cur_v FOR SELECT FAC_AID FROM CM_FACILITY WHERE FAC_ID = oduId;
        FETCH cur_v INTO oduAid;
        CLOSE cur_v;
        RETURN oduAid;
    END getFacAidById;

    FUNCTION getNeTidById(neId IN NUMBER) RETURN VARCHAR2 IS
        tid       VARCHAR2(50);
        cur_v     EMS_REF_CURSOR;
    BEGIN
        OPEN cur_v FOR SELECT NE_TID FROM EMS_NE WHERE NE_ID = neId;
        FETCH cur_v INTO tid;
        CLOSE cur_v;
        RETURN tid;
    END getNeTidById;

    FUNCTION isLineOdu(neId IN NUMBER, oduId IN NUMBER) RETURN BOOLEAN IS
    BEGIN
        RETURN circuit_util.getMappingOchPFromOdu(neId, oduId) != 0;
    END isLineOdu;
    FUNCTION isPortOdu(neId IN NUMBER, oduId IN NUMBER) RETURN BOOLEAN IS
    BEGIN
        RETURN circuit_util.getMappingFacFromOdu(neId, oduId) != 0;
    END isPortOdu;
    FUNCTION isOdu2Crossconnected(oduId IN NUMBER) RETURN BOOLEAN
    AS
        v_count NUMBER := 0;
    BEGIN
        SELECT count(*) INTO v_count FROM CM_CRS_ODU WHERE CRS_ODU_FROM_ID = oduId OR CRS_ODU_TO_ID = oduId;
        RETURN v_count != 0;
    END isOdu2Crossconnected;
    FUNCTION isOchFacility(ochId IN NUMBER) RETURN BOOLEAN IS
        v_count NUMBER := 0;
    BEGIN
        SELECT count(*) INTO v_count FROM cm_channel_och WHERE och_id = ochId;
        RETURN v_count != 0;
    END isOchFacility;
    FUNCTION isPassthrLink(neId IN NUMBER, ochType IN VARCHAR, eqptOPSMProtId IN NUMBER, eqptSMTMProtId IN NUMBER) RETURN BOOLEAN IS
          cur_v EMS_REF_CURSOR;
          retVal         BOOLEAN;
          neType         VARCHAR(20);
    BEGIN circuit_util.print_start('isPassthrLink');
        retVal:=FALSE;

        --IF eqptOPSMProtId=0 AND eqptSMTMProtId=0 THEN
        IF NVL(eqptOPSMProtId,0)=0 AND NVL(eqptSMTMProtId,0)=0 THEN
           OPEN cur_v FOR SELECT NE_TYPE FROM EMS_NE
              WHERE NE_ID=neId;
           FETCH cur_v INTO neType;
           CLOSE cur_v;

           IF ochType='OCH-P' AND neType LIKE '%OLT%' THEN
              retval:=TRUE;
           ELSIF ochType='OCH-CP' OR ochType='OCH-BP' OR ochType='OCH' THEN
              retval:=TRUE;
           END IF;
        END IF;
        circuit_util.print_end('isPassthrLink');
        RETURN retVal;
    END isPassthrLink;
    FUNCTION getOtherOCHCard(crsFromCard IN number, crsToCard IN number, crsFromId IN number, crsToId IN number, ochId IN NUMBER) RETURN NUMBER IS
        otherCardId    NUMBER;
    BEGIN circuit_util.print_start('getOtherOCHCard');
        IF crsFromId=ochId THEN
           otherCardId:=crsToCard;
        ELSIF crsToId=ochId THEN
           otherCardId:=crsFromCard;
        END IF;
        circuit_util.print_end('getOtherOCHCard');
        RETURN otherCardId;
    END getOtherOCHCard;

    FUNCTION getOtherOCH(crsFromId IN number, crsToId IN number, ochId IN NUMBER) RETURN NUMBER IS
        otherOchId    NUMBER;
    BEGIN circuit_util.print_start('getOtherOCH');
        IF crsFromId=ochId THEN
           otherOchId:=crsToId;
        ELSIF crsToId=ochId THEN
           otherOchId:=crsFromId;
        END IF;
        circuit_util.print_end('getOtherOCH');
        RETURN otherOchId;
    END getOtherOCH;

    FUNCTION getOtherOCHAid(crsFromAid IN VARCHAR, crsToAid IN VARCHAR, crsFromId IN number, crsToId IN number, ochId IN NUMBER) RETURN VARCHAR IS
        otherOchAid VARCHAR(70);
    BEGIN circuit_util.print_start('getOtherOCHAid');
        IF crsFromId=ochId THEN
           otherOchAid:=crsToAid;
        ELSIF crsToId=ochId THEN
           otherOchAid:=crsFromAid;
        END IF;
        circuit_util.print_end('getOtherOCHAid');
        RETURN otherOchAid;
    END getOtherOCHAid;

    FUNCTION getOtherOCHTimeSlot(crsFromId IN number, crsToId IN number, ochId IN NUMBER) RETURN VARCHAR IS
        timeslot    VARCHAR(5);
        otherId     NUMBER;
    BEGIN circuit_util.print_start('getOtherOCHTimeSlot');
        otherId:=getOtherOCH(crsFromId, crsToId, ochId);
        SELECT STS_PORT_OR_LINE INTO timeSlot FROM CM_STS where STS_ID= otherId;
        circuit_util.print_end('getOtherOCHTimeSlot');
        RETURN timeSlot;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN '';
    END getOtherOCHTimeSlot;

    FUNCTION getOtherOCHDirection(crsFromId IN number, crsToId IN number, ochId IN NUMBER) RETURN VARCHAR IS
      direction    VARCHAR(10);
    BEGIN circuit_util.print_start('getOtherOCHDirection');
      IF crsFromId=ochId THEN
         direction:='TO';
      ELSIF crsToId=ochId THEN
         direction:='FROM';
      END IF;
    circuit_util.print_end('getOtherOCHDirection');
      RETURN direction;
    END getOtherOCHDirection;

    FUNCTION getOtherOCHNumber(crsFromId IN number, crsToId IN number, ochId IN NUMBER, numFrom IN NUMBER, numTo IN NUMBER) RETURN NUMBER IS
      retVal    NUMBER;
    BEGIN circuit_util.print_start('getOtherOCHNumber');
      IF crsFromId=ochId THEN
         retVal:=numTo;
      ELSIF crsToId=ochId THEN
         retVal:=numFrom;
      END IF;
      circuit_util.print_end('getOtherOCHNumber');
      RETURN retVal;
    END getOtherOCHNumber;

    FUNCTION getOtherOCHString(crsFromId IN number, crsToId IN number, ochId IN NUMBER,  strFrom IN VARCHAR, strTo IN VARCHAR) RETURN VARCHAR IS
      retVal    VARCHAR(70);
    BEGIN circuit_util.print_start('getOtherOCHString');
      IF crsFromId=ochId THEN
         retVal:=strTo;
      ELSIF crsToId=ochId THEN
         retVal:=strFrom;
      END IF;
      circuit_util.print_end('getOtherOCHString');
      RETURN retVal;
    END getOtherOCHString;

    FUNCTION getCrsPRType(
        facFromId IN NUMBER,facToId IN NUMBER
    ) RETURN VARCHAR IS
          cur_v EMS_REF_CURSOR;
          retVal         VARCHAR(10);
          num            NUMBER;
    BEGIN circuit_util.print_start('getCrsPRType');
        retVal:='primary';

        OPEN cur_v FOR select NE_ID from CM_CRS_ODU where CRS_ODU_FROM_ID = facFromId AND CRS_ODU_TO_ID = facToId;
        FETCH cur_v INTO num;
        IF cur_v%NOTFOUND THEN
         retVal:='secondary';
        END IF;
        CLOSE cur_v;
        circuit_util.print_end('getCrsPRType');
        RETURN retVal;
    END getCrsPRType;
    FUNCTION getDxUsage(omdId IN NUMBER) RETURN VARCHAR IS
        cur_v EMS_REF_CURSOR;
        retVal            VARCHAR2(70);
        aid_type          VARCHAR2(15);
    BEGIN circuit_util.print_start('getDxUsage');
        retVal:='';

        OPEN cur_v FOR
        select dxRcmm.CARD_USAGE, dxRcmm.Card_Aid_Type FROM CM_CARD omd, CM_CARD dxRcmm WHERE omd.CARD_ID=omdId AND omd.CARD_PARENT_ID=dxRcmm.CARD_ID;
        FETCH cur_v INTO retVal, aid_type;
        CLOSE cur_v;

        IF aid_type='DXOADM' THEN
           retVal:='DX';
        END IF;

        circuit_util.print_end('getDxUsage');
        RETURN retVal;
    END getDxUsage;

    FUNCTION getCMMChannel(
      neId NUMBER,        cmmId IN NUMBER,    cardId IN NUMBER,
      fromPort IN NUMBER, toPort IN NUMBER,   cmmAidType VARCHAR2,
      cmmShelf NUMBER,    cmmSlot NUMBER,     band NUMBER
    ) RETURN NUMBER IS
        v_ref_cursor1 EMS_REF_CURSOR;
        channel     NUMBER;
    BEGIN
        IF cmmAidType LIKE 'ECMM%' OR cmmAidType LIKE 'FCMM%' THEN
           channel := (band-1)*8+fromPort;
        ELSIF cmmAidType LIKE 'CCM_R' THEN -- NANO and later
            OPEN v_ref_cursor1 FOR SELECT och_channum FROM cm_channel_och och WHERE och.ne_id=neId AND och_aid LIKE 'OCH-'||cmmShelf||'-'||cmmSlot||'-'||fromPort||'-%';
           FETCH v_ref_cursor1 INTO channel;
           CLOSE v_ref_cursor1;
        ELSE -- case RCMM
           channel := fromPort;
        END IF;
        RETURN channel;
    END getCMMChannel;
    FUNCTION getConnectionSupportingEqpt(cpAid IN VARCHAR2, neId IN NUMBER, ochId IN NUMBER) RETURN VARCHAR IS
        cur_v EMS_REF_CURSOR;
        eqptAid        VARCHAR(70);
    BEGIN circuit_util.print_start('getConnectionSupportingEqpt');
        eqptAid := '';
        OPEN cur_v FOR select CARD_AID
              FROM CM_CARD
              WHERE CARD_AID=cpAid
              AND CM_CARD.NE_ID=neId;
        FETCH cur_v INTO eqptAid;

        IF cur_v%NOTFOUND THEN
           CLOSE cur_v;
           OPEN cur_v FOR select CARD_AID
                 FROM CM_CHANNEL_OCH, CM_CARD
                 WHERE (OCH_TYPE = 'P' OR OCH_TYPE = 'CP' OR OCH_TYPE = 'BP' OR OCH_TYPE = '1')
                 AND CM_CARD.NE_ID=neId
                 AND CM_CHANNEL_OCH.NE_ID=neId
                 AND OCH_ID=ochId
                 AND CARD_ID=OCH_PARENT_ID;
           FETCH cur_v INTO eqptAid;
           CLOSE cur_v;
        END IF;
        circuit_util.print_end('getConnectionSupportingEqpt');
        RETURN eqptAid;
    END getConnectionSupportingEqpt;

    FUNCTION getConnectionEquipmentSide(neId IN NUMBER, ochId IN NUMBER) RETURN VARCHAR IS
          cur_v EMS_REF_CURSOR;
          side        VARCHAR(70);
    BEGIN circuit_util.print_start('getConnectionEquipmentSide');
        side := '';
        -- circuit_util.print_line('getConnectionEquipmentSide Input data:'||ochId||'.');

        /*OPEN cur_v FOR select OCH_DWDMSIDE FROM CM_CHANNEL_OCH
          WHERE OCH_TYPE = 'L' AND OCH_ID=ochId;*/
        OPEN cur_v FOR SELECT case OCH_TYPE 
                              when 'L' then OCH_DWDMSIDE
                              when '1' then OCH_AID
                              else '' end
                       FROM CM_CHANNEL_OCH WHERE OCH_ID=ochId;   
        FETCH cur_v INTO side;
        CLOSE cur_v;

        -- circuit_util.print_line('getConnectionEquipmentSide return:'||side||'.');
       circuit_util.print_end('getConnectionEquipmentSide');
        RETURN side;
    END getConnectionEquipmentSide;

    FUNCTION getConnectionProtection(crsFromId IN NUMBER, crsToId IN NUMBER, ochId IN NUMBER, ochAid IN VARCHAR) RETURN VARCHAR IS
        cur_v EMS_REF_CURSOR;
        retVal   VARCHAR2(70);
        tempId   NUMBER;
    BEGIN circuit_util.print_start('getConnectionProtection');
        IF ochAid LIKE 'OCH-L%' THEN
           retVal:=ochAid;
        ELSIF ochAid LIKE 'OCH-P%' OR ochAid LIKE 'OCH-CP%' OR ochAid LIKE 'OCH-1%' THEN
           IF crsFromId=ochId THEN
              tempId:=crsToId;
           ELSE
              tempId:=crsFromId;
           END IF;

           OPEN cur_v FOR select OCH_AID FROM CM_CHANNEL_OCH WHERE OCH_ID=tempId;
           FETCH cur_v INTO retVal;
           CLOSE cur_v;
        END IF;
        circuit_util.print_end('getConnectionProtection');
        RETURN retVal;
    END getConnectionProtection;
    -- For NANO and later
    FUNCTION getNonforeignWavelengthOCH(neId IN NUMBER, neStype IN VARCHAR, crsId IN NUMBER, cpId IN NUMBER, ccPath IN VARCHAR) RETURN VARCHAR IS
        cur_v             EMS_REF_CURSOR;
        ochAid            VARCHAR2(70);
        ochAidSlot        number;
        ochChanNum        number;
        ochAidShelf       number;
        protOchAid        VARCHAR2(70);
        ochInAID        VARCHAR2(70);
    BEGIN circuit_util.print_start('getNonforeignWavelengthOCH');
        ochAid:='';

        IF neStype = 'CH44_N' THEN
           IF ccPath = 'TRM-TRM' THEN
              OPEN cur_v FOR select och.OCH_AID from CM_CHANNEL_OCH och, CM_FIBR_CONN fibr, CM_CRS crs
                 WHERE och.NE_ID=fibr.NE_ID and fibr.NE_ID=crs.NE_ID
                 and och.OCH_AID_PORT=CONN_FROMPORT and och.OCH_DWDMSIDE=CONN_DWDMSIDE and CONN_TO_ID=cpId and crs.NE_ID=neId;
              FETCH cur_v INTO ochAid;
              CLOSE cur_v;
           ELSE
              OPEN cur_v FOR select och.OCH_AID from CM_CHANNEL_OCH och, CM_FIBR_CONN fibr, CM_CRS crs, CM_CHANNEL_OCH ochp
                 where ochp.NE_ID=och.NE_ID and och.NE_ID=fibr.NE_ID and fibr.NE_ID=crs.NE_ID
                 and och.OCH_AID_PORT=CONN_FROMPORT and och.OCH_DWDMSIDE=CONN_DWDMSIDE and CONN_TO_ID=ochp.OCH_PARENT_ID AND ochp.OCH_ID=crsId and crs.NE_ID=neId;
              FETCH cur_v INTO ochAid;
              CLOSE cur_v;
           END IF;
        ELSIF neStype = 'CH88_N' OR neStype = 'CH88_4D_HCSS' THEN
           IF ccPath != 'CMM-CMM' THEN
              OPEN cur_v FOR SELECT OCH_AID, OCH_AID_SLOT, OCH_CHANNUM, OCH_AID_SHELF FROM cm_channel_och WHERE ne_id = neId AND OCH_ID = crsId AND OCH_AID LIKE 'OCH-L-%';
              FETCH cur_v INTO ochInAID, ochAidSlot, ochChanNum, ochAidShelf;
              CLOSE cur_v;

              -- populate both "other" keys in a protection scenario as both OCH's are dependent
              IF (ochInAID LIKE 'OCH-L-%') THEN
                  OPEN cur_v FOR SELECT OCH_AID FROM cm_channel_och WHERE ne_id = neId AND OCH_AID like  'OCH-' || ochAidShelf || '-' || ochAidSlot || '-%-' || ochChanNum;
                  FETCH cur_v INTO ochAid;
                  CLOSE cur_v;
              ELSE
                  OPEN cur_v FOR SELECT CRS_PROTECTION FROM cm_crs WHERE ne_id = neId AND (crs_from_id = crsId OR crs_to_id = crsId);
                  FETCH cur_v INTO protOchAid;
                  CLOSE cur_v;

                  OPEN cur_v FOR SELECT OCH_AID_SLOT, OCH_CHANNUM, OCH_AID_SHELF FROM cm_channel_och WHERE ne_id = neId AND OCH_AID = protOchAid;
                  FETCH cur_v INTO ochAidSlot, ochChanNum, ochAidShelf;
                  CLOSE cur_v;

                  OPEN cur_v FOR SELECT OCH_AID FROM cm_channel_och WHERE ne_id = neId AND OCH_AID like  'OCH-' || ochAidShelf || '-' || ochAidSlot || '-%-' || ochChanNum;
                  FETCH cur_v INTO ochAid;
                  CLOSE cur_v;
              END IF;

           END IF;
        END IF;
        circuit_util.print_end('getNonforeignWavelengthOCH');
        RETURN ochAid;
    END getNonforeignWavelengthOCH;
    FUNCTION getMultiplexerOCH(neId IN NUMBER, entityId IN NUMBER, ochType IN VARCHAR
    ) RETURN NUMBER IS
        ochId          NUMBER := 0;
    BEGIN circuit_util.print_start('getMultiplexerOCH');
        FOR l_och IN (SELECT two.OCH_ID FROM CM_CHANNEL_OCH one, CM_CHANNEL_OCH two
            WHERE one.OCH_TYPE = 'L' AND two.OCH_AID like ochType||'%' AND two.OCH_CHANNUM=SUBSTR(one.OCH_AID,INSTR(one.OCH_AID,'-',4,5)+1,LENGTH(one.OCH_AID))
              AND one.NE_ID=two.NE_ID AND one.OCH_DWDMSIDE=two.OCH_DWDMSIDE AND two.NE_ID=neId AND one.OCH_ID=entityId
        )LOOP
            ochId := l_och.och_id;
        END LOOP;
        circuit_util.print_end('getMultiplexerOCH');
        RETURN ochId;
    END getMultiplexerOCH;

    FUNCTION getExpressDP(neId IN NUMBER, entityId IN NUMBER
    ) RETURN NUMBER IS
        ochId          NUMBER := 0;
    BEGIN circuit_util.print_start('getExpressDP');
        FOR l_och IN (select two.OCH_ID FROM CM_CHANNEL_OCH one, CM_CHANNEL_OCH two WHERE one.OCH_AID LIKE
            two.OCH_AID||'%' AND two.OCH_TYPE = 'D' AND two.OCH_ID=one.OCH_PARENT_ID  AND one.OCH_ID=entityId
        )LOOP
            ochId := l_och.och_id;
        END LOOP;
        circuit_util.print_end('getExpressDP');
        RETURN ochId;
     END getExpressDP;

    FUNCTION getMappingFacFromOdu(neId IN NUMBER, oduId IN NUMBER) RETURN NUMBER IS
          cur_v EMS_REF_CURSOR;
          facId NUMBER;
    BEGIN
        circuit_util.print_start('getMappingFacFromOdu');
        OPEN cur_v FOR
        SELECT fac.fac_id FROM CM_FACILITY odu, CM_FACILITY fac
            WHERE  odu.fac_id = oduId and fac.ne_id = neId AND fac.fac_id != odu.fac_id AND fac.fac_aid_type NOT LIKE 'ODU%'
            AND fac.fac_aid_shelf = odu.fac_aid_shelf AND fac.fac_aid_slot = odu.fac_aid_slot AND fac.fac_aid_port = odu.fac_aid_port
            AND odu.FAC_AID_STS is null AND fac.FAC_AID_STS is null ;

        FETCH cur_v INTO facId;
        IF cur_v%NOTFOUND THEN
            facId := 0;
        END IF;
        CLOSE cur_v;
        circuit_util.print_end('getMappingFacFromOdu');
        RETURN facId;
    END getMappingFacFromOdu;

    FUNCTION getMappingOduFromFac(neId IN NUMBER, facId IN NUMBER) RETURN NUMBER IS
          cur_v EMS_REF_CURSOR;
          oduId NUMBER;
    BEGIN
        circuit_util.print_start('getMappingOduFromFac');
        OPEN cur_v FOR
        SELECT odu.fac_id FROM CM_FACILITY odu, CM_FACILITY fac
            WHERE  fac.fac_id = facId and odu.ne_id = neId AND fac.fac_id != odu.fac_id AND odu.fac_aid_type LIKE 'ODU%'
            AND fac.fac_aid_shelf = odu.fac_aid_shelf AND fac.fac_aid_slot = odu.fac_aid_slot AND fac.fac_aid_port = odu.fac_aid_port
            AND odu.FAC_AID_STS is null AND fac.FAC_AID_STS is null ;

        FETCH cur_v INTO oduId;
        IF cur_v%NOTFOUND THEN
            oduId := 0;
        END IF;
        CLOSE cur_v;
        circuit_util.print_end('getMappingOduFromFac');
        RETURN oduId;
    END getMappingOduFromFac;

    FUNCTION getMappingOduFromOchP(neId IN NUMBER, ochpId IN NUMBER) RETURN NUMBER IS
        cur_v EMS_REF_CURSOR;
        oduId NUMBER;
    BEGIN
        print_start('getMappingOduFromOchP');
        OPEN cur_v FOR
        SELECT odu.fac_id FROM CM_FACILITY odu, CM_CHANNEL_OCH och
            WHERE  och.och_id = ochpId and odu.ne_id = neId AND odu.fac_aid_shelf = och.och_aid_shelf
            AND odu.fac_aid_slot = och.och_aid_slot AND odu.fac_aid_port = och.och_aid_port AND odu.fac_aid_sts is null;

        FETCH cur_v INTO oduId;
        IF cur_v%NOTFOUND THEN
            oduId := 0;
        END IF;
        CLOSE cur_v;
        print_end('getMappingOduFromOchP');
        RETURN oduId;
    END getMappingOduFromOchP;

    FUNCTION getMappingOchPFromOdu(neId IN NUMBER, oduId IN NUMBER) RETURN NUMBER IS
          cur_v EMS_REF_CURSOR;
          ochpId NUMBER;
    BEGIN
        print_start('getMappingOchPFromOdu');
        OPEN cur_v FOR
        SELECT och_id FROM CM_FACILITY odu, CM_CHANNEL_OCH och
            WHERE  odu.fac_id = oduId and och.ne_id = neId AND odu.fac_aid_shelf = och.och_aid_shelf
            AND odu.fac_aid_slot = och.och_aid_slot AND odu.fac_aid_port = och.och_aid_port AND odu.fac_aid_sts is null;
            --AND odu.fac_aid_slot = och.och_aid_slot AND odu.fac_aid_port = och.och_aid_port;

        FETCH cur_v INTO ochpId;
        IF cur_v%NOTFOUND THEN
            ochpId := 0;
        END IF;
        CLOSE cur_v;
        print_end('getMappingOchPFromOdu');
        RETURN ochpId;
    END getMappingOchPFromOdu;


    /*FUNCTION getMappingOdu2FromOdu1(
        p_ne_id IN NUMBER, p_lower_odu_id IN NUMBER, odu0_tribslot OUT VARCHAR2, odu1_tribslot OUT VARCHAR2, odu2_tribslot OUT VARCHAR2, middle_odu_list OUT V_B_STRING
    ) RETURN NUMBER IS
        v_first BOOLEAN := TRUE;
        v_top_level NUMBER;
        v_lowest_odu NUMBER := 0;
        v_highest_odu NUMBER := 0;
        v_counter NUMBER :=1;
    BEGIN
        print_start('getMappingOdu2FromOdu1');
        print_line('p_ne_id='||p_ne_id||',p_lower_odu_id='||p_lower_odu_id||',odu0_tribslot='||odu0_tribslot||',odu1_tribslot='||odu1_tribslot||',odu2_tribslot='||odu2_tribslot);
        middle_odu_list   := V_B_STRING();
        FOR  l_odu_line IN
        (
         SELECT fac_aid_type, fac_id, fac_tribslot, LEVEL  FROM
         (select fac1.fac_aid_type fac_aid_type, fac1.fac_aid fac_aid, fac1.fac_id fac_id, nvl(fac1.fac_tribslot,0) fac_tribslot
          from cm_facility fac1, cm_facility fac2
          where fac2.fac_id=p_lower_odu_id and fac1.ne_id=p_ne_id and fac2.fac_aid_shelf=fac1.fac_aid_shelf
          and fac2.fac_aid_slot=fac1.fac_aid_slot and fac2.fac_aid_port=fac1.fac_aid_port
          )
            START WITH fac_id=p_lower_odu_id CONNECT BY PRIOR getOduMuxTo( fac_aid )=fac_aid
         --ORDER BY LEVEL ASC
        )LOOP
            v_top_level := l_odu_line.LEVEL;
            IF l_odu_line.fac_aid_type LIKE 'ODU0' THEN
                odu0_tribslot := l_odu_line.fac_tribslot;
            ELSIF l_odu_line.fac_aid_type LIKE 'ODUF' THEN
                odu1_tribslot := l_odu_line.fac_tribslot;
            ELSIF l_odu_line.fac_aid_type LIKE 'ODU1' THEN
                odu1_tribslot := l_odu_line.fac_tribslot;
                --To add ODU1 facility to list when it's used as a mediation between ODU0 and ODU2
                IF v_lowest_odu<>0 AND l_odu_line.fac_id<>0 THEN
                   middle_odu_list.extend;
                   middle_odu_list(v_counter) := l_odu_line.fac_id;
                   v_counter := v_counter+1;
                END IF;
            ELSIF l_odu_line.fac_aid_type LIKE 'ODU2' THEN
                odu2_tribslot := l_odu_line.fac_tribslot;
            --ELSIF l_odu_line.fac_aid_type LIKE 'ODU3' THEN
                --g_odu3_tribslot := l_odu_line.fac_tribslot;
            END IF;
            IF v_first THEN
                v_first := FALSE;
                v_lowest_odu := l_odu_line.fac_id;
            ELSE
                v_highest_odu := l_odu_line.fac_id;
            END IF;
        END LOOP;

        --IF v_highest_odu = 0 THEN
          --  timeSlot := 0;
        --END IF;
        print_end('getMappingOdu2FromOdu1');
        RETURN v_highest_odu;
     END getMappingOdu2FromOdu1; */

     FUNCTION getTopMappingOduFromLower(
        p_ne_id IN NUMBER, p_lower_odu_id IN NUMBER, odu_mapping_list OUT V_B_STRING, odu_mapping_type_list OUT V_B_STRING, odu_mapping_tribslot_list OUT V_B_STRING
    ) RETURN NUMBER IS
        v_highest_odu NUMBER := 0;
        v_counter NUMBER :=1;
    BEGIN
        print_start('getTopMappingOduFromLower');
        print_line('p_ne_id='||p_ne_id||',p_lower_odu_id='||p_lower_odu_id);
        odu_mapping_list   := V_B_STRING();
        odu_mapping_type_list := V_B_STRING();
        odu_mapping_tribslot_list := V_B_STRING();
        v_highest_odu := 0;
        FOR  l_odu_line IN
        (
         SELECT fac_aid_type, fac_id, fac_tribslot, LEVEL  FROM
          (select fac1.fac_aid_type fac_aid_type, fac1.fac_aid fac_aid, fac1.fac_id fac_id, fac1.fac_tribslot --nvl(fac1.fac_tribslot,0) fac_tribslot
          from cm_facility fac1, cm_facility fac2
          where fac2.fac_id=p_lower_odu_id and fac1.ne_id=p_ne_id and fac2.fac_aid_shelf=fac1.fac_aid_shelf
          and fac2.fac_aid_slot=fac1.fac_aid_slot and fac2.fac_aid_port=fac1.fac_aid_port
          and fac2.fac_aid_type like 'ODU%' and fac1.fac_aid_type like 'ODU%'
          )
            START WITH fac_id=p_lower_odu_id CONNECT BY isOduMuxTo(fac_aid, PRIOR fac_aid)>0
        )LOOP
           odu_mapping_list.extend;
           odu_mapping_type_list.extend;
           odu_mapping_tribslot_list.extend;
           odu_mapping_list(v_counter) := l_odu_line.fac_id;
           odu_mapping_type_list(v_counter) := l_odu_line.fac_aid_type;
           odu_mapping_tribslot_list(v_counter) := l_odu_line.fac_tribslot;
           v_counter := v_counter+1;
           v_highest_odu := l_odu_line.fac_id;
        END LOOP;
        /*if v_highest_odu = p_lower_odu_id then
          v_highest_odu := 0;
        end if;*/
        print_end('getTopMappingOduFromLower');
        RETURN v_highest_odu;
     END getTopMappingOduFromLower;

     PROCEDURE tribslotToTable(str in varchar2, tokens out nocopy facTribSlotTable) IS
     BEGIN
        select DISTINCT REGEXP_SUBSTR (txt, '[^&]+', 1, level)
        bulk collect into tokens
        from (select str as txt from dual)
        connect by level <= length(regexp_replace(txt,'[^&]+'))+1;
     END tribslotToTable;

     FUNCTION getBottomMappingOduFromHigher(
        v_ne_id IN NUMBER, v_higer_odu_id IN NUMBER, odu_mapping_tribslot_list IN V_B_STRING, middle_odu_list OUT V_B_STRING
    ) RETURN NUMBER IS
        bottomOdu NUMBER;
        bottomOduAid CM_FACILITY.FAC_AID%TYPE;
        curOdu NUMBER;
        curOduAid CM_FACILITY.FAC_AID%TYPE;
        temp_tribslot   cm_facility.fac_tribslot%type;
        bottom_tribslot cm_facility.fac_tribslot%type;
        bottom_tribslot_tab facTribSlotTable;
        oduCur EMS_REF_CURSOR;
        type odu_t is record(
          fac_id cm_facility.fac_id%type,
          fac_aid cm_facility.fac_aid%type,
          fac_tribslot cm_facility.fac_tribslot%type
        );
        type odu_list_t is table of odu_t;
        odu_list odu_list_t;
    BEGIN
        print_start('getBottomMappingOduFromHigher');
        middle_odu_list := V_B_STRING();
        bottomOdu := 0;
        IF odu_mapping_tribslot_list IS NOT NULL AND odu_mapping_tribslot_list.COUNT >1 THEN
            --bottom_tribslot := odu_mapping_tribslot_list(odu_mapping_tribslot_list.COUNT);
            for i in odu_mapping_tribslot_list.FIRST..odu_mapping_tribslot_list.LAST
            loop
                if odu_mapping_tribslot_list(i) is not null AND odu_mapping_tribslot_list(i)<>'0' then
                   bottom_tribslot := odu_mapping_tribslot_list(i);
                end if;
                exit when bottom_tribslot is not null;
            end loop;

            open oduCur for SELECT l.fac_id, l.fac_aid, l.fac_tribslot FROM CM_FACILITY l, CM_FACILITY h
                            WHERE h.ne_id = v_ne_id AND h.fac_id = v_higer_odu_id AND l.ne_id = v_ne_id
                            AND l.fac_aid_shelf = h.fac_aid_shelf AND l.fac_aid_slot = h.fac_aid_slot AND l.fac_aid_port = h.fac_aid_port
                            AND l.fac_aid_type like 'ODU%';
            fetch oduCur bulk collect into odu_list;
            if odu_list.COUNT>0 then
              -- find the bottom odu with the same tribslot
               for i in odu_list.first..odu_list.last
               loop
                 if odu_list(i).fac_tribslot=bottom_tribslot then
                    bottomOdu:=odu_list(i).fac_id;
                    bottomOduAid:=odu_list(i).fac_aid;
                 end if;
                 exit when bottomOdu<>0;
               end loop;

               -- if no bottom odu with the exact tribslot, search for its upper layer odu
               if bottomOdu=0 then
                   tribslotToTable(bottom_tribslot, bottom_tribslot_tab);
                   for i in odu_list.first..odu_list.last
                   loop
                     if odu_list(i).fac_tribslot is not null then
                        if( (temp_tribslot is null) or
                            (temp_tribslot is not null and length(odu_list(i).fac_tribslot)<length(temp_tribslot))
                          )
                        then
                           if isTribslotSubsetOf(odu_list(i).fac_tribslot,bottom_tribslot_tab) then
                              bottomOdu:=odu_list(i).fac_id;
                              bottomOduAid:=odu_list(i).fac_aid;
                              temp_tribslot:=odu_list(i).fac_tribslot;
                           end if;
                        end if;
                     end if;
                   end loop;
               end if;

               -- find the middle odu from bottom odu
               if bottomOdu<>0 then
                  curOduAid := bottomOduAid;
                  curOdu := 0;
                  while curOdu <> v_higer_odu_id
                  loop
                    curOdu := 0;
                    for i in odu_list.first..odu_list.last
                    loop
                        if isOduMuxTo(odu_list(i).fac_aid, curOduAid) >0 then
                           curOduAid := odu_list(i).fac_aid;
                           curOdu := odu_list(i).fac_id;
                           middle_odu_list.extend;
                           middle_odu_list(middle_odu_list.count) := curOdu;
                           goto for_loop_end;
                        end if;
                    end loop;
                    <<for_loop_end>>
                    exit when curOdu=0;
                  end loop;
               end if;
            end if;
            close oduCur;

        END IF;
        print_end('getBottomMappingOduFromHigher');
        RETURN bottomOdu;
    END getBottomMappingOduFromHigher;

    /*FUNCTION getMappingOdu1FromOdu2(
        v_ne_id IN NUMBER, v_odu2_id IN NUMBER, v_odu0_tribslot IN VARCHAR2,
        v_odu1_tribslot IN VARCHAR2, middle_odu_list OUT V_B_STRING
    ) RETURN NUMBER IS
        v_ref_cursor1 EMS_REF_CURSOR;
        odu1Id NUMBER;
        odu0Id NUMBER;
        lowerOdu NUMBER;
        v_counter NUMBER :=1;
    BEGIN
        print_start('getMappingOdu1FromOdu2');
        print_line('v_ne_id='||v_ne_id||',v_odu2_id='||v_odu2_id||',v_odu0_tribslot='||v_odu0_tribslot||',v_odu1_tribslot='||v_odu1_tribslot);
        middle_odu_list := V_B_STRING();
        IF v_odu0_tribslot IS NOT NULL THEN
            OPEN v_ref_cursor1 FOR
            SELECT nvl(odu0.fac_id,0), nvl(odu1.fac_id,0) FROM CM_FACILITY odu1, CM_FACILITY odu2, cm_facility odu0
              WHERE odu1.ne_id = v_ne_id AND odu2.fac_id = v_odu2_id and odu2.fac_aid_shelf=odu1.fac_aid_shelf AND odu2.fac_aid_slot=odu1.fac_aid_slot AND odu2.fac_aid_port=odu1.fac_aid_port AND odu1.fac_tribslot = v_odu1_tribslot
              AND odu0.ne_id = v_ne_id AND odu2.fac_aid_shelf = odu0.fac_aid_shelf AND odu2.fac_aid_slot=odu0.fac_aid_slot AND odu2.fac_aid_port=odu0.fac_aid_port AND odu1.fac_aid_sts=odu0.fac_aid_sts-100 AND odu0.fac_tribslot = v_odu0_tribslot;
            FETCH v_ref_cursor1 INTO odu0Id, odu1Id;
            IF v_ref_cursor1%NOTFOUND THEN
               lowerOdu := 0;
            ELSE
               lowerOdu := odu0Id;
               IF odu1Id<>0 THEN
                  middle_odu_list.extend;
                  middle_odu_list(v_counter) := odu1Id;
                  v_counter := v_counter+1;
               END IF;
            END IF;
            CLOSE v_ref_cursor1;
        ELSE
            OPEN v_ref_cursor1 FOR
            SELECT nvl(odu1.fac_id,0) FROM CM_FACILITY odu1, CM_FACILITY odu2
              WHERE odu1.ne_id = v_ne_id AND odu2.fac_id = v_odu2_id AND odu1.fac_tribslot = v_odu1_tribslot
              and odu2.fac_aid_shelf = odu1.fac_aid_shelf and  odu2.fac_aid_slot = odu1.fac_aid_slot and odu2.fac_aid_port = odu1.fac_aid_port;
            FETCH v_ref_cursor1 INTO odu1Id;
            IF v_ref_cursor1%NOTFOUND THEN
               lowerOdu := 0;
            ELSE
               lowerOdu := odu1Id;
            END IF;
            CLOSE v_ref_cursor1;
        END IF;
        print_end('getMappingOdu1FromOdu2');
        RETURN lowerOdu;
    END getMappingOdu1FromOdu2; */

    --@Deprecated
    --@Replaced by isOduMuxTo
    --@Because ODU AId became too complicated from NE FP9.0
    /*FUNCTION getOduMuxTo( oduAid IN VARCHAR) RETURN VARCHAR IS
             aid_type     VARCHAR2(12);
             aid_shelf    VARCHAR2(3);
             aid_slot     VARCHAR2(3);
             aid_port     VARCHAR2(3);
             aid_sts      VARCHAR2(5);
             aid_tmp      VARCHAR2(30);
    BEGIN
            aid_tmp := oduAid;
            aid_type := substr( aid_tmp, 1, instr( aid_tmp,'-' )-1 );
            aid_tmp := substr( aid_tmp, instr( aid_tmp,'-' )+1 );

            aid_shelf := substr( aid_tmp, 1, instr( aid_tmp,'-' )-1 );
            aid_tmp := substr( aid_tmp, instrc( aid_tmp,'-' )+1 );

            aid_slot := substr( aid_tmp, 1, instr( aid_tmp,'-' )-1 );
            aid_tmp := substr( aid_tmp, instr( aid_tmp,'-' )+1 );

            aid_port := substr( aid_tmp, 1, instr( aid_tmp,'-' )-1 );
            aid_tmp := substr( aid_tmp, instr( aid_tmp,'-' )+1 );

            if instr( aid_tmp,'-' )>0 then
               aid_sts := substr( aid_tmp, 1, instr( aid_tmp,'-' )-1 );
            else
               aid_sts := aid_tmp;
            end if;

            if aid_type = 'ODU1' OR aid_type = 'ODUF' then
               aid_type := 'ODU2';
            elsif aid_type = 'ODU0' then
               if aid_sts like 'A%' then
                  aid_type := 'ODU1';
                  aid_sts := substr(aid_sts, 2);
               else
                  aid_type := 'ODU2';
               end if;
            elsif aid_type = 'ODU2' then
               IF aid_sts is not null then
                  aid_type := 'ODU4';
               ELSE
                  RETURN '';
               end if;
            end if;

            aid_tmp := aid_type||'-'||aid_shelf||'-'||aid_slot||'-'||aid_port;
            if aid_type = 'ODU1' and aid_sts is not null then
               aid_tmp := aid_tmp || '-' || aid_sts;
            end if;

            RETURN aid_tmp;
    END getOduMuxTo; */

    FUNCTION getOduMuxNum( oduAid IN VARCHAR) RETURN VARCHAR IS
             aid_shelf    VARCHAR2(3);
             aid_slot     VARCHAR2(3);
             aid_port     VARCHAR2(3);
             aid_sts      VARCHAR2(5);
             aid_tmp      VARCHAR2(50);
    BEGIN
            --print_line('ODU AID = '||oduAid);
            aid_tmp := oduAid;
            aid_tmp := substr( aid_tmp, instr( aid_tmp,'-' )+1 );

            aid_shelf := substr( aid_tmp, 1, instr( aid_tmp,'-' )-1 );
            aid_tmp := substr( aid_tmp, instrc( aid_tmp,'-' )+1 );

            aid_slot := substr( aid_tmp, 1, instr( aid_tmp,'-' )-1 );
            aid_tmp := substr( aid_tmp, instr( aid_tmp,'-' )+1 );

            if instr( aid_tmp,'-' )>0 then
               aid_port := substr( aid_tmp, 1, instr( aid_tmp,'-' )-1 );
               aid_tmp := substr( aid_tmp, instr( aid_tmp,'-' )+1 );
            else
               return '';
            end if;

            if instr( aid_tmp,'-' )>0 then
               aid_sts := substr( aid_tmp, 1, instr( aid_tmp,'-' )-1 );
            else
               aid_sts := '';
            end if;

            if aid_sts like 'A%' or aid_sts like 'B%' or aid_sts like 'C%' then
              aid_sts := substr(aid_sts, 2);
            end if;

            aid_tmp := aid_shelf||'-'||aid_slot||'-'||aid_port;
            if aid_sts is not null then
              aid_tmp := aid_tmp||'-'||aid_sts;
            end if;
            --print_line('RETURN MUX ODU NUM = '||aid_tmp);
            RETURN aid_tmp;
    END getOduMuxNum;

    FUNCTION trimAidType(facAid IN VARCHAR2 ) RETURN VARCHAR2 IS
    BEGIN
       RETURN substr( facAid, instr( facAid,'-' )+1 );
    END trimAidType;

    FUNCTION isOduMuxTo(highOduAid IN VARCHAR, lowOduAid IN VARCHAR) RETURN NUMBER IS
    BEGIN
      if trimAidType(highOduAid) = getOduMuxNum(lowOduAid) then
        return 1;
      else
        return 0;
      end if;
    END isOduMuxTo;

    FUNCTION isTribslotSubsetOf( highTribSlot IN VARCHAR, lowTribSlotTab IN facTribSlotTable) RETURN BOOLEAN IS
      highTribSlotTab facTribSlotTable;
    BEGIN
      tribslotToTable( highTribSlot, highTribSlotTab );
      return lowTribSlotTab submultiset of highTribSlotTab;
    END;

    FUNCTION getOTNMXCedLineFacility(timeslots IN VARCHAR, neId IN NUMBER, cardAID IN VARCHAR) RETURN VARCHAR IS
        v_max_time_slot          PLS_INTEGER;
        odu1Port        VARCHAR(1);
        baseVcNumber   NUMBER;
        tmp_aid         VARCHAR(100);
    BEGIN circuit_util.print_start('getOTNMXCedLineFacility');
        IF cardAID  LIKE 'ODU1-C%' THEN
            tmp_aid:=cardAID;
            WHILE instr(tmp_aid,'&')>0 LOOP
                tmp_aid:=SUBSTR(tmp_aid, instr(tmp_aid,'&')+1);
            END LOOP;
            RETURN tmp_aid;
        END IF;
        SELECT substr(timeslots, instr(timeslots, '&', -1) +1) INTO v_max_time_slot FROM dual;
        baseVcNumber := circuit_util.getVcNumberingBase(neId);
        odu1Port := ceil(v_max_time_slot / baseVcNumber);
        circuit_util.print_end('getOTNMXCedLineFacility');
        IF (INSTR(cardAID,'OTNMD') > 0) THEN
            RETURN 'ODU1-C' || SubStr(cardAID,INSTR(cardAID,'-'), INSTR(cardAID,'-')) || '-' ||  odu1Port;
        ELSE
            RETURN 'ODU1-C' || SubStr(cardAID,INSTR(cardAID,'-'), INSTR(SubStr(cardAID,INSTR(cardAID,'-')),'-',1,3)) || odu1Port;
        END IF;
    END getOTNMXCedLineFacility;

    FUNCTION getOTNMXCedAllLineFacility(timeslots IN VARCHAR, neId IN NUMBER, cardID IN NUMBER, cardAID IN VARCHAR) RETURN VARCHAR IS
          TYPE StringTable IS TABLE OF CHAR(1) INDEX BY BINARY_INTEGER;
          l_idx1          PLS_INTEGER;
          odu1Port        PLS_INTEGER;
          v_timeslot_string VARCHAR2(800);
          v_odu1c_fac_list StringTable;
          v_odu1c_fac_string VARCHAR2(200);
          v_baseVcNumber   PLS_INTEGER;
          v_non_last_slot BOOLEAN := TRUE;
          v_timeSlot PLS_INTEGER;
          v_first BOOLEAN := TRUE;
    BEGIN circuit_util.print_start('getOTNMXCedAllLineFacility');
        v_baseVcNumber := circuit_util.getVcNumberingBase(neId);
        v_timeslot_string := timeslots;
        WHILE v_non_last_slot LOOP
            l_idx1 := INSTR(v_timeslot_string,'&');
            IF l_idx1 > 0 THEN
                v_timeSlot := substr( v_timeslot_string, 0, l_idx1-1);
                v_timeslot_string := SUBSTR(v_timeslot_string, l_idx1 + 1);
            ELSE
                v_timeSlot := v_timeslot_string;
                v_non_last_slot := FALSE;
            END IF;
            odu1Port := ceil(v_timeSlot / v_baseVcNumber);
            IF NOT v_odu1c_fac_list.EXISTS(odu1Port) THEN
                v_odu1c_fac_list(odu1Port) := 'X';
                IF v_first THEN
                    v_odu1c_fac_string := v_odu1c_fac_string || 'ODU1-C' || SubStr(cardAID,INSTR(cardAID,'-')) || '-' || odu1Port;
                ELSE
                    v_odu1c_fac_string := v_odu1c_fac_string || '&' || 'ODU1-C' || SubStr(cardAID,INSTR(cardAID,'-')) || '-' || odu1Port;
                END IF;
                v_first := FALSE;
            END IF;
        END LOOP;
        circuit_util.print_end('getOTNMXCedAllLineFacility');
        RETURN v_odu1c_fac_string;  --v_Return = ODU1-C-2-10-1 &ODU1-C-2-10-2
    END getOTNMXCedAllLineFacility;

    -- Handles scenario for both OPSM working and SMTM UPSR/SNCPRING/DPRING Working/Protecting
    FUNCTION determineConnectionWorkOrProt(ccType VARCHAR, fromCardId IN NUMBER, toCardId IN NUMBER,
                                           fromOch IN NUMBER, toOch IN NUMBER) RETURN VARCHAR IS
        cur_v             EMS_REF_CURSOR;
        workOrProt        VARCHAR(1);
        cardAid           VARCHAR(20);
    BEGIN circuit_util.print_start('determineConnectionWorkOrProt');
        workOrProt:='';

        IF ccType LIKE '%WAYBR%' OR ccType LIKE '%WAYPR%' THEN -- handle OPSM working crs only
           workOrProt:='W';
        ELSE -- handle SMTM UPSR/SNCPRING/DPRING working/protecting crs

             OPEN cur_v FOR SELECT WORK_OR_PROT, card_Aid FROM SMTM_PROTECTION_CM_VW
                WHERE (CARD_ID=fromCardId OR CARD_ID=toCardId) AND (/*PROT_SCHEME='UPSR' OR PROT_SCHEME='SNCPRING' OR*/PROT_SCHEME='DPRING'); -- include UPSR during STS impl.
             FETCH cur_v INTO workOrProt, cardAid;
             CLOSE cur_v;

             IF cardAid LIKE 'HDTG%' THEN
              OPEN cur_v FOR SELECT case when o.workingid=fromOch then 'W' when o.protectionid=fromOch then 'P' end FROM och_cm_vw o
                WHERE o.id=fromOch and o.OCH_TYPE='P' and o.scheme='DPRING'
                UNION
                SELECT case when o.workingid=toOch then 'W' when o.protectionid=toOch then 'P' end FROM och_cm_vw o
                WHERE o.id=toOch and o.OCH_TYPE='P' and o.scheme='DPRING';
               FETCH cur_v INTO workOrProt;
              CLOSE cur_v;
             END IF;

        END IF;
        circuit_util.print_end('determineConnectionWorkOrProt');
        RETURN workOrProt;
    END determineConnectionWorkOrProt;
    FUNCTION generateOLAOLUccPath(neType IN VARCHAR) RETURN VARCHAR IS
          ccPath        VARCHAR(70);
    BEGIN circuit_util.print_start('generateOLAOLUccPath');
        IF neType LIKE '%OLA%' THEN
           ccPath := 'OLA';
        ELSIF neType LIKE '%OLU%' THEN
           ccPath := 'OLU';
        END IF;
        circuit_util.print_end('generateOLAOLUccPath');
        RETURN ccPath;
    END generateOLAOLUccPath;

    FUNCTION convertTimeslotVC4ToNonVC4(timeSlot IN VARCHAR) RETURN VARCHAR IS
        convertedSts1Map   VARCHAR2(800);
        convertedTimeSlot VARCHAR2(4);
        v_start         NUMBER := 1;
        v_end           NUMBER := 1;
        v_first BOOLEAN := TRUE;
    BEGIN
        IF 0 = INSTR(timeSlot,'&') THEN
            RETURN (to_number(timeSlot) * 3) - 2;
        END IF;
        LOOP
        v_end := INSTR(timeSlot,'&',v_start);
        IF v_end > 0 THEN
            convertedTimeSlot := substr( timeSlot, v_start, v_end-v_start);
            IF v_first THEN
                convertedSts1Map := (to_number(convertedTimeSlot) * 3 - 2);
            ELSE
                convertedSts1Map := convertedSts1Map || '&' || (to_number(convertedTimeSlot) * 3 - 2);
            END IF;
        ELSE
            convertedTimeSlot := substr(timeSlot, v_start);
            IF v_first THEN
                convertedSts1Map := (to_number(convertedTimeSlot) * 3) - 2;
            ELSE
                convertedSts1Map := convertedSts1Map || '&' || (to_number(convertedTimeSlot) * 3 - 2);
            END IF;
            EXIT;
        END IF;
        v_start := v_end + 1;
        v_first := FALSE;
        END LOOP;
        RETURN convertedSts1Map;
    END convertTimeslotVC4ToNonVC4;

    FUNCTION convertTimeslotNonVC4ToVC4(timeSlot IN VARCHAR) RETURN VARCHAR IS
        convertedSts1Map   VARCHAR(800);
        convertedTimeSlot VARCHAR(800);
        timeslotList      IntTable;
        timeslotsString   VARCHAR(800);
        l_idx1          PLS_INTEGER;
        l_idx2          PLS_INTEGER;
    BEGIN circuit_util.print_start('convertTimeslotNonVC4ToVC4');
        timeslotsString := timeSlot;
        l_idx2 := 0;
        LOOP
          l_idx1 := INSTR(timeslotsString,'&');
          IF l_idx1 > 0 THEN
              timeslotList(l_idx2) := substr( timeslotsString, 0, l_idx1-1);
              timeslotsString := SUBSTR(timeslotsString,l_idx1+LENGTH('&'));
          ELSE
              timeslotList(l_idx2) := timeslotsString;
              EXIT;
          END IF;
          l_idx2 := l_idx2 + 1;
        END LOOP;

        convertedSts1Map := 0;
        FOR i IN 0..timeslotList.COUNT-1 LOOP
            convertedTimeSlot := (timeslotList(i) + 2);
            IF(convertedTimeSlot mod 3 = 0) THEN
                convertedTimeSlot := convertedTimeSlot/3;
                IF convertedTimeSlot <> 0 THEN
                    IF convertedSts1Map = '0' THEN
                        convertedSts1Map := convertedTimeSlot;
                    ELSE
                        convertedSts1Map := convertedSts1Map || '&' || convertedTimeSlot;
                    END IF;
                END IF;
            END IF;
        END LOOP;
        circuit_util.print_end('convertTimeslotNonVC4ToVC4');
        RETURN convertedSts1Map;
    END convertTimeslotNonVC4ToVC4;

    FUNCTION convertTimeslotToVC4(fromNeId IN NUMBER, toNeId IN NUMBER, timeslot IN VARCHAR) RETURN VARCHAR IS
        cur_v              EMS_REF_CURSOR;
        fromNeVer         VARCHAR2(30);
        fromNeStsVcMde     VARCHAR2(10);
        toNeVer           VARCHAR2(30);
        toNeStsVcMde       VARCHAR2(10);
        convertedToSlot   VARCHAR2(800);
    BEGIN circuit_util.print_start('convertTimeslotToVC4');
        convertedToSlot := timeslot;
        OPEN cur_v FOR select SW_VER, NE_STSVCMDE
        FROM EMS_NE, CM_SW
        WHERE EMS_NE.NE_ID = fromNeId AND CM_SW.NE_ID = fromNeId;
        FETCH cur_v INTO fromNeVer, fromNeStsVcMde;

        IF cur_v%NOTFOUND THEN
          --circuit_util.print_line('NE not found: '||fromNeId||' is not in EMS_NE.');
            RETURN convertedToSlot;
        END IF;

      -- is in VC mode
        IF fromNeStsVcMde <> 'VC' THEN
            RETURN convertedToSlot;
        END IF;

        OPEN cur_v FOR select SW_VER, NE_STSVCMDE
        FROM EMS_NE, CM_SW
        WHERE EMS_NE.NE_ID = toNeId AND CM_SW.NE_ID = toNeId;
        FETCH cur_v INTO toNeVer, toNeStsVcMde;
        CLOSE cur_v;

        -- is in VC mode
        IF toNeStsVcMde <> 'VC' THEN
            RETURN convertedToSlot;
        END IF;

        -- FP5.1.1 and above
        IF compareVersion(fromNeVer, '5.1.1') >= 0 THEN
            IF compareVersion(toNeVer, '5.1.1') < 0 THEN
              convertedToSlot:= convertTimeslotVC4ToNonVC4(convertedToSlot);
            END IF;
        ELSE
            IF compareVersion(toNeVer, '5.1.1') >= 0 THEN
              convertedToSlot:= convertTimeslotNonVC4ToVC4(convertedToSlot);
            END IF;
        END IF;
        circuit_util.print_end('convertTimeslotToVC4');
        RETURN convertedToSlot;
    END convertTimeslotToVC4;

    FUNCTION constructLinkInfo(
        fromNeId IN NUMBER, toNeId IN NUMBER, fromOchDP IN VARCHAR,
        toOchDP IN VARCHAR, fromSide IN VARCHAR, toSide IN VARCHAR,
        xcchanNum IN NUMBER, g_delimiter CHAR
    ) RETURN VARCHAR2 AS
        linkInfo VARCHAR2(1000);
        slotFrom NUMBER;
        slotTo   NUMBER;
        tempStr  VARCHAR2(20);
    BEGIN
        tempStr := SUBSTR(fromOchDP, INSTR(fromOchDP,'-',1,2)+1);
        tempStr := SUBSTR(tempStr, 1,INSTR(tempStr,'-',1)-1);
        slotFrom := to_number(tempStr);

        tempStr := SUBSTR(toOchDP, INSTR(toOchDP,'-',1,2)+1);
        tempStr := SUBSTR(tempStr, 1,INSTR(tempStr,'-',1)-1);
        slotTo := to_number(tempStr);

        circuit_util.print_line('Add Composite Link:'||fromNeId||', '||fromOchDP||', '||fromSide||', '||toNeId||', '||toOchDP||', '||toSide||', '||xcchanNum);

        IF slotFrom<slotTo THEN
            linkInfo:=to_char(fromNeId)||g_delimiter||to_char(toNeId)||g_delimiter||fromOchDP||g_delimiter||toOchDP||g_delimiter||nvl(fromSide, ' ')||g_delimiter||nvl(toSide, ' ')||g_delimiter||to_char(nvl(xcchanNum,0));
        ELSE
            linkInfo:=to_char(toNeId)||g_delimiter||to_char(fromNeId)||g_delimiter||toOchDP||g_delimiter||fromOchDP||g_delimiter||nvl(toSide, ' ')||g_delimiter||nvl(fromSide, ' ')||g_delimiter||to_char(nvl(xcchanNum,0));
        END IF;
        linkInfo := linkInfo||g_delimiter||'COMPOSITELINK';
        RETURN linkInfo;
    END constructLinkInfo;

    FUNCTION getOduLayer(oduAid IN VARCHAR) RETURN PLS_INTEGER IS
        oduLayer PLS_INTEGER := 0;
    BEGIN circuit_util.print_start('getOduLayer');
        IF (oduAid LIKE 'ODU0%') THEN
            oduLayer := 0;
        ELSIF (oduAid LIKE 'ODU1%') OR (oduAid LIKE 'ODUF%') THEN
            oduLayer := 1;
        ELSIF (oduAid LIKE 'ODU2%') THEN
            oduLayer := 2;
        ELSIF (oduAid LIKE 'ODU3%') THEN
            oduLayer := 3;
        ELSIF (oduAid LIKE 'ODU4%') THEN
            oduLayer := 4;
        ELSIF (oduAid LIKE 'ODU%') THEN
            oduLayer := 99;
        ELSE
            oduLayer := -1;
        END IF;
        --circuit_util.print_end('getOduLayer');
        RETURN oduLayer;
    END getOduLayer;
END circuit_util;
/
create or replace
PACKAGE circuit_retrieval AS
    PROCEDURE getFacilityInfo(
        idList               IN V_B_STRING,
        o_aidList               OUT NOCOPY V_B_STRING, o_extConnectivityList  OUT NOCOPY V_B_STRING, o_editablePrimaryStateList OUT NOCOPY V_B_STRING,
        o_connectedToList       OUT NOCOPY V_B_STRING, o_attAdjModeList       OUT NOCOPY V_B_STRING, o_otuMappingList           OUT NOCOPY V_B_STRING,
        o_otuExpTrcList         OUT NOCOPY V_B_STRING, o_otuTrcList           OUT NOCOPY V_B_STRING, o_otuMonTrcList            OUT NOCOPY V_B_STRING,
        o_protFunctionList      OUT NOCOPY V_B_STRING, o_fecTypeList          OUT NOCOPY V_B_STRING, o_sdThreshList             OUT NOCOPY V_B_STRING,
        o_holdOffProtList       OUT NOCOPY V_B_STRING, o_neIdList             OUT NOCOPY V_B_STRING, o_facilityTypeList         OUT NOCOPY V_B_STRING,
        o_alarmProfileList      OUT NOCOPY V_B_STRING, o_IdList               OUT NOCOPY V_B_STRING, o_pmModeList               OUT NOCOPY V_B_STRING,
        o_tcaModeList           OUT NOCOPY V_B_STRING, o_expRateList          OUT NOCOPY V_B_STRING, o_transMapList             OUT NOCOPY V_B_STRING,
        o_schdPMList            OUT NOCOPY V_B_STRING, o_protList             OUT NOCOPY V_B_STRING, o_maintPropList            OUT NOCOPY V_B_STRING,
        o_oeoRegenList          OUT NOCOPY V_B_STRING, o_transparentList      OUT NOCOPY V_B_STRING, o_sts1MapList              OUT NOCOPY V_B_TEXT,
        o_parentFacilityKeyList OUT NOCOPY V_B_STRING, o_childFacilityKeyList OUT NOCOPY V_B_STRING, o_nvalueList               OUT NOCOPY V_B_STRING,
        o_sigTypeList           OUT NOCOPY V_B_STRING, o_npOwnerList          OUT NOCOPY V_B_STRING, o_secondaryStateList       OUT NOCOPY V_B_STRING,
        o_lineOrPortList        OUT NOCOPY V_B_STRING, o_ccPathList           OUT NOCOPY V_B_STRING, o_autoCfgList              OUT NOCOPY V_B_STRING,
        o_vcatList              OUT NOCOPY V_B_STRING, o_clockTypeList        OUT NOCOPY V_B_STRING, o_associatedKeyList        OUT NOCOPY V_B_STRING,
        o_schdInhModeList       OUT NOCOPY V_B_STRING, o_protSchemeList       OUT NOCOPY V_B_STRING, o_protectFacAidList        OUT NOCOPY V_B_STRING
    );
    PROCEDURE getEquipmentInfo(
        idList               IN V_B_STRING,
        o_aidList            OUT NOCOPY V_B_STRING,  o_editablePrimaryStateList OUT NOCOPY V_B_STRING,  o_alarmProfileList   OUT NOCOPY V_B_STRING,
        o_noOfPortsList      OUT NOCOPY V_B_STRING,  o_channelList              OUT NOCOPY V_B_STRING,  o_halfBandList       OUT NOCOPY V_B_STRING,
        o_timingModeList     OUT NOCOPY V_B_STRING,  o_rateList                 OUT NOCOPY V_B_STRING,  o_neIdList           OUT NOCOPY V_B_STRING,
        o_IdList             OUT NOCOPY V_B_STRING,  o_pmModeList               OUT NOCOPY V_B_STRING,  o_ochFacilityList    OUT NOCOPY V_B_STRING,
        o_portfacilityList   OUT NOCOPY V_B_STRING,  o_tcaModeList              OUT NOCOPY V_B_STRING,  o_schdPMList         OUT NOCOPY V_B_STRING,
        o_plugModuleList     OUT NOCOPY V_B_STRING,  o_shelfIdList              OUT NOCOPY V_B_STRING,  o_schdInhModeList    OUT NOCOPY V_B_STRING
    );
    PROCEDURE getFFPInfo(
        fromIdList             IN V_B_STRING,         toIdList                 IN V_B_STRING,
        o_neIdList             OUT NOCOPY V_B_STRING, o_typeList               OUT NOCOPY V_B_STRING,   o_rvtrvList              OUT NOCOPY V_B_STRING,
        o_schemeList           OUT NOCOPY V_B_STRING, o_fromEquipmentAidList   OUT NOCOPY V_B_STRING,   o_toEquipmentAidList     OUT NOCOPY V_B_STRING,
        o_fromFacilityList     OUT NOCOPY V_B_STRING, o_toFacilityList         OUT NOCOPY V_B_STRING,   o_fromFacilityAidList    OUT NOCOPY V_B_STRING,
        o_toFacilityAidList    OUT NOCOPY V_B_STRING, o_engineIdList           OUT NOCOPY V_B_STRING,   o_instanceIdList         OUT NOCOPY V_B_STRING
    );
    PROCEDURE getFiberInfo(
        idList          IN V_B_STRING,           ffpFromIdList   IN V_B_STRING,          ffpToIdList     IN V_B_STRING,
        o_toIdList      OUT NOCOPY V_B_STRING,   o_neIdList      OUT NOCOPY V_B_STRING,  o_fromIdList    OUT NOCOPY V_B_STRING,
        o_fromPortList  OUT NOCOPY V_B_STRING,   o_toPortList    OUT NOCOPY V_B_STRING,  o_channelList   OUT NOCOPY V_B_STRING,
        o_dwdmSideList  OUT NOCOPY V_B_STRING,   o_fromAidList   OUT NOCOPY V_B_STRING,  o_toAidList     OUT NOCOPY V_B_STRING,
        o_usageList     OUT NOCOPY V_B_STRING
    );
    PROCEDURE getConnectionInfo(
        fromIdList             IN V_B_STRING,           toIdList                 IN V_B_STRING,
        o_neIdList             OUT NOCOPY V_B_STRING,   o_fromDwdmSideList       OUT NOCOPY V_B_STRING,  o_toDwdmSideList         OUT NOCOPY V_B_STRING,
        o_xcTypeList           OUT NOCOPY V_B_STRING,   o_ccPathList             OUT NOCOPY V_B_STRING,  o_groupIdList            OUT NOCOPY V_B_STRING,
        o_circuitIdList        OUT NOCOPY V_B_STRING,   o_holdOffProtList        OUT NOCOPY V_B_STRING,  o_contIdList             OUT NOCOPY V_B_STRING,
        o_protnIdList          OUT NOCOPY V_B_STRING,   o_dropIdList             OUT NOCOPY V_B_STRING,  o_fromEquipmentAidList   OUT NOCOPY V_B_STRING,
        o_toEquipmentAidList   OUT NOCOPY V_B_STRING,   o_fromFacilityList       OUT NOCOPY V_B_STRING,  o_toFacilityList         OUT NOCOPY V_B_STRING,
        o_neNameList           OUT NOCOPY V_B_STRING,   o_fromFacilityAidList    OUT NOCOPY V_B_STRING,  o_toFacilityAidList      OUT NOCOPY V_B_STRING,
        o_fromOtherAidList     OUT NOCOPY V_B_STRING,   o_toOtherAidList         OUT NOCOPY V_B_STRING,  o_fromPortList           OUT NOCOPY V_B_STRING,
        o_toPortList           OUT NOCOPY V_B_STRING
    );
    PROCEDURE getSTSConnectionInfo(
        fromIdList                 IN V_B_STRING,          toIdList                    IN V_B_STRING,
        ifromCompositeMapList      IN V_B_EXTEXT,          itoCompositeMapList         IN V_B_EXTEXT,
        o_neIdList                 OUT NOCOPY V_B_STRING,  o_xcTypeList                OUT NOCOPY V_B_STRING, o_ccPathList             OUT NOCOPY V_B_STRING,
        o_circuitIdList            OUT NOCOPY V_B_STRING,  o_fromEquipmentAidList      OUT NOCOPY V_B_STRING, o_toEquipmentAidList     OUT NOCOPY V_B_STRING,
        o_fromFacilityList         OUT NOCOPY V_B_STRING,  o_toFacilityList            OUT NOCOPY V_B_STRING, o_neNameList             OUT NOCOPY V_B_STRING,
        o_fromFacilityAidList      OUT NOCOPY V_B_STRING,  o_fromMultiFacilityAidList  OUT NOCOPY V_B_STRING, o_toFacilityAidList      OUT NOCOPY V_B_STRING,
        o_toMultiFacilityAidList   OUT NOCOPY V_B_STRING,  o_fromProtFacilityAidList   OUT NOCOPY V_B_STRING, o_toProtFacilityAidList  OUT NOCOPY V_B_STRING,
        o_splitList                OUT NOCOPY V_B_STRING,  o_fromCompositeMapList      OUT NOCOPY V_B_EXTEXT, o_toCompositeMapList     OUT NOCOPY V_B_EXTEXT,
        o_fromVCGAidList           OUT NOCOPY V_B_STRING,  o_toVCGAidLIst              OUT NOCOPY V_B_STRING, o_redlineList            OUT NOCOPY V_B_STRING,
        o_fromProtEquipmentAidList OUT NOCOPY V_B_STRING,  o_toProtEquipmentAidList    OUT NOCOPY V_B_STRING, o_fromProtFacilityIdList OUT NOCOPY V_B_STRING,
        o_toProtFacilityIdList     OUT NOCOPY V_B_STRING
    );
END circuit_retrieval;
/
create or replace
PACKAGE BODY circuit_retrieval AS
    TYPE EMS_REF_CURSOR IS REF CURSOR;
    PROCEDURE getFacilityInfo(
        idList               IN V_B_STRING,
        o_aidList               OUT NOCOPY V_B_STRING, o_extConnectivityList  OUT NOCOPY V_B_STRING, o_editablePrimaryStateList OUT NOCOPY V_B_STRING,
        o_connectedToList       OUT NOCOPY V_B_STRING, o_attAdjModeList       OUT NOCOPY V_B_STRING, o_otuMappingList           OUT NOCOPY V_B_STRING,
        o_otuExpTrcList         OUT NOCOPY V_B_STRING, o_otuTrcList           OUT NOCOPY V_B_STRING, o_otuMonTrcList            OUT NOCOPY V_B_STRING,
        o_protFunctionList      OUT NOCOPY V_B_STRING, o_fecTypeList          OUT NOCOPY V_B_STRING, o_sdThreshList             OUT NOCOPY V_B_STRING,
        o_holdOffProtList       OUT NOCOPY V_B_STRING, o_neIdList             OUT NOCOPY V_B_STRING, o_facilityTypeList         OUT NOCOPY V_B_STRING,
        o_alarmProfileList      OUT NOCOPY V_B_STRING, o_IdList               OUT NOCOPY V_B_STRING, o_pmModeList               OUT NOCOPY V_B_STRING,
        o_tcaModeList           OUT NOCOPY V_B_STRING, o_expRateList          OUT NOCOPY V_B_STRING, o_transMapList             OUT NOCOPY V_B_STRING,
        o_schdPMList            OUT NOCOPY V_B_STRING, o_protList             OUT NOCOPY V_B_STRING, o_maintPropList            OUT NOCOPY V_B_STRING,
        o_oeoRegenList          OUT NOCOPY V_B_STRING, o_transparentList      OUT NOCOPY V_B_STRING, o_sts1MapList              OUT NOCOPY V_B_TEXT,
        o_parentFacilityKeyList OUT NOCOPY V_B_STRING, o_childFacilityKeyList OUT NOCOPY V_B_STRING, o_nvalueList               OUT NOCOPY V_B_STRING,
        o_sigTypeList           OUT NOCOPY V_B_STRING, o_npOwnerList          OUT NOCOPY V_B_STRING, o_secondaryStateList       OUT NOCOPY V_B_STRING,
        o_lineOrPortList        OUT NOCOPY V_B_STRING, o_ccPathList           OUT NOCOPY V_B_STRING, o_autoCfgList              OUT NOCOPY V_B_STRING,
        o_vcatList              OUT NOCOPY V_B_STRING, o_clockTypeList        OUT NOCOPY V_B_STRING, o_associatedKeyList        OUT NOCOPY V_B_STRING,
        o_schdInhModeList       OUT NOCOPY V_B_STRING, o_protSchemeList       OUT NOCOPY V_B_STRING, o_protectFacAidList        OUT NOCOPY V_B_STRING
    ) AS
        TYPE StringTable IS TABLE OF VARCHAR2(800) INDEX BY BINARY_INTEGER;
        cur_v                      EMS_REF_CURSOR;
        i                          INTEGER := 1;
        associatedId               NUMBER;
        associatedAid              VARCHAR2(20);
        timeSlot                   NUMBER;
        odu0TribSlot               VARCHAR2(2);
        odu1TribSlot               VARCHAR2(5);
        odu2TribSlot               VARCHAR2(32);
        middleOduList              V_B_STRING;
        topOduId                   NUMBER;
        associatedTribSlot         VARCHAR2(32);
        odu_mapping_list           V_B_STRING;
        odu_mapping_type_list      V_B_STRING;
        odu_mapping_tribslot_list  V_B_STRING;
        childIdList               StringTable;
        childAidList              StringTable;
        childCount                INTEGER;
    BEGIN circuit_util.print_start('getFacilityInfo');
        o_aidList                := V_B_STRING();        o_extConnectivityList    := V_B_STRING();        o_editablePrimaryStateList := V_B_STRING();
        o_secondaryStateList     := V_B_STRING();        o_lineOrPortList         := V_B_STRING();        o_connectedToList        := V_B_STRING();
        o_attAdjModeList         := V_B_STRING();        o_otuMappingList         := V_B_STRING();        o_otuExpTrcList          := V_B_STRING();
        o_otuTrcList             := V_B_STRING();        o_otuMonTrcList          := V_B_STRING();        o_protFunctionList       := V_B_STRING();
        o_fecTypeList            := V_B_STRING();        o_sdThreshList           := V_B_STRING();        o_holdOffProtList        := V_B_STRING();
        o_neIdList               := V_B_STRING();        o_facilityTypeList       := V_B_STRING();        o_alarmProfileList       := V_B_STRING();
        o_IdList                 := V_B_STRING();        o_pmModeList             := V_B_STRING();        o_tcaModeList            := V_B_STRING();
        o_expRateList            := V_B_STRING();        o_transMapList           := V_B_STRING();        o_schdPMList             := V_B_STRING();
        o_protList               := V_B_STRING();        o_maintPropList          := V_B_STRING();        o_transparentList        := V_B_STRING();
        o_sts1MapList            := V_B_TEXT();          o_parentFacilityKeyList  := V_B_STRING();        o_childFacilityKeyList   := V_B_STRING();
        o_nvalueList             := V_B_STRING();        o_sigTypeList            := V_B_STRING();        o_npOwnerList            := V_B_STRING();
        o_ccPathList             := V_B_STRING();        o_autoCfgList            := V_B_STRING();        o_vcatList               := V_B_STRING();
        o_clockTypeList          := V_B_STRING();        o_associatedKeyList      := V_B_STRING();        o_schdInhModeList        := V_B_STRING();
        o_oeoRegenList           := V_B_STRING();        o_protSchemeList         := V_B_STRING();        o_protectFacAidList      := V_B_STRING();
        circuit_util.print_line('Total facilities requested: '||idList.COUNT);
        EXECUTE IMMEDIATE 'insert into NM_CIRCUIT_CRS_CACHE(from_id) SELECT column_value FROM TABLE(CAST(:1 AS V_B_STRING))' USING idList;
        FOR l_fac IN (
              SELECT OCH_AID aid, to_char(nvl(OCH_ALMPF,'')) alarmProfile, nvl(OCH_EXTERNAL,'') extConnectivity, OCH_PST editablePrimaryState, OCH_SST secondaryState,
                  OCH_PORT_OR_LINE lineOrPort, nvl(OCH_CONNECTEDTO,'') connectedTo, nvl(OCH_AAM,'') attAdjMode, nvl(OCH_OTUMAP,'') otuMapping, nvl(OCH_EXPOTUTRC,'') otuExpTrc,
                  nvl(OCH_OTUTRC,'') otuTrc, nvl(OCH_MONOTUTRC,'') otuMonTrc, nvl(OCH_PROTFUNCTION,'') protFunction, nvl(OCH_FECTYPE,'') fecType, nvl(OCH_SDTHRESH,'') sdThresh,
                  to_char(nvl(OCH_HOLDOFFPROT,0)) holdOffProt, nvl(OCH_CPTYPE,'') facilityType, CM_CHANNEL_OCH.NE_ID neId,OCH_ID strId, OCH_PM_MODE pmMode,
                  OCH_TCA_MODE tcaMode, '' expRate, '' transMap, OCH_PM_SCHD_STATE schdPM, '' prot,
                  '' maintProp,'' oeoRegen,'' transparent,'' sts1Map,'' parentFacilityKey,
                  '' childFacilityKey,'' nvalue,'' sigType,to_char(nvl(OCH_NPOWNER,0)) npOwner,'' ccPath,
                  '' autoCfg, '' vcat, nvl(OCH_CLOCKTYPE,'') clockType, OCH_SCHD_INH_MODE schdInhMode,  '' protScheme,
                  '' protectFacAid
                FROM CM_CHANNEL_OCH, NM_CIRCUIT_CRS_CACHE fac WHERE och_id=fac.from_id
              UNION
              SELECT FAC_AID aid, to_char(nvl(FAC_ALMPF,'')) alarmProfile, nvl(FAC_EXTCONNECT,'') extConnectivity, FAC_PST editablePrimaryState, FAC_SST secondaryState,
                  decode(fac_port_or_line, 'Port', decode(circuit_util.getMappingOchPFromOdu(ne_id,fac_id), 0, 'Port', 'Line'), fac_port_or_line) lineOrPort, nvl(FAC_CONNECTED,'') connectedTo, '' attAdjMode, nvl(FAC_TRC,'') otuMapping, nvl(FAC_EXPOTUTRC,'') otuExpTrc,
                  nvl(FAC_OTUTRC,'') otuTrc, nvl(FAC_MONOTUTRC,'') otuMonTrc, '' protFunction, nvl(FAC_FECTYPE,'') fecType, nvl(FAC_SDTHRESH,'') sdThresh,
                  '' holdOffProt, nvl(FAC_CPTYPE,'') facilityType, CM_FACILITY.NE_ID neId, FAC_ID strId, FAC_PM_MODE  pmMode,
                  FAC_TCA_MODE tcaMode, FAC_EXPRATE expRate, FAC_TRANSMAP transMap, FAC_PM_SCHD_STATE schdPM, FAC_PROT prot,
                  FAC_MAINTPROP maintProp, FAC_OEOREGEN oeoRegen, FAC_TRANSPARENT transparent, FAC_STS1MAP sts1Map, circuit_util.getFacilityParentAid(FAC_ID, FAC_AID) parentFacilityKey,
                  '' childFacilityKey, to_char(FAC_NVALUE) nvalue, FAC_SIGTYPE sigType, to_char(nvl(FAC_NPOWNER,0)) npOwner, '' ccPath,
                  '' autoCfg, FAC_VCAT vcat, nvl(FAC_CLOCKTYPE,'') clockType, FAC_SCHD_INH_MODE schdInhMode, FAC_SCHEME protScheme,
                  CASE WHEN FAC_ID=FAC_WORKINGID THEN to_char(FAC_PROTECTIONID) ELSE to_char(FAC_WORKINGID) END protectFacAid
                FROM CM_FACILITY, NM_CIRCUIT_CRS_CACHE fac WHERE fac_id=fac.from_id
              UNION
              SELECT STS_AID aid, to_char(nvl(STS_ALMPF,'')) alarmProfile, '' extConnectivity, STS_PST editablePrimaryState, STS_SST secondaryState,
                  STS_PORT_OR_LINE lineOrPort, '' connectedTo, '' attAdjMode, '' otuMapping, '' otuExpTrc,
                  '' otuTrc, '' otuMonTrc, '' protFunction, '' fecType, nvl(STS_SDTHRESH,'') sdThresh,
                  '' holdOffProt, nvl(STS_CPTYPE,'') facilityType, CM_STS.NE_ID neId,STS_ID strId, STS_PM_MODE pmMode,
                  STS_TCA_MODE tcaMode, '' expRate, '' transMap, STS_PM_SCHD_STATE schdPM, '' prot,
                  '' maintProp, '' oeoRegen, '' transparent, STS_STS1MAP sts1Map, circuit_util.getFacilityParentAid(STS_ID, STS_AID) parentFacilityKey,
                  circuit_util.getFacilityChildAid(STS_ID, STS_AID) childFacilityKey, to_char(STS_NVALUE) nvalue, '' sigType, to_char(nvl(STS_NPOWNER,0)) npOwner, '' ccPath,
                  nvl(STS_AUTOCFG,'NO') autoCfg, '' vcat, '' clockType, STS_SCHD_INH_MODE schdInhMode, '' protScheme,
                  '' protectFacAid
                FROM CM_STS, NM_CIRCUIT_CRS_CACHE fac WHERE sts_id=fac.from_id
              -- get VCG details
              UNION
              SELECT VCG_AID aid, to_char(nvl(VCG_ALMPF,'')) alarmProfile, '' extConnectivity, VCG_PST editablePrimaryState, VCG_SST secondaryState,
                  'Port' lineOrPort, '' connectedTo, '' attAdjMode, '' otuMapping, '' otuExpTrc,
                  '' otuTrc,'' otuMonTrc, '' protFunction, '' fecType, '' sdThresh,
                  '' holdOffProt, nvl(VCG_CPTYPE,'') facilityType, NE_ID neId, VCG_ID strId, '' pmMode,
                  '' tcaMode,'' expRate,'' transMap,'' schdPM,'' prot,
                  '' maintProp, '' oeoRegen, '' transparent, VCG_TTPMAP sts1Map, circuit_util.getVCGCardAid(VCG_ID) parentFacilityKey,
                  '' childFacilityKey, to_char(VCG_NVALUE) nvalue, '' sigType, '' npOwner, VCG_CCPATH ccPath,
                  VCG_TYPE autoCfg, '' vcat, '' clockType, '' schdInhMode, '' protScheme,
                  '' protectFacAid
                FROM CM_VCG, NM_CIRCUIT_CRS_CACHE fac WHERE vcg_id=fac.from_id
              -- get sfp/xfp info which is modelled as facility
              UNION
              SELECT CARD_AID aid, '' alarmProfile, '' extConnectivity, CARD_PST editablePrimaryState, CARD_SST secondaryState,
                  CARD_PORT_OR_LINE lineOrPort, '' connectedTo, '' attAdjMode, '' otuMapping, '' otuExpTrc,
                  '' otuTrc, '' otuMonTrc, '' protFunction, '' fecType, '' sdThresh,
                  '' holdOffProt, nvl(CARD_CPTYPE,'') facilityType, CM_CARD.NE_ID neId, CARD_ID strId, '' pmMode,
                  '' tcaMode,'' expRate,'' transMap,'' schdPM,'' prot,
                  '' maintProp,'' oeoRegen,'' transparent,'' sts1Map,'' parentFacilityKey,
                  '' childFacilityKey,'' nvalue,'' sigType,'' npOwner,'SFP' ccPath,
                  '' autoCfg, '' vcat, '' clockType, CARD_SCHD_INH_MODE schdInhMode, '' protScheme,
                  '' protectFacAid
                FROM CM_CARD, NM_CIRCUIT_CRS_CACHE fac WHERE CARD_ID=fac.from_id AND (CARD_AID_TYPE LIKE '_FP' OR CARD_AID_TYPE LIKE '%SFPP')
        ) LOOP
            o_aidList.EXTEND;   o_aidList(i) := l_fac.aid;
            o_alarmProfileList.EXTEND;  o_alarmProfileList(i) := l_fac.alarmProfile;
            o_extConnectivityList.EXTEND;   o_extConnectivityList(i) := l_fac.extConnectivity;
            o_editablePrimaryStateList.EXTEND;  o_editablePrimaryStateList(i) := l_fac.editablePrimaryState;
            o_secondaryStateList.EXTEND;    o_secondaryStateList(i) := l_fac.secondaryState;

            o_lineOrPortList.EXTEND;    o_lineOrPortList(i) := l_fac.lineOrPort;
            o_connectedToList.EXTEND;   o_connectedToList(i) := l_fac.connectedTo;
            o_attAdjModeList.EXTEND;    o_attAdjModeList(i) := l_fac.attAdjMode;
            o_otuMappingList.EXTEND;    o_otuMappingList(i) := l_fac.otuMapping;
            o_otuExpTrcList.EXTEND; o_otuExpTrcList(i) := l_fac.otuExpTrc;

            o_otuTrcList.EXTEND;    o_otuTrcList(i) := l_fac.otuTrc;
            o_otuMonTrcList.EXTEND; o_otuMonTrcList(i) := l_fac.otuMonTrc;
            o_protFunctionList.EXTEND;  o_protFunctionList(i) := l_fac.protFunction;
            o_fecTypeList.EXTEND;   o_fecTypeList(i) := l_fac.fecType;
            o_sdThreshList.EXTEND;  o_sdThreshList(i) := l_fac.sdThresh;

            o_holdOffProtList.EXTEND;   o_holdOffProtList(i) := l_fac.holdOffProt;
            o_facilityTypeList.EXTEND;  o_facilityTypeList(i) := l_fac.facilityType;
            o_neIdList.EXTEND;  o_neIdList(i) := l_fac.neId;
            o_IdList.EXTEND;    o_IdList(i) := l_fac.strId;
            o_pmModeList.EXTEND;    o_pmModeList(i) := l_fac.pmMode;

            o_tcaModeList.EXTEND;   o_tcaModeList(i) := l_fac.tcaMode;
            o_expRateList.EXTEND;   o_expRateList(i) := l_fac.expRate;
            o_transMapList.EXTEND;  o_transMapList(i) := l_fac.transMap;
            o_schdPMList.EXTEND;    o_schdPMList(i) := l_fac.schdPM;
            o_protList.EXTEND;  o_protList(i) := l_fac.prot;

            o_maintPropList.EXTEND; o_maintPropList(i) := l_fac.maintProp;
            o_oeoRegenList.EXTEND;  o_oeoRegenList(i) := l_fac.oeoRegen;
            o_transparentList.EXTEND;   o_transparentList(i) := l_fac.transparent;
            o_sts1MapList.EXTEND;   o_sts1MapList(i) := l_fac.sts1Map;
            o_parentFacilityKeyList.EXTEND; o_parentFacilityKeyList(i) := l_fac.parentFacilityKey;

            o_childFacilityKeyList.EXTEND;  o_childFacilityKeyList(i) := l_fac.childFacilityKey;
            o_nvalueList.EXTEND;    o_nvalueList(i) := l_fac.nvalue;
            o_sigTypeList.EXTEND;   o_sigTypeList(i) := l_fac.sigType;
            o_npOwnerList.EXTEND;   o_npOwnerList(i) := l_fac.npOwner;
            o_ccPathList.EXTEND;    o_ccPathList(i) := l_fac.ccPath;

            o_autoCfgList.EXTEND;   o_autoCfgList(i) := l_fac.autoCfg;
            o_vcatList.EXTEND;  o_vcatList(i) := l_fac.vcat;
            o_clockTypeList.EXTEND; o_clockTypeList(i) := l_fac.clockType;
            o_schdInhModeList.EXTEND;   o_schdInhModeList(i) := l_fac.schdInhMode;
            o_protSchemeList.EXTEND;    o_protSchemeList(i) := l_fac.protScheme;

            o_protectFacAidList.EXTEND; o_protectFacAidList(i) := l_fac.protectFacAid;
            o_associatedKeyList.EXTEND;

            associatedAid := NULL;
            associatedId := 0;
            IF (l_fac.aid LIKE 'ODU2%') OR (l_fac.aid LIKE 'ODU3%') OR (l_fac.aid LIKE 'ODU4%')  THEN
                -- for odu2 facility, retrieves it's accociated ochp key
                associatedId := circuit_util.getMappingOchPFromOdu(TO_NUMBER(l_fac.neId), TO_NUMBER(l_fac.strId));
                IF associatedId <> 0 THEN
                    OPEN cur_v FOR SELECT och_aid FROM CM_CHANNEL_OCH WHERE och_id = associatedId;
                    FETCH cur_v INTO associatedAid;
                    CLOSE cur_v;
                    o_associatedKeyList(i) := l_fac.neId || associatedAid;
                ELSE
                    topOduId := circuit_util.getTopMappingOduFromLower(TO_NUMBER(l_fac.neId), TO_NUMBER(l_fac.strId), odu_mapping_list, odu_mapping_type_list, odu_mapping_tribslot_list);
                    IF (odu_mapping_list.COUNT > 1) THEN
                          associatedId := circuit_util.getMappingOchPFromOdu(TO_NUMBER(l_fac.neId), topOduId);
                          IF associatedId <> 0 THEN
                              OPEN cur_v FOR SELECT och_aid FROM CM_CHANNEL_OCH WHERE och_id = associatedId;
                              FETCH cur_v INTO associatedAid;
                              CLOSE cur_v;
                              o_associatedKeyList(i) := l_fac.neId || associatedAid;
                          ELSE
                              associatedId := 0;
                          END IF; 
                    ELSE
                          associatedId := 0;
                          topOduId := TO_NUMBER(l_fac.strId);
                    END IF;
                    IF (associatedId = 0) THEN
                          associatedId := circuit_util.getMappingFacFromOdu(TO_NUMBER(l_fac.neId), topOduId);
                          IF associatedId <> 0 THEN
                              OPEN cur_v FOR SELECT fac_aid FROM CM_FACILITY WHERE fac_id = associatedId;
                              FETCH cur_v INTO associatedAid;
                              CLOSE cur_v;
                              o_associatedKeyList(i) := l_fac.neId || associatedAid;
                          ELSE
                              OPEN cur_v FOR SELECT p.fac_aid FROM CM_FACILITY p, CM_FACILITY s WHERE p.ne_id = s.ne_id AND s.fac_id = l_fac.strId AND p.fac_id = s.fac_parent_id;
                              FETCH cur_v INTO associatedAid;
                              CLOSE cur_v;
                              IF associatedAid is not null THEN
                                  o_associatedKeyList(i) := l_fac.neId || associatedAid;
                              ELSE
                                  o_associatedKeyList(i) := '';
                              END IF;
                          END IF; 
                    END IF;
                END IF;
            ELSIF (l_fac.aid LIKE 'ODU1-%') OR (l_fac.aid LIKE 'ODU0-%') OR (l_fac.aid LIKE 'ODUF-%') THEN
                topOduId := circuit_util.getTopMappingOduFromLower(TO_NUMBER(l_fac.neId), TO_NUMBER(l_fac.strId), odu_mapping_list, odu_mapping_type_list, odu_mapping_tribslot_list);
                IF (odu_mapping_list.COUNT > 1) THEN
                   associatedId := TO_NUMBER(odu_mapping_list(2));
                   associatedTribSlot := odu_mapping_tribslot_list(1);
                END IF;
                IF associatedId <> 0 THEN
                    OPEN cur_v FOR SELECT fac_aid FROM CM_FACILITY WHERE fac_id = associatedId;
                    FETCH cur_v INTO associatedAid;
                    CLOSE cur_v;
                    o_associatedKeyList(i) := l_fac.neId || associatedAid || ':' || associatedTribSlot;
                ELSE
                    associatedId := circuit_util.getMappingFacFromOdu(TO_NUMBER(l_fac.neId), TO_NUMBER(l_fac.strId));
                    IF associatedId <> 0 THEN
                        OPEN cur_v FOR SELECT fac_aid FROM CM_FACILITY WHERE fac_id = associatedId;
                        FETCH cur_v INTO associatedAid;
                        CLOSE cur_v;
                        o_associatedKeyList(i) := l_fac.neId || associatedAid;
                    ELSE
                        o_associatedKeyList(i) := '';
                    END IF;
                END IF;
            ELSIF l_fac.aid LIKE 'TTPVC4-%' THEN
                FOR l_sts IN (
                    SELECT FAC_ID, FAC_AID FROM CM_FACILITY WHERE FAC_PARENT_ID= l_fac.strId
                )LOOP
                    FOR k IN 1..(idList.COUNT) LOOP
                        IF l_sts.fac_id = idList(k) THEN
                            o_childFacilityKeyList(i) := l_sts.fac_aid;
                        END IF;
                    END LOOP;
                END LOOP;
            ELSE
                o_associatedKeyList(i) := '';
            END IF;
            i := i+1;
        END LOOP;
        COMMIT;
        circuit_util.print_end('getFacilityInfo');
    END getFacilityInfo;

    PROCEDURE getEquipmentInfo(
        idList               IN V_B_STRING,
        o_aidList            OUT NOCOPY V_B_STRING,  o_editablePrimaryStateList OUT NOCOPY V_B_STRING,  o_alarmProfileList   OUT NOCOPY V_B_STRING,
        o_noOfPortsList      OUT NOCOPY V_B_STRING,  o_channelList              OUT NOCOPY V_B_STRING,  o_halfBandList       OUT NOCOPY V_B_STRING,
        o_timingModeList     OUT NOCOPY V_B_STRING,  o_rateList                 OUT NOCOPY V_B_STRING,  o_neIdList           OUT NOCOPY V_B_STRING,
        o_IdList             OUT NOCOPY V_B_STRING,  o_pmModeList               OUT NOCOPY V_B_STRING,  o_ochFacilityList    OUT NOCOPY V_B_STRING,
        o_portfacilityList   OUT NOCOPY V_B_STRING,  o_tcaModeList              OUT NOCOPY V_B_STRING,  o_schdPMList         OUT NOCOPY V_B_STRING,
        o_plugModuleList     OUT NOCOPY V_B_STRING,  o_shelfIdList              OUT NOCOPY V_B_STRING,  o_schdInhModeList    OUT NOCOPY V_B_STRING
    ) AS
        i                          INTEGER := 1;
    BEGIN circuit_util.print_start('getEquipmentInfo');
        o_aidList                   := V_B_STRING();        o_shelfIdList               := V_B_STRING();        o_editablePrimaryStateList  := V_B_STRING();
        o_alarmProfileList          := V_B_STRING();        o_noOfPortsList             := V_B_STRING();        o_channelList               := V_B_STRING();
        o_halfBandList              := V_B_STRING();        o_timingModeList            := V_B_STRING();        o_rateList                  := V_B_STRING();
        o_neIdList                  := V_B_STRING();        o_IdList                    := V_B_STRING();        o_pmModeList                := V_B_STRING();
        o_tcaModeList               := V_B_STRING();        o_schdPMList                := V_B_STRING();        o_plugModuleList            := V_B_STRING();
        o_ochFacilityList           := V_B_STRING();        o_portFacilityList          := V_B_STRING();        o_schdInhModeList           := V_B_STRING();

        circuit_util.print_line('Total equipment requested: '||idList.COUNT);
        EXECUTE IMMEDIATE 'insert into NM_CIRCUIT_CRS_CACHE(from_id) SELECT column_value FROM TABLE(CAST(:1 AS V_B_STRING))' USING idList;
        FOR l_eq IN (
            -- Prepare SQL query
            SELECT card.CARD_AID aid,nvl(card.CARD_PST,'') editablePrimaryState,to_char(nvl(card.CARD_ALMPF,0)) alarmProfile,
                   to_char(nvl(card.CARD_NUMBERPORT,0)) noOfPorts,to_char(nvl(card.CARD_CHAN,0)) channel,to_char(nvl(card.CARD_HALFBAND,0)) halfBand,
                   nvl(card.CARD_TMG,'') timingMode,nvl(card.CARD_RATE,'') rate,card.NE_ID neId,
                   card.CARD_ID strId,card.CARD_PM_MODE pmMode,to_char(nvl(CM_CHANNEL_OCH.OCH_AID,'')) ochFacility,
                   to_char(nvl(CM_FACILITY.FAC_AID,'')) portFacility, card.CARD_TCA_MODE tcaMode, card.CARD_PM_SCHD_STATE schdPM,
                   to_char(nvl(plugModule.CARD_AID,'')) plugModule, card.CARD_PARENT_ID shelfId, card.CARD_SCHD_INH_MODE schdInhMode
              FROM CM_CARD card, CM_CARD plugModule, CM_CHANNEL_OCH, CM_FACILITY, NM_CIRCUIT_CRS_CACHE xc
              WHERE OCH_PARENT_ID(+)=card.CARD_ID AND plugModule.CARD_PARENT_ID(+)=card.CARD_ID AND plugModule.CARD_AID(+) LIKE '%FP-%' AND
                 (FAC_PARENT_ID(+)=card.CARD_ID AND (card.CARD_AID NOT LIKE 'SMTM%' AND card.CARD_AID NOT LIKE 'SSM%' OR card.CARD_AID_TYPE = 'SMTMP' OR (card.CARD_AID LIKE 'SMTM%' AND FAC_PORT_OR_LINE='Line') OR (card.CARD_AID LIKE 'SSM%' AND FAC_PORT_OR_LINE='Line')))
                  --AND card.CARD_AID NOT LIKE 'BMM%' AND card.CARD_AID NOT LIKE 'FGTMM%' AND card.CARD_AID NOT LIKE 'HDTG%'
                  AND card.CARD_I_PARENT_TYPE <> 'CARD' AND card.CARD_AID NOT LIKE 'BMM%' AND card.CARD_AID_TYPE NOT IN ('FGTMM','HDTG','HGTMM','HGTMMS')
                  AND card.CARD_ID=xc.from_id
            UNION
            SELECT card.CARD_AID aid,nvl(card.CARD_PST,'') editablePrimaryState,to_char(nvl(card.CARD_ALMPF,0)) alarmProfile,
                   to_char(nvl(card.CARD_NUMBERPORT,0)) noOfPorts,to_char(nvl(card.CARD_CHAN,0)) channel,to_char(nvl(card.CARD_HALFBAND,0)) halfBand,
                   nvl(card.CARD_TMG,'') timingMode,nvl(card.CARD_RATE,'') rate,card.NE_ID neId,
                   card.CARD_ID strId,card.CARD_PM_MODE pmMode, OCH_AID ochFacility,
                   to_char(nvl(CM_FACILITY.FAC_AID,'')) portFacility, card.CARD_TCA_MODE tcaMode, card.CARD_PM_SCHD_STATE schdPM,
                   '' plugModule, card.CARD_PARENT_ID shelfId, card.CARD_SCHD_INH_MODE schdInhMode
              FROM CM_CARD card, CM_CHANNEL_OCH, CM_FACILITY, NM_CIRCUIT_CRS_CACHE xc
              WHERE OCH_PARENT_ID=card.CARD_ID AND card.CARD_AID_TYPE ='FGTMM' AND FAC_PARENT_ID(+)=card.CARD_ID
                  AND card.CARD_ID=xc.from_id
            UNION
            SELECT card.CARD_AID aid,nvl(card.CARD_PST,'') editablePrimaryState,to_char(nvl(card.CARD_ALMPF,0)) alarmProfile,
                   to_char(nvl(card.CARD_NUMBERPORT,0)) noOfPorts,to_char(nvl(card.CARD_CHAN,0)) channel,to_char(nvl(card.CARD_HALFBAND,0)) halfBand,
                   nvl(card.CARD_TMG,'') timingMode,nvl(card.CARD_RATE,'') rate,card.NE_ID neId,
                   card.CARD_ID strId,card.CARD_PM_MODE pmMode, OCH_AID ochFacility,
                   '' portFacility, card.CARD_TCA_MODE tcaMode, card.CARD_PM_SCHD_STATE schdPM,
                   '' plugModule, card.CARD_PARENT_ID shelfId, card.CARD_SCHD_INH_MODE schdInhMode
              FROM CM_CARD card, CM_CHANNEL_OCH, NM_CIRCUIT_CRS_CACHE xc
              WHERE OCH_PARENT_ID=card.CARD_ID AND card.CARD_AID_TYPE LIKE 'HGTMM%' AND OCH_AID_PORT IN (1,13)
                  AND card.CARD_ID=xc.from_id
            UNION
            SELECT CARD_AID aid,nvl(CARD_PST,'') editablePrimaryState,to_char(nvl(CARD_ALMPF,0)) alarmProfile,
                  to_char(nvl(CARD_NUMBERPORT,0)) noOfPorts,to_char(nvl(CARD_CHAN,0)) channel,to_char(nvl(CARD_HALFBAND,0)) halfBand,
                  nvl(CARD_TMG,'') timingMode,nvl(CARD_RATE,'') rate,CM_CARD.NE_ID neId,
                  CARD_ID strId,'' pmMode,'' ochFacility,
                  '' portFacility,'' tcaMode,'' schdPM,
                  '' plugModule,CARD_PARENT_ID shelfId, CARD_SCHD_INH_MODE schdInhMode
              FROM CM_CARD, NM_CIRCUIT_CRS_CACHE xc
              WHERE (CARD_AID_TYPE IN ('OPSM','HDTG') OR CARD_AID like 'BMM%' )
                  AND CARD_ID=xc.from_id
        ) LOOP
            o_aidList.EXTEND; o_aidList(i) := l_eq.aid;
            o_shelfIdList.EXTEND; o_shelfIdList(i) := l_eq.shelfId;
            o_editablePrimaryStateList.EXTEND; o_editablePrimaryStateList(i) := l_eq.editablePrimaryState;
            o_alarmProfileList.EXTEND; o_alarmProfileList(i):= l_eq.alarmProfile;
            o_noOfPortsList.EXTEND; o_noOfPortsList(i) := l_eq.noOfPorts;
            o_channelList.EXTEND; o_channelList(i) := l_eq.channel;
            o_halfBandList.EXTEND; o_halfBandList(i) := l_eq.halfBand;
            o_timingModeList.EXTEND; o_timingModeList(i) := l_eq.timingMode;
            o_rateList.EXTEND; o_rateList(i) := l_eq.rate;
            o_neIdList.EXTEND; o_neIdList(i) := l_eq.neId;
            o_IdList.EXTEND; o_IdList(i) := l_eq.strId;
            o_pmModeList.EXTEND; o_pmModeList(i) := l_eq.pmMode;
            o_ochFacilityList.EXTEND; o_ochFacilityList(i) := l_eq.ochFacility;
            o_portFacilityList.EXTEND; o_portFacilityList(i) := l_eq.portFacility;
            o_tcaModeList.EXTEND; o_tcaModeList(i) := l_eq.tcaMode;
            o_schdPMList.EXTEND; o_schdPMList(i) := l_eq.schdPM;
            o_plugModuleList.EXTEND; o_plugModuleList(i) := l_eq.plugModule;
            o_schdInhModeList.EXTEND; o_schdInhModeList(i) := l_eq.schdInhMode;
            i := i + 1;
        END LOOP;
        COMMIT;
    circuit_util.print_end('getEquipmentInfo');
    END getEquipmentInfo;

    PROCEDURE getFFPInfo(
        fromIdList             IN V_B_STRING,         toIdList                 IN V_B_STRING,
        o_neIdList             OUT NOCOPY V_B_STRING, o_typeList               OUT NOCOPY V_B_STRING,   o_rvtrvList              OUT NOCOPY V_B_STRING,
        o_schemeList           OUT NOCOPY V_B_STRING, o_fromEquipmentAidList   OUT NOCOPY V_B_STRING,   o_toEquipmentAidList     OUT NOCOPY V_B_STRING,
        o_fromFacilityList     OUT NOCOPY V_B_STRING, o_toFacilityList         OUT NOCOPY V_B_STRING,   o_fromFacilityAidList    OUT NOCOPY V_B_STRING,
        o_toFacilityAidList    OUT NOCOPY V_B_STRING, o_engineIdList           OUT NOCOPY V_B_STRING,   o_instanceIdList         OUT NOCOPY V_B_STRING
    ) AS
        i               INTEGER := 1;
     BEGIN circuit_util.print_start('getFFPInfo');
        o_neIdList               := V_B_STRING();
        o_typeList               := V_B_STRING();
        o_rvtrvList              := V_B_STRING();
        o_schemeList             := V_B_STRING();
        o_fromEquipmentAidList   := V_B_STRING();
        o_toEquipmentAidList     := V_B_STRING();
        o_fromFacilityList       := V_B_STRING();
        o_toFacilityList         := V_B_STRING();
        o_fromFacilityAidList    := V_B_STRING();
        o_toFacilityAidList      := V_B_STRING();
        o_engineIdList           := V_B_STRING();
        o_instanceIdList         := V_B_STRING();

        EXECUTE IMMEDIATE 'insert into NM_CIRCUIT_CRS_CACHE(from_id,to_id) SELECT from_id,to_id FROM (select column_value from_id, rownum rn from TABLE(CAST(:1 AS V_B_STRING))) f, (SELECT column_value to_id, rownum rn FROM TABLE(CAST(:2 AS V_B_STRING))) t WHERE f.rn=t.rn' USING fromIdList,toIdList;
        circuit_util.print_line('Total ffps requested: '||fromIdList.COUNT);
        FOR l_ffp IN(
          -- Following SQL gets working/protecting facilities fro OPSM DPRING
            SELECT a.NE_ID neId, a.FAC_ID fromFacility, b.FAC_ID toFacility,
                  a.FAC_AID fromFacilityAid, b.FAC_AID toFacilityAid, CARD_AID fromEquipmentAid,
                  '' toEquipmentAid,nvl(INTF_I_PARENT_TYPE,'') "type", nvl(INTF_REVERTIVE,'') rvtrv,
                  nvl(INTF_PROTSCHEME,'') scheme,'' engineId, '' instanceId
              FROM CM_FACILITY a, CM_FACILITY b, CM_INTERFACE, CM_CARD,NM_CIRCUIT_CRS_CACHE xc
              WHERE a.FAC_ID=xc.from_id AND b.fac_id=xc.to_id AND INTF_ID=a.FAC_PARENT_ID AND CARD_ID=INTF_PARENT_ID AND INTF_PROTSCHEME<>'NOTPROTECTED'
            UNION
            -- Following SQL gets working/protecting facilities for SMTM DPRING
            SELECT a.NE_ID neId, a.OCH_ID fromFacility, b.OCH_ID toFacility,
                  a.OCH_AID fromFacilityAid, b.OCH_AID toFacilityAid, ac.CARD_AID fromEquipmentAid,
                  bc.CARD_AID toEquipmentAid,'' "type",nvl(a.OCH_RVRTV,'') rvtrv,
                  nvl(a.OCH_SCHEME,'') scheme,'' engineId, '' instanceId
              FROM CM_CHANNEL_OCH a, CM_CHANNEL_OCH b, CM_CARD ac, CM_CARD bc,NM_CIRCUIT_CRS_CACHE xc
              WHERE a.OCH_ID=xc.from_id and b.OCH_ID=xc.to_id AND a.OCH_ID=a.OCH_WORKINGID AND b.OCH_ID=a.OCH_PROTECTIONID AND ac.CARD_ID=a.OCH_PARENT_ID AND bc.CARD_ID=b.OCH_PARENT_ID AND a.OCH_SCHEME<>'NOTPROTECTED' AND b.OCH_SCHEME<>'NOTPROTECTED'
             UNION
            -- Following SQL gets working/protecting facilities for SMTM UPSR/SNCPRING
            SELECT a.NE_ID neId, a.FAC_ID fromFacility, b.FAC_ID toFacility,
                  a.FAC_AID fromFacilityAid, b.FAC_AID toFacilityAid, ac.CARD_AID fromEquipmentAid,
                  bc.CARD_AID toEquipmentAid,'' "type",nvl(a.FAC_RVRTV,'') rvtrv,
                  nvl(a.FAC_SCHEME,'') scheme,'' engineId, '' instanceId
              FROM CM_FACILITY a, CM_FACILITY b, CM_CARD ac, CM_CARD bc,NM_CIRCUIT_CRS_CACHE xc
              WHERE  a.FAC_ID=xc.from_id AND b.fac_id=xc.to_id AND a.FAC_ID=a.FAC_WORKINGID AND b.FAC_ID=a.FAC_PROTECTIONID AND a.FAC_PARENT_ID(+)=ac.CARD_ID AND b.FAC_PARENT_ID(+)=bc.CARD_ID AND a.FAC_SCHEME<>'NOTPROTECTED' AND b.FAC_SCHEME<>'NOTPROTECTED'
             UNION
            -- Following SQL handles SMTMP RPR (fake FFP)
            SELECT ac.NE_ID neId, ac.CARD_ID fromFacility, bc.CARD_ID toFacility,
                  ac.CARD_AID fromFacilityAid, bc.CARD_AID toFacilityAid, ac.CARD_AID fromEquipmentAid,
                  bc.CARD_AID toEquipmentAid,'0' "type",'' rvtrv,
                  'RPR' scheme,nvl(pkt.PKTDS_AID,'') engineId,to_char(1344+ac.CARD_AID_SLOT) instanceId
              FROM CM_CARD ac, CM_CARD bc, CM_PKTDS pkt, CM_SHELF slf,NM_CIRCUIT_CRS_CACHE xc
              WHERE ac.CARD_ID=xc.from_id AND bc.CARD_ID=xc.to_id AND pkt.NE_ID(+)=slf.NE_ID AND slf.NE_ID=ac.NE_ID AND slf.SHELF_AID_SHELF=ac.CARD_AID_SHELF AND pkt.PKTDS_PARENT_ID(+)=slf.SHELF_ID
             UNION
            -- Following SQL gets working/protecting facilities for OSM40/20 SNC
            -- no interface anylonger
            SELECT a.NE_ID neId, a.FAC_ID fromFacility, b.FAC_ID toFacility,
               a.FAC_AID fromFacilityAid, b.FAC_AID toFacilityAid, ac.CARD_AID fromEquipmentAid,
               bc.CARD_AID toEquipmentAid,'' "type",nvl(a.FAC_RVRTV,'') rvtrv,
               decode(a.FAC_SCHEME, 'NOTPROTECTED', nvl(decode(a.FAC_ID,crs.CRS_ODU_FROM_ID,crs_odu_src_prot_type,crs_odu_dest_prot_type),'SNC'), a.FAC_SCHEME) scheme,'' engineId, '' instanceId
            FROM CM_FACILITY a, CM_FACILITY b, CM_CARD ac, CM_CARD bc, CM_CRS_ODU crs, NM_CIRCUIT_CRS_CACHE xc
            WHERE a.FAC_ID=xc.from_id AND b.fac_id=xc.to_id AND ((a.FAC_ID=crs.CRS_ODU_FROM_ID AND b.FAC_ID=crs.CRS_ODU_SRC_PROT_ID) OR (a.FAC_ID=crs.CRS_ODU_TO_ID AND b.FAC_ID=crs.CRS_ODU_DEST_PROT_ID)) AND a.FAC_PARENT_ID=ac.CARD_ID AND b.FAC_PARENT_ID=bc.CARD_ID
            UNION
            ---Following SQL get PPG ffp
            SELECT a.NE_ID neId, a.sts_id fromFacility, b.sts_id toFacility,
                  a.sts_aid fromFacilityAid, b.sts_aid toFacilityAid, ac.CARD_AID fromEquipmentAid,
                  bc.CARD_AID toEquipmentAid, '' "type",nvl(a.STS_RVRTV,'') rvtrv,
                  decode(af.FAC_SCHEME, 'NOTPROTECTED', 'PPG', af.FAC_SCHEME) scheme,'' engineId, '' instanceId
              FROM cm_sts a, cm_sts b, CM_CARD ac, CM_CARD bc, cm_facility af, cm_facility bf, cm_crs_sts crs, NM_CIRCUIT_CRS_CACHE xc
              WHERE a.sts_id=xc.from_id AND b.sts_id=xc.to_id AND ((a.sts_ID=crs.CRS_sts_FROM_ID AND b.sts_ID=crs.CRS_sts_SRC_PROT_ID)
                   OR (a.sts_ID=crs.CRS_sts_TO_ID AND b.sts_ID=crs.CRS_sts_DEST_PROT_ID)
                ) AND a.sts_PARENT_ID=af.fac_id AND b.sts_PARENT_ID=bf.fac_id and af.fac_parent_id = ac.CARD_ID and bf.fac_parent_id = bc.CARD_ID

        ) LOOP
            o_neIdList.EXTEND; o_neIdList(i) := l_ffp.neId;
            o_fromEquipmentAidList.EXTEND; o_fromEquipmentAidList(i) := l_ffp.fromEquipmentAid;
            o_toEquipmentAidList.EXTEND; o_toEquipmentAidList(i) := l_ffp.toEquipmentAid;
            o_fromFacilityList.EXTEND; o_fromFacilityList(i) := l_ffp.fromFacility;
            o_toFacilityList.EXTEND; o_toFacilityList(i) := l_ffp.toFacility;
            o_fromFacilityAidList.EXTEND; o_fromFacilityAidList(i) := l_ffp.fromFacilityAid;
            o_toFacilityAidList.EXTEND; o_toFacilityAidList(i) := l_ffp.toFacilityAid;
            o_typeList.EXTEND; o_typeList(i) := l_ffp."type";
            o_rvtrvList.EXTEND; o_rvtrvList(i) := l_ffp.rvtrv;
            o_schemeList.EXTEND; o_schemeList(i) := l_ffp.scheme;
            o_engineIdList.EXTEND; o_engineIdList(i) := l_ffp.engineId;
            o_instanceIdList.EXTEND; o_instanceIdList(i) := l_ffp.instanceId;
            i := i + 1;
        END LOOP;
        COMMIT;
    circuit_util.print_end('getFFPInfo');
    END getFFPInfo;

    PROCEDURE getFiberInfo(
        idList          IN V_B_STRING,           ffpFromIdList   IN V_B_STRING,          ffpToIdList     IN V_B_STRING,
        o_toIdList      OUT NOCOPY V_B_STRING,   o_neIdList      OUT NOCOPY V_B_STRING,  o_fromIdList    OUT NOCOPY V_B_STRING,
        o_fromPortList  OUT NOCOPY V_B_STRING,   o_toPortList    OUT NOCOPY V_B_STRING,  o_channelList   OUT NOCOPY V_B_STRING,
        o_dwdmSideList  OUT NOCOPY V_B_STRING,   o_fromAidList   OUT NOCOPY V_B_STRING,  o_toAidList     OUT NOCOPY V_B_STRING,
        o_usageList     OUT NOCOPY V_B_STRING
    ) AS
    BEGIN circuit_util.print_start('getFiberInfo');
        o_toIdList      := V_B_STRING();        o_neIdList      := V_B_STRING();        o_fromIdList    := V_B_STRING();
        o_fromPortList  := V_B_STRING();        o_toPortList    := V_B_STRING();        o_channelList   := V_B_STRING();
        o_dwdmSideList  := V_B_STRING();        o_fromAidList   := V_B_STRING();        o_toAidList     := V_B_STRING();
        o_usageList     := V_B_STRING();

        circuit_util.print_line('Total EQPT FIBR requested: '||idList.COUNT);
        EXECUTE IMMEDIATE 'insert into NM_CIRCUIT_CRS_CACHE(from_id) SELECT column_value FROM TABLE(CAST(:1 AS V_B_STRING))' USING idList;
        IF idList.COUNT<>0 THEN
            FOR l_fiber IN (
                SELECT to_char(fibr.NE_ID) neId,to_char(fibr.CONN_FROM_ID) fromId,to_char(fibr.CONN_TO_ID) toId,
                     to_char(nvl(fibr.CONN_FROMPORT,0)) fromPort,to_char(nvl(fibr.CONN_TOPORT,0)) toPort, circuit_util.getCMMChannel(fromcard.ne_id,fromcard.CARD_ID,tocard.CARD_ID,nvl(fibr.CONN_FROMPORT,0),nvl(fibr.CONN_TOPORT,0), fromcard.card_aid_type, fromcard.card_aid_shelf, fromcard.card_aid_slot, fromcard.card_band) channel,
                     nvl(fibr.CONN_DWDMSIDE,'') dwdmSide,nvl(fromcard.CARD_AID,'') fromAid, nvl(tocard.CARD_AID,'') toAid,
                     circuit_util.getDxUsage(fromcard.CARD_ID) "usage"
                  FROM CM_FIBR_CONN fibr, CM_CARD fromcard, CM_CARD tocard, nm_circuit_crs_cache idTable
                  WHERE fromcard.CARD_ID=fibr.CONN_FROM_ID AND tocard.CARD_ID=fibr.CONN_TO_ID AND fromcard.NE_ID=fibr.NE_ID AND tocard.NE_ID=fibr.NE_ID AND tocard.CARD_AID_TYPE <> 'OPSM'
                  AND fibr.CONN_TO_ID = idTable.from_id
            ) LOOP
                o_toIdList.EXTEND; o_toIdList(o_toIdList.COUNT) := l_fiber.toId;
                o_neIdList.EXTEND; o_neIdList(o_neIdList.COUNT) := l_fiber.neId;
                o_fromIdList.EXTEND; o_fromIdList(o_fromIdList.COUNT) := l_fiber.fromId;
                o_fromPortList.EXTEND; o_fromPortList(o_fromPortList.COUNT) := l_fiber.fromPort;
                o_toPortList.EXTEND; o_toPortList(o_toPortList.COUNT) := l_fiber.toPort;
                o_channelList.EXTEND; o_channelList(o_channelList.COUNT) := l_fiber.channel;
                o_dwdmSideList.EXTEND; o_dwdmSideList(o_dwdmSideList.COUNT) := l_fiber.dwdmSide;
                o_fromAidList.EXTEND; o_fromAidList(o_fromAidList.COUNT) := l_fiber.fromAid;
                o_toAidList.EXTEND; o_toAidList(o_toAidList.COUNT) := l_fiber.toAid;
                o_usageList.EXTEND; o_usageList(o_usageList.COUNT) := l_fiber."usage";
            END LOOP;
        END IF;
        COMMIT;

        EXECUTE IMMEDIATE 'insert into NM_CIRCUIT_CRS_CACHE(from_id,to_id) SELECT from_id,to_id FROM (select column_value from_id, rownum rn from TABLE(CAST(:1 AS V_B_STRING))) f, (SELECT column_value to_id, rownum rn FROM TABLE(CAST(:2 AS V_B_STRING))) t WHERE f.rn=t.rn' USING ffpFromIdList,ffpToIdList;
        IF (ffpFromIdList IS NOT NULL AND ffpFromIdList.COUNT != 0) THEN
            FOR l_fiber IN (
                SELECT to_char(fiber.NE_ID)  neId,      to_char(CONN_FROM_ID) fromId,to_char(CONN_TO_ID) toId,
                       to_char(nvl(CONN_FROMPORT,0)) fromPort, to_char(nvl(CONN_TOPORT,0)) toPort, to_char(nvl(CONN_FROMPORT,0)) channel,
                       nvl(CONN_DWDMSIDE,'') dwdmSide, nvl(fromcard.CARD_AID,'') fromAid, nvl(tocard.CARD_AID,'') toAid,
                       'DEGREE' "usage"
                  FROM CM_FIBR_CONN fiber, CM_CARD fromcard, CM_CARD tocard, CM_FACILITY, CM_INTERFACE, nm_circuit_crs_cache ffp
                    WHERE FAC_ID=ffp.from_id AND fromcard.CARD_ID=CONN_FROM_ID AND tocard.CARD_ID=CONN_TO_ID AND fromcard.NE_ID=fiber.NE_ID AND tocard.NE_ID=fiber.NE_ID
                         AND CONN_TOPORT=fac_aid_port AND INTF_ID=FAC_PARENT_ID AND CONN_TO_ID=INTF_PARENT_ID
            )LOOP
                o_toIdList.EXTEND; o_toIdList(o_toIdList.COUNT) := l_fiber.toId;
                o_neIdList.EXTEND; o_neIdList(o_neIdList.COUNT) := l_fiber.neId;
                o_fromIdList.EXTEND; o_fromIdList(o_fromIdList.COUNT) := l_fiber.fromId;
                o_fromPortList.EXTEND; o_fromPortList(o_fromPortList.COUNT) := l_fiber.fromPort;
                o_toPortList.EXTEND; o_toPortList(o_toPortList.COUNT) := l_fiber.toPort;
                o_channelList.EXTEND; o_channelList(o_channelList.COUNT) := l_fiber.channel;
                o_dwdmSideList.EXTEND; o_dwdmSideList(o_dwdmSideList.COUNT) := l_fiber.dwdmSide;
                o_fromAidList.EXTEND; o_fromAidList(o_fromAidList.COUNT) := l_fiber.fromAid;
                o_toAidList.EXTEND; o_toAidList(o_toAidList.COUNT) := l_fiber.toAid;
                o_usageList.EXTEND; o_usageList(o_usageList.COUNT) := l_fiber."usage";
            END LOOP;
        END IF;
        IF (ffpToIdList IS NOT NULL AND ffpToIdList.COUNT != 0) THEN
            FOR l_fiber IN (
                SELECT to_char(fiber.NE_ID)  neId,      to_char(CONN_FROM_ID) fromId,to_char(CONN_TO_ID) toId,
                       to_char(nvl(CONN_FROMPORT,0)) fromPort, to_char(nvl(CONN_TOPORT,0)) toPort, to_char(nvl(CONN_FROMPORT,0)) channel,
                       nvl(CONN_DWDMSIDE,'') dwdmSide, nvl(fromcard.CARD_AID,'') fromAid, nvl(tocard.CARD_AID,'') toAid,
                       'DEGREE' "usage"
                  FROM CM_FIBR_CONN fiber, CM_CARD fromcard, CM_CARD tocard, CM_FACILITY, CM_INTERFACE, nm_circuit_crs_cache ffp
                    WHERE FAC_ID=ffp.to_id AND fromcard.CARD_ID=CONN_FROM_ID AND tocard.CARD_ID=CONN_TO_ID AND fromcard.NE_ID=fiber.NE_ID AND tocard.NE_ID=fiber.NE_ID
                         AND CONN_TOPORT=fac_aid_port AND INTF_ID=FAC_PARENT_ID AND CONN_TO_ID=INTF_PARENT_ID
            )LOOP
                o_toIdList.EXTEND; o_toIdList(o_toIdList.COUNT) := l_fiber.toId;
                o_neIdList.EXTEND; o_neIdList(o_neIdList.COUNT) := l_fiber.neId;
                o_fromIdList.EXTEND; o_fromIdList(o_fromIdList.COUNT) := l_fiber.fromId;
                o_fromPortList.EXTEND; o_fromPortList(o_fromPortList.COUNT) := l_fiber.fromPort;
                o_toPortList.EXTEND; o_toPortList(o_toPortList.COUNT) := l_fiber.toPort;
                o_channelList.EXTEND; o_channelList(o_channelList.COUNT) := l_fiber.channel;
                o_dwdmSideList.EXTEND; o_dwdmSideList(o_dwdmSideList.COUNT) := l_fiber.dwdmSide;
                o_fromAidList.EXTEND; o_fromAidList(o_fromAidList.COUNT) := l_fiber.fromAid;
                o_toAidList.EXTEND; o_toAidList(o_toAidList.COUNT) := l_fiber.toAid;
                o_usageList.EXTEND; o_usageList(o_usageList.COUNT) := l_fiber."usage";
            END LOOP;
        END IF;
        COMMIT;
        circuit_util.print_end('getFiberInfo');
     END getFiberInfo;

    PROCEDURE getConnectionInfo(
        fromIdList             IN V_B_STRING,           toIdList                 IN V_B_STRING,
        o_neIdList             OUT NOCOPY V_B_STRING,   o_fromDwdmSideList       OUT NOCOPY V_B_STRING,  o_toDwdmSideList         OUT NOCOPY V_B_STRING,
        o_xcTypeList           OUT NOCOPY V_B_STRING,   o_ccPathList             OUT NOCOPY V_B_STRING,  o_groupIdList            OUT NOCOPY V_B_STRING,
        o_circuitIdList        OUT NOCOPY V_B_STRING,   o_holdOffProtList        OUT NOCOPY V_B_STRING,  o_contIdList             OUT NOCOPY V_B_STRING,
        o_protnIdList          OUT NOCOPY V_B_STRING,   o_dropIdList             OUT NOCOPY V_B_STRING,  o_fromEquipmentAidList   OUT NOCOPY V_B_STRING,
        o_toEquipmentAidList   OUT NOCOPY V_B_STRING,   o_fromFacilityList       OUT NOCOPY V_B_STRING,  o_toFacilityList         OUT NOCOPY V_B_STRING,
        o_neNameList           OUT NOCOPY V_B_STRING,   o_fromFacilityAidList    OUT NOCOPY V_B_STRING,  o_toFacilityAidList      OUT NOCOPY V_B_STRING,
        o_fromOtherAidList     OUT NOCOPY V_B_STRING,   o_toOtherAidList         OUT NOCOPY V_B_STRING,  o_fromPortList           OUT NOCOPY V_B_STRING,
        o_toPortList           OUT NOCOPY V_B_STRING
    ) AS
        i                      INTEGER := 1;
    BEGIN circuit_util.print_start('getConnectionInfo');

        o_neIdList               := V_B_STRING();        o_fromDwdmSideList       := V_B_STRING();        o_toDwdmSideList         := V_B_STRING();
        o_xcTypeList             := V_B_STRING();        o_ccPathList             := V_B_STRING();        o_groupIdList            := V_B_STRING();
        o_circuitIdList          := V_B_STRING();        o_holdOffProtList        := V_B_STRING();        o_contIdList             := V_B_STRING();
        o_protnIdList            := V_B_STRING();        o_dropIdList             := V_B_STRING();        o_fromEquipmentAidList   := V_B_STRING();
        o_toEquipmentAidList     := V_B_STRING();        o_fromFacilityList       := V_B_STRING();        o_toFacilityList         := V_B_STRING();
        o_neNameList             := V_B_STRING();        o_fromFacilityAidList    := V_B_STRING();        o_toFacilityAidList      := V_B_STRING();
        o_fromOtherAidList       := V_B_STRING();        o_toOtherAidList         := V_B_STRING();        o_fromPortList           := V_B_STRING();
        o_toPortList             := V_B_STRING();

        circuit_util.print_line('Total connections requested: '||fromIdList.COUNT);
        EXECUTE IMMEDIATE 'insert into NM_CIRCUIT_CRS_CACHE(from_id,to_id,row_num) SELECT from_id,to_id,rownum FROM (select column_value from_id, rownum rn from TABLE(CAST(:1 AS V_B_STRING))) f, (SELECT column_value to_id, rownum rn FROM TABLE(CAST(:2 AS V_B_STRING))) t WHERE f.rn=t.rn' USING fromIdList,toIdList;
        FOR l_conn IN (
          SELECT * FROM(
            -- Following SQL gets all simple XCs in which supplied from/to OCH is the source/target
             SELECT crs.NE_ID neId, circuit_util.getConnectionEquipmentSide(ne.NE_ID,ochfrom.OCH_ID) fromDwdmSide,circuit_util.getConnectionEquipmentSide(ne.NE_ID,ochto.OCH_ID) toDwdmSide,
                    nvl(crs.CRS_CCTYPE,'') xcType, nvl(crs.CRS_CCPATH,'') ccPath, nvl(crs.CRS_GROUP_KEY,'') groupId,
                    nvl(crs.CRS_CKTID,'') circuitId, circuit_util.determineConnectionWorkOrProt(crs.CRS_CCTYPE, ochfrom.OCH_PARENT_ID, ochto.OCH_PARENT_ID, ochfrom.och_id, ochto.och_id) holdOffProt, '' contId,
                    nvl(crs.CRS_PROTECTION,'') protnId,'' dropId, circuit_util.getConnectionSupportingEqpt(fromCp.CARD_AID,crs.NE_ID,ochfrom.OCH_ID) fromEquipmentAid,
                    circuit_util.getConnectionSupportingEqpt(toCp.CARD_AID,crs.NE_ID,ochto.OCH_ID) toEquipmentAid, crs.CRS_FROM_ID fromFacility,crs.CRS_TO_ID toFacility,
                    ne.NE_TID neName,ochfrom.OCH_AID fromFacilityAid, ochto.OCH_AID toFacilityAid,
                    circuit_util.getNonforeignWavelengthOCH(ne.NE_ID,ne.NE_STYPE,crs.CRS_TO_ID,fromCp.CARD_ID,crs.CRS_CCPATH) fromOtherAid,circuit_util.getNonforeignWavelengthOCH(ne.NE_ID,ne.NE_STYPE,crs.CRS_FROM_ID,toCp.CARD_ID,crs.CRS_CCPATH) toOtherAid, DECODE(to_char(CRS_FROM_PORT),'',to_char(ochfrom.OCH_AID_PORT),to_char(CRS_FROM_PORT)) fromPort, DECODE(to_char(CRS_TO_PORT),'',to_char(ochto.OCH_AID_PORT),to_char(CRS_TO_PORT)) toPort, xc.row_num
                FROM CM_CRS crs, CM_CHANNEL_OCH ochfrom, CM_CHANNEL_OCH ochto, CM_CARD fromCp, CM_CARD toCp, EMS_NE ne, NM_CIRCUIT_CRS_CACHE xc
                WHERE crs.CRS_FROM_ID=xc.from_id AND crs.CRS_TO_ID=xc.to_id AND ne.NE_ID=crs.NE_ID AND crs.CRS_FROM_ID=ochfrom.OCH_ID AND crs.CRS_TO_ID=ochto.OCH_ID AND crs.NE_ID=fromCp.NE_ID(+) AND nvl(crs.CRS_FROM_CP_AID, '0')=fromCp.CARD_AID(+) AND crs.NE_ID=toCp.NE_ID(+) AND nvl(crs.CRS_TO_CP_AID, '0')=toCp.CARD_AID(+)
               UNION
              -- Following SQL gets all port facility XCs in which supplied from/to facility is the source/target
              SELECT crs.NE_ID neId,'' fromDwdmSide,'' toDwdmSide,
                    nvl(crs.CRS_CCTYPE,'') xcType,nvl(crs.CRS_CCPATH,'') ccPath,nvl(crs.CRS_GROUP_KEY,'') groupId,
                    nvl(crs.CRS_CKTID,'') circuitId, '' holdOffProt, '' contId,
                    nvl(crs.CRS_PROTECTION,'') protnId, '' dropId, '' fromEquipmentAid,
                    '' toEquipmentAid, crs.CRS_FROM_ID fromFacility, crs.CRS_TO_ID toFacility,
                    ne.NE_TID neName, facfrom.FAC_AID fromFacilityAid, facto.FAC_AID toFacilityAid,
                    '' fromOtherAid, '' toOtherAid, DECODE(to_char(CRS_FROM_PORT),'',to_char(facfrom.FAC_AID_PORT),to_char(CRS_FROM_PORT)) fromPort, DECODE(to_char(CRS_TO_PORT),'',to_char(facto.FAC_AID_PORT),to_char(CRS_TO_PORT)) toPort, xc.row_num
                FROM CM_CRS crs, CM_FACILITY facfrom, CM_FACILITY facto, EMS_NE ne, NM_CIRCUIT_CRS_CACHE xc
                WHERE (facfrom.FAC_ID=xc.from_id AND facto.FAC_ID=xc.to_id) AND ne.NE_ID=crs.NE_ID AND crs.CRS_FROM_ID=facfrom.FAC_ID AND crs.CRS_TO_ID=facto.FAC_ID
               UNION
              -- Following SQL gets all protecting connections from supplied OCH-P/OCH-CP in which supplied OCH in 2WAYBR(Add/Drop) or 1WAYBR(Add) connection
              SELECT crs.NE_ID neId, circuit_util.getConnectionEquipmentSide(ne.NE_ID,ochfrom.OCH_ID) fromDwdmSide,circuit_util.getConnectionEquipmentSide(ne.NE_ID,ochProt.OCH_ID) toDwdmSide,
                    nvl(crs.CRS_CCTYPE,'') xcType, nvl(crs.CRS_CCPATH,'') ccPath, nvl(crs.CRS_GROUP_KEY,'') groupId,
                    nvl(crs.CRS_CKTID,'') circuitId, 'P' holdOffProt, '' contId,
                    circuit_util.getConnectionProtection(crs.CRS_FROM_ID, crs.CRS_TO_ID,ochfrom.OCH_ID,ochfrom.OCH_AID) protnId,'' dropId, circuit_util.getConnectionSupportingEqpt('',crs.NE_ID,ochfrom.OCH_ID) fromEquipmentAid,
                    circuit_util.getConnectionSupportingEqpt('',crs.NE_ID,ochProt.OCH_ID) toEquipmentAid, crs.CRS_FROM_ID fromFacility, crs.CRS_TO_ID toFacility,
                    ne.NE_TID neName, ochfrom.OCH_AID fromFacilityAid, ochProt.OCH_AID toFacilityAid,
                    '' fromOtherAid,'' toOtherAid, DECODE(to_char(CRS_FROM_PORT),'',to_char(ochfrom.OCH_AID_PORT),to_char(CRS_FROM_PORT)) fromPort, DECODE(to_char(CRS_TO_PORT),'',to_char(ochProt.OCH_AID_PORT),to_char(CRS_TO_PORT)) toPort, xc.row_num
                FROM CM_CRS crs, CM_CHANNEL_OCH ochfrom, CM_CHANNEL_OCH ochProt, EMS_NE ne, NM_CIRCUIT_CRS_CACHE xc
                WHERE (ochfrom.OCH_ID=xc.from_id AND ochProt.OCH_ID=xc.to_id) AND ne.NE_ID=crs.NE_ID AND crs.NE_ID=ochfrom.NE_ID AND crs.CRS_PROTECTION_ID=ochProt.OCH_ID AND (crs.CRS_FROM_ID=ochfrom.OCH_ID OR crs.CRS_TO_ID=ochfrom.OCH_ID) AND CRS_CCPATH like 'ADD%' AND ((ochfrom.OCH_TYPE = 'P' OR ochfrom.OCH_TYPE = 'CP' OR ochfrom.OCH_TYPE = '1') AND ochProt.OCH_TYPE = 'L')
               UNION
              -- Following SQL gets all protecting connections from supplied OCH-P/OCH-CP in which supplied OCH in 2WAYPR(Add/Drop) or 1WAYPR(DROP) connection
              SELECT crs.NE_ID neId, circuit_util.getConnectionEquipmentSide(ne.NE_ID,ochProt.OCH_ID) fromDwdmSide, circuit_util.getConnectionEquipmentSide(ne.NE_ID,ochfrom.OCH_ID) toDwdmSide,
                  nvl(crs.CRS_CCTYPE,'') xcType, nvl(crs.CRS_CCPATH,'') ccPath, nvl(crs.CRS_GROUP_KEY,'') groupId,
                  nvl(crs.CRS_CKTID,'') circuitId, 'P' holdOffProt, '' contId,
                  circuit_util.getConnectionProtection(crs.CRS_FROM_ID, crs.CRS_TO_ID,ochfrom.OCH_ID,ochfrom.OCH_AID) protnId,'' dropId, circuit_util.getConnectionSupportingEqpt('',crs.NE_ID,ochProt.OCH_ID) fromEquipmentAid,
                  --from -->to, to-->from
                  circuit_util.getConnectionSupportingEqpt('',crs.NE_ID,ochfrom.OCH_ID) toEquipmentAid, ochProt.och_id fromFacility, ochfrom.och_id toFacility,
                  ne.NE_TID neName, ochProt.OCH_AID fromFacilityAid, ochfrom.OCH_AID toFacilityAid,
                  '' fromOtherAid, '' toOtherAid,  to_char(ochProt.OCH_AID_PORT) fromPort, to_char(ochfrom.OCH_AID_PORT) toPort, xc.row_num
                FROM CM_CRS crs, CM_CHANNEL_OCH ochfrom, CM_CHANNEL_OCH ochProt, EMS_NE ne, NM_CIRCUIT_CRS_CACHE xc
                WHERE (ochProt.OCH_ID=xc.from_id AND ochfrom.OCH_ID=xc.to_id) AND ne.NE_ID=crs.NE_ID AND crs.NE_ID=ochfrom.NE_ID AND crs.CRS_PROTECTION_ID=ochProt.OCH_ID AND (crs.CRS_FROM_ID=ochfrom.OCH_ID OR crs.CRS_TO_ID=ochfrom.OCH_ID) AND CRS_CCPATH like '%DROP%' AND ((ochfrom.OCH_TYPE = 'P' OR ochfrom.OCH_TYPE = 'CP' OR ochfrom.OCH_TYPE = '1') AND ochProt.OCH_TYPE = 'L')
               UNION
              -- Following SQL returns fake connections for OLA/OLU NE
              SELECT ne.NE_ID neId, circuit_util.getConnectionEquipmentSide(ne.NE_ID,ochfrom.OCH_ID) fromDwdmSide,circuit_util.getConnectionEquipmentSide(ne.NE_ID,ochto.OCH_ID) toDwdmSide,
                  '2WAY' xcType, circuit_util.generateOLAOLUccPath(ne.NE_TYPE) ccPath, '' groupId,
                  '' circuitId, '' holdOffProt, '' contId,
                  '' protnId, '' dropId, '' fromEquipmentAid,
                  '' toEquipmentAid, ochfrom.OCH_ID fromFacility, ochto.OCH_ID toFacility,
                  ne.NE_TID neName, ochfrom.OCH_AID fromFacilityAid,ochto.OCH_AID toFacilityAid,
                  '' fromOtherAid, '' toOtherAid, '0' fromPort, '0' toPort, xc.row_num
                  FROM CM_CHANNEL_OCH ochfrom, CM_CHANNEL_OCH ochto, EMS_NE ne, NM_CIRCUIT_CRS_CACHE xc
                WHERE (ochfrom.OCH_ID=xc.from_id AND ochto.OCH_ID=xc.to_id) AND ne.NE_ID=ochfrom.NE_ID AND (ne.NE_TYPE LIKE '%OLA%' OR ne.NE_TYPE LIKE '%OLU%')
          ) ORDER BY row_num
        ) LOOP
            o_neIdList.EXTEND; o_neIdList(i) := l_conn.neId;
            o_fromDwdmSideList.EXTEND; o_fromDwdmSideList(i) := l_conn.fromDwdmSide;
            o_toDwdmSideList.EXTEND; o_toDwdmSideList(i) := l_conn.toDwdmSide;
            o_xcTypeList.EXTEND; o_xcTypeList(i) := l_conn.xcType;
            o_ccPathList.EXTEND; o_ccPathList(i) := l_conn.ccPath;
            o_groupIdList.EXTEND; o_groupIdList(i) := l_conn.groupId;
            o_circuitIdList.EXTEND; o_circuitIdList(i) := l_conn.circuitId;
            o_holdOffProtList.EXTEND; o_holdOffProtList(i) := l_conn.holdOffProt;
            o_contIdList.EXTEND; o_contIdList(i) := l_conn.contId;
            o_protnIdList.EXTEND; o_protnIdList(i) := l_conn.protnId;
            o_dropIdList.EXTEND; o_dropIdList(i) := l_conn.dropId;
            o_fromEquipmentAidList.EXTEND; o_fromEquipmentAidList(i) := l_conn.fromEquipmentAid;
            o_toEquipmentAidList.EXTEND; o_toEquipmentAidList(i) := l_conn.toEquipmentAid;
            o_fromFacilityList.EXTEND; o_fromFacilityList(i) := l_conn.fromFacility;
            o_toFacilityList.EXTEND; o_toFacilityList(i) := l_conn.toFacility;
            o_neNameList.EXTEND; o_neNameList(i) := l_conn.neName;
            o_fromFacilityAidList.EXTEND; o_fromFacilityAidList(i) := l_conn.fromFacilityAid;
            o_toFacilityAidList.EXTEND; o_toFacilityAidList(i) := l_conn.toFacilityAid;
            o_fromOtherAidList.EXTEND; o_fromOtherAidList(i) := l_conn.fromOtherAid;
            o_toOtherAidList.EXTEND; o_toOtherAidList(i) := l_conn.toOtherAid;
            o_fromPortList.EXTEND; o_fromPortList(i) := l_conn.fromPort;
            o_toPortList.EXTEND; o_toPortList(i) := l_conn.toPort;
            i := i + 1;
        END LOOP;
        COMMIT;
    circuit_util.print_end('getConnectionInfo');
    END getConnectionInfo;

    PROCEDURE getSTSConnectionInfo(
        fromIdList                 IN V_B_STRING,          toIdList                    IN V_B_STRING,
        ifromCompositeMapList      IN V_B_EXTEXT,          itoCompositeMapList         IN V_B_EXTEXT,
        o_neIdList                 OUT NOCOPY V_B_STRING,  o_xcTypeList                OUT NOCOPY V_B_STRING, o_ccPathList             OUT NOCOPY V_B_STRING,
        o_circuitIdList            OUT NOCOPY V_B_STRING,  o_fromEquipmentAidList      OUT NOCOPY V_B_STRING, o_toEquipmentAidList     OUT NOCOPY V_B_STRING,
        o_fromFacilityList         OUT NOCOPY V_B_STRING,  o_toFacilityList            OUT NOCOPY V_B_STRING, o_neNameList             OUT NOCOPY V_B_STRING,
        o_fromFacilityAidList      OUT NOCOPY V_B_STRING,  o_fromMultiFacilityAidList  OUT NOCOPY V_B_STRING, o_toFacilityAidList      OUT NOCOPY V_B_STRING,
        o_toMultiFacilityAidList   OUT NOCOPY V_B_STRING,  o_fromProtFacilityAidList   OUT NOCOPY V_B_STRING, o_toProtFacilityAidList  OUT NOCOPY V_B_STRING,
        o_splitList                OUT NOCOPY V_B_STRING,  o_fromCompositeMapList      OUT NOCOPY V_B_EXTEXT, o_toCompositeMapList     OUT NOCOPY V_B_EXTEXT,
        o_fromVCGAidList           OUT NOCOPY V_B_STRING,  o_toVCGAidLIst              OUT NOCOPY V_B_STRING, o_redlineList            OUT NOCOPY V_B_STRING,
        o_fromProtEquipmentAidList OUT NOCOPY V_B_STRING,  o_toProtEquipmentAidList    OUT NOCOPY V_B_STRING, o_fromProtFacilityIdList OUT NOCOPY V_B_STRING,
        o_toProtFacilityIdList     OUT NOCOPY V_B_STRING
    ) AS
        i                      INTEGER := 1;
        sts1map                VARCHAR2(800);
    BEGIN circuit_util.print_start('getSTSConnectionInfo');
        o_neIdList                 := V_B_STRING();        o_xcTypeList             := V_B_STRING();        o_ccPathList             := V_B_STRING();
        o_circuitIdList            := V_B_STRING();        o_fromEquipmentAidList   := V_B_STRING();        o_toEquipmentAidList     := V_B_STRING();
        o_fromFacilityList         := V_B_STRING();        o_toFacilityList         := V_B_STRING();        o_neNameList             := V_B_STRING();
        o_fromFacilityAidList      := V_B_STRING();        o_fromMultiFacilityAidList   := V_B_STRING();    o_toFacilityAidList      := V_B_STRING();
        o_toMultiFacilityAidList   := V_B_STRING();        o_fromProtFacilityAidList  := V_B_STRING();      o_toProtFacilityAidList    := V_B_STRING();
        o_splitList                := V_B_STRING();        o_fromCompositeMapList     := V_B_EXTEXT();      o_toCompositeMapList       := V_B_EXTEXT();
        o_fromVCGAidList           := V_B_STRING();        o_toVCGAidList             := V_B_STRING();      o_redlineList              := V_B_STRING();
        o_fromProtEquipmentAidList := V_B_STRING();        o_toProtEquipmentAidList   := V_B_STRING();      o_fromProtFacilityIdList   := V_B_STRING();
        o_toProtFacilityIdList     := V_B_STRING();

        circuit_util.print_line('Total STS connections requested: '||fromIdList.COUNT);
        EXECUTE IMMEDIATE 'insert into NM_CIRCUIT_CRS_CACHE(from_id,to_id, from_composite_map, to_composite_map,row_num) SELECT from_id,to_id,from_composite_map, to_composite_map,rownum FROM (select column_value from_id, rownum rn from TABLE(CAST(:1 AS V_B_STRING))) f, (SELECT column_value to_id, rownum rn FROM TABLE(CAST(:2 AS V_B_STRING))) t, (select column_value from_composite_map, rownum rn from TABLE(CAST(:3 AS V_B_EXTEXT))) fm, (SELECT column_value to_composite_map, rownum rn FROM TABLE(CAST(:4 AS V_B_EXTEXT))) tm  WHERE f.rn=t.rn AND t.rn=fm.rn AND fm.rn=tm.rn' USING fromIdList,toIdList,ifromCompositeMapList,itoCompositeMapList ;
        FOR l_conn IN (
          SELECT * FROM(
              SELECT card.NE_ID neId, '2WAY' xcType, '' ccPath,
                  '' circuitId, card.CARD_AID fromEquipmentAid, card.CARD_AID toEquipmentAid,
                  facfrom.FAC_ID fromFacility, facto.FAC_ID toFacility, ne.NE_TID neName,
                  facfrom.FAC_AID fromFacilityAid, '' fromMultiFacilityAid, facto.FAC_AID toFacilityAid,
                  circuit_util.getOTNMXCedAllLineFacility(facfrom.FAC_STS1MAP,facfrom.NE_ID,card.CARD_ID,card.CARD_AID) toMultiFacilityAid, '' fromProtFacilityAid, '' toProtFacilityAid,
                  'primary' "split", '' fromVCGAid, '' toVCGAid,
                  '' redline, '' fromProtEquipmentAid, '' toProtEquipmentAid,
                  '' fromProtFacilityId, '' toProtFacilityId, '' fromCompositeMap, '' toCompositeMap, xc.row_num row_num
                FROM CM_FACILITY facfrom, CM_FACILITY facto, CM_CARD card, EMS_NE ne, NM_CIRCUIT_CRS_CACHE xc
                WHERE facfrom.FAC_ID=xc.from_id AND facto.FAC_ID=xc.to_id AND ne.NE_ID=facfrom.NE_ID AND card.CARD_ID=facfrom.FAC_PARENT_ID AND card.CARD_ID=facto.FAC_PARENT_ID AND facto.FAC_AID like 'ODU1-C%'
              UNION
              -- The following SQL gets the fake OTNM XC's
              SELECT card.NE_ID neId, '2WAY' xcType, '' ccPath,
                  '' circuitId, card.CARD_AID fromEquipmentAid, card.CARD_AID toEquipmentAid,
                  facfrom.FAC_ID fromFacility, facto.FAC_ID toFacility, ne.NE_TID neName,
                  facfrom.FAC_AID fromFacilityAid, circuit_util.getOTNMXCedAllLineFacility(facto.FAC_STS1MAP,facto.NE_ID,card.CARD_ID,card.CARD_AID) fromMultiFacilityAid, facto.FAC_AID toFacilityAid,
                  '' toMultiFacilityAid, '' fromProtFacilityAid, '' toProtFacilityAid,
                  'primary' "split", '' fromVCGAid, '' toVCGAid,
                  '' redline, '' fromProtEquipmentAid, '' toProtEquipmentAid,
                  '' fromProtFacilityId, '' toProtFacilityId, '' fromCompositeMap, '' toCompositeMap, xc.row_num row_num
                FROM CM_FACILITY facfrom, CM_FACILITY facto, CM_CARD card, EMS_NE ne, NM_CIRCUIT_CRS_CACHE xc
                WHERE facfrom.FAC_ID=xc.from_id AND facto.FAC_ID=xc.to_id AND ne.NE_ID=facfrom.NE_ID AND card.CARD_ID=facfrom.FAC_PARENT_ID AND card.CARD_ID=facto.FAC_PARENT_ID AND  facfrom.FAC_AID like 'ODU1-C%'
              UNION
              -- Following SQL gets all STS facility XCs in which supplied from/to facility is the source/target
              SELECT crs.NE_ID neId, nvl(crs.CRS_STS_CCTYPE,'') xcType, nvl(crs.CRS_STS_CCPATH,'') ccPath,
                  nvl(crs.CRS_STS_CKTID,'') circuitId, nvl(nvl(cardfrom.CARD_AID,circuit_util.getVCGCardAid(facfrom.STS_TTP_VCG_ID)),circuit_util.getFacCardAid(facfrom.STS_ID)) fromEquipmentAid, nvl(nvl(cardto.CARD_AID,circuit_util.getVCGCardAid(facto.STS_TTP_VCG_ID)),circuit_util.getFacCardAid(facto.STS_ID)) toEquipmentAid,
                  crs.CRS_STS_FROM_ID fromFacility, crs.CRS_STS_TO_ID toFacility, ne.NE_TID neName,
                  facfrom.STS_AID fromFacilityAid, '' fromMultiFacilityAid, facto.STS_AID toFacilityAid,
                  '' toMultiFacilityAid, crs.CRS_STS_SRC_PROT fromProtFacilityAid, crs.CRS_STS_DEST_PROT toProtFacilityAid,
                  'primary' split, nvl(facfrom.STS_TTP_VCG_AID,circuit_util.getFacilityParentAid(facfrom.STS_ID, facfrom.STS_AID)) fromVCGAid, nvl(facto.STS_TTP_VCG_AID,circuit_util.getFacilityParentAid(facto.STS_ID, facto.STS_AID)) toVCGAid,
                  DECODE(INSTR(Nvl(crs.CRS_STS_SST,'-'),'RDLD'),0,'NO','YES') redline, '' fromProtEquipmentAid, '' toProtEquipmentAid,
                  to_char(crs.CRS_STS_SRC_PROT_ID) fromProtFacilityId, to_char(crs.CRS_STS_DEST_PROT_ID) toProtFacilityId, facfrom.STS_STS1MAP fromCompositeMap, facto.STS_STS1MAP toCompositeMap, xc.row_num row_num
                FROM CM_CRS_STS crs, CM_STS facfrom, CM_STS facto, CM_FACILITY pffrom, CM_FACILITY pfto, CM_CARD cardFrom, CM_CARD cardto, EMS_NE ne, NM_CIRCUIT_CRS_CACHE xc
                WHERE facfrom.STS_ID=xc.from_id AND facto.STS_ID=xc.to_id AND ne.NE_ID=crs.NE_ID AND crs.CRS_STS_FROM_ID=facfrom.STS_ID AND crs.CRS_STS_TO_ID=facto.STS_ID AND pffrom.FAC_ID(+)=facfrom.STS_PARENT_ID AND pfto.FAC_ID(+)=facto.STS_PARENT_ID AND cardfrom.CARD_ID(+)=pffrom.FAC_PARENT_ID AND cardto.CARD_ID(+)=pfto.FAC_PARENT_ID
             UNION
            -- Following SQL gets all WAYBR with DEST PROTECT
             SELECT crs.NE_ID neId, nvl(crs.CRS_STS_CCTYPE,'') xcType, nvl(crs.CRS_STS_CCPATH,'') ccPath,
                  nvl(crs.CRS_STS_CKTID,'') circuitId, nvl(nvl(cardfrom.CARD_AID,circuit_util.getVCGCardAid(facfrom.STS_TTP_VCG_ID)),circuit_util.getFacCardAid(facfrom.STS_ID)) fromEquipmentAid, nvl(nvl(cardto.CARD_AID,circuit_util.getVCGCardAid(facto.STS_TTP_VCG_ID)),circuit_util.getFacCardAid(facto.STS_ID)) toEquipmentAid,
                  facfrom.STS_ID fromFacility, facto.STS_ID toFacility, ne.NE_TID neName,
                  facfrom.STS_AID fromFacilityAid, '' fromMultiFacilityAid, facto.STS_AID toFacilityAid,
                  '' toMultiFacilityAid, facfromprot.sts_aid fromProtFacilityAid, factoprot.sts_aid toProtFacilityAid,
                  'secondary' "split", nvl(facfrom.STS_TTP_VCG_AID,circuit_util.getFacilityParentAid(facfrom.STS_ID, facfrom.STS_AID)) fromVCGAid, nvl(facto.STS_TTP_VCG_AID,circuit_util.getFacilityParentAid(facto.STS_ID, facto.STS_AID)) toVCGAid,
                  DECODE(INSTR(Nvl(crs.CRS_STS_SST,'-'),'RDLD'),0,'NO','YES') redline, '' fromProtEquipmentAid, '' toProtEquipmentAid,
                  to_char(facfromprot.sts_id) fromProtFacilityId, to_char(factoprot.sts_id) toProtFacilityId,  facfrom.STS_STS1MAP fromCompositeMap, facto.STS_STS1MAP toCompositeMap, xc.row_num row_num
             FROM CM_CRS_STS crs, CM_STS facfrom, CM_STS facto, CM_STS facfromprot, CM_STS factoprot, CM_FACILITY pffrom, CM_FACILITY pfto, CM_CARD cardFrom, CM_CARD cardto, EMS_NE ne, NM_CIRCUIT_CRS_CACHE xc
             WHERE facfrom.STS_ID=xc.from_id AND facto.STS_ID=xc.to_id AND ne.NE_ID=crs.NE_ID AND crs.CRS_STS_FROM_ID=facfrom.STS_ID AND crs.CRS_STS_DEST_PROT=facto.STS_AID AND facfromprot.sts_id(+)=crs.crs_sts_src_prot_id AND factoprot.sts_id(+)=crs.crs_sts_to_id AND pffrom.FAC_ID(+)=facfrom.STS_PARENT_ID AND pfto.FAC_ID(+)=facto.STS_PARENT_ID AND cardfrom.CARD_ID(+)=pffrom.FAC_PARENT_ID AND cardto.CARD_ID(+)=pfto.FAC_PARENT_ID
             UNION
            -- Following SQL gets all WAYPR with SRC PROT
             SELECT crs.NE_ID neId, nvl(crs.CRS_STS_CCTYPE,'') xcType, nvl(crs.CRS_STS_CCPATH,'') ccPath,
                  nvl(crs.CRS_STS_CKTID,'') circuitId, nvl(nvl(cardfrom.CARD_AID,circuit_util.getVCGCardAid(facfrom.STS_TTP_VCG_ID)),circuit_util.getFacCardAid(facfrom.STS_ID)) fromEquipmentAid, nvl(nvl(cardto.CARD_AID,circuit_util.getVCGCardAid(facto.STS_TTP_VCG_ID)),circuit_util.getFacCardAid(facto.STS_ID)) toEquipmentAid,
                  facfrom.STS_ID fromFacility, facto.STS_ID toFacility, ne.NE_TID neName,
                  facfrom.STS_AID fromFacilityAid, '' fromMultiFacilityAid, facto.STS_AID toFacilityAid,
                  '' toMultiFacilityAid, facfromprot.sts_aid fromProtFacilityAid, factoprot.sts_aid toProtFacilityAid,
                  'secondary' "split", nvl(facfrom.STS_TTP_VCG_AID,circuit_util.getFacilityParentAid(facfrom.STS_ID, facfrom.STS_AID)) fromVCGAid, nvl(facto.STS_TTP_VCG_AID,circuit_util.getFacilityParentAid(facto.STS_ID, facto.STS_AID)) toVCGAid,
                  DECODE(INSTR(Nvl(crs.CRS_STS_SST,'-'),'RDLD'),0,'NO','YES') redline, '' fromProtEquipmentAid, '' toProtEquipmentAid,
                  to_char(facfromprot.sts_id) fromProtFacilityId, to_char(facfromprot.sts_id) toProtFacilityId, facfrom.STS_STS1MAP fromCompositeMap, facto.STS_STS1MAP toCompositeMap, xc.row_num row_num
             FROM CM_CRS_STS crs, CM_STS facfrom, CM_STS facto, CM_STS facfromprot, CM_STS factoprot, CM_FACILITY pffrom, CM_FACILITY pfto, CM_CARD cardFrom, CM_CARD cardto, EMS_NE ne, NM_CIRCUIT_CRS_CACHE xc
             WHERE facfrom.STS_ID=xc.from_id AND facto.STS_ID=xc.to_id AND ne.NE_ID=crs.NE_ID AND crs.CRS_STS_TO_ID=facto.STS_ID AND crs.CRS_STS_SRC_PROT=facfrom.STS_AID AND facfromprot.sts_id(+)=crs.crs_sts_from_id AND factoprot.sts_id(+)=crs.crs_sts_dest_prot_id AND pffrom.FAC_ID(+)=facfrom.STS_PARENT_ID AND pfto.FAC_ID(+)=facto.STS_PARENT_ID AND cardfrom.CARD_ID(+)=pffrom.FAC_PARENT_ID AND cardto.CARD_ID(+)=pfto.FAC_PARENT_ID
             UNION
            -- Following SQL gets all WAYPR with DEST PROT
             SELECT crs.NE_ID neId, nvl(crs.CRS_STS_CCTYPE,'') xcType, nvl(crs.CRS_STS_CCPATH,'') ccPath,
                nvl(crs.CRS_STS_CKTID,'') circuitId, nvl(nvl(cardfrom.CARD_AID,circuit_util.getVCGCardAid(facfrom.STS_TTP_VCG_ID)),circuit_util.getFacCardAid(facfrom.STS_ID)) fromEquipmentAid, nvl(nvl(cardto.CARD_AID,circuit_util.getVCGCardAid(facto.STS_TTP_VCG_ID)),circuit_util.getFacCardAid(facto.STS_ID)) toEquipmentAid,
                facfrom.STS_ID fromFacility, facto.STS_ID toFacility, ne.NE_TID neName,
                facfrom.STS_AID fromFacilityAid, '' fromMultiFacilityAid, facto.STS_AID toFacilityAid,
                '' toMultiFacilityAid, crs.CRS_STS_SRC_PROT fromProtFacilityAid, factoProt.sts_aid toProtFacilityAid,
                'secondary' "split", nvl(facfrom.STS_TTP_VCG_AID,circuit_util.getFacilityParentAid(facfrom.STS_ID, facfrom.STS_AID)) fromVCGAid, nvl(facto.STS_TTP_VCG_AID,circuit_util.getFacilityParentAid(facto.STS_ID, facto.STS_AID)) toVCGAid,
                DECODE(INSTR(Nvl(crs.CRS_STS_SST,'-'),'RDLD'),0,'NO','YES') redline, '' fromProtEquipmentAid, '' toProtEquipmentAid,
                to_char(crs.CRS_STS_SRC_PROT_ID) fromProtFacilityId, to_char(factoProt.sts_id) toProtFacilityId, facfrom.STS_STS1MAP fromCompositeMap, facto.STS_STS1MAP toCompositeMap, xc.row_num row_num
             FROM CM_CRS_STS crs, CM_STS facfrom, CM_STS facto, CM_STS factoProt, CM_FACILITY pffrom, CM_FACILITY pfto, CM_CARD cardFrom, CM_CARD cardto, EMS_NE ne, NM_CIRCUIT_CRS_CACHE xc
             WHERE facfrom.STS_ID=xc.from_id AND facto.STS_ID=xc.to_id AND ne.NE_ID=crs.NE_ID AND crs.CRS_STS_DEST_PROT_ID=facto.STS_ID AND crs.CRS_STS_FROM_ID=facfrom.STS_ID  AND crs.crs_sts_to_id=factoProt.sts_id AND pffrom.FAC_ID(+)=facfrom.STS_PARENT_ID AND pfto.FAC_ID(+)=facto.STS_PARENT_ID AND cardfrom.CARD_ID(+)=pffrom.FAC_PARENT_ID AND cardto.CARD_ID(+)=pfto.FAC_PARENT_ID
             UNION
            -- Following SQL gets all WAYPR with SRC PROT and DEST_PROT
             SELECT crs.NE_ID neId, nvl(crs.CRS_STS_CCTYPE,'') xcType, nvl(crs.CRS_STS_CCPATH,'') ccPath,
                  nvl(crs.CRS_STS_CKTID,'') circuitId, nvl(nvl(cardfrom.CARD_AID,circuit_util.getVCGCardAid(facfrom.STS_TTP_VCG_ID)),circuit_util.getFacCardAid(facfrom.STS_ID)) fromEquipmentAid, nvl(nvl(cardto.CARD_AID,circuit_util.getVCGCardAid(facto.STS_TTP_VCG_ID)),circuit_util.getFacCardAid(facto.STS_ID)) toEquipmentAid,
                  facfrom.STS_ID fromFacility, facto.STS_ID toFacility, ne.NE_TID neName,
                  facfrom.STS_AID fromFacilityAid, '' fromMultiFacilityAid, facto.STS_AID toFacilityAid,
                  '' toMultiFacilityAid, facfromprot.sts_aid fromProtFacilityAid, factoprot.sts_aid toProtFacilityAid,
                  'secondary' split, nvl(facfrom.STS_TTP_VCG_AID,circuit_util.getFacilityParentAid(facfrom.STS_ID, facfrom.STS_AID)) fromVCGAid, nvl(facto.STS_TTP_VCG_AID,circuit_util.getFacilityParentAid(facto.STS_ID, facto.STS_AID)) toVCGAid,
                  DECODE(INSTR(Nvl(crs.CRS_STS_SST,'-'),'RDLD'),0,'NO','YES') redline, '' fromProtEquipmentAid, '' toProtEquipmentAid,
                  to_char(facfromprot.sts_id) fromProtFacilityId, to_char(factoprot.sts_id) toProtFacilityId, facfrom.STS_STS1MAP  fromCompositeMap, facto.STS_STS1MAP toCompositeMap, xc.row_num row_num
               FROM CM_CRS_STS crs, CM_STS facfrom, CM_STS facto, CM_STS facfromprot, CM_STS factoprot, CM_FACILITY pffrom, CM_FACILITY pfto, CM_CARD cardFrom, CM_CARD cardto, EMS_NE ne, NM_CIRCUIT_CRS_CACHE xc
               WHERE facfrom.STS_ID=xc.from_id AND facto.STS_ID=xc.to_id AND ne.NE_ID=crs.NE_ID AND ne.ne_id=facfrom.ne_id AND ne.ne_id=facto.ne_id AND crs.CRS_STS_DEST_PROT=facto.STS_AID AND crs.CRS_STS_SRC_PROT=facfrom.STS_AID AND facfromprot.sts_id(+)=crs.crs_sts_from_id AND factoprot.sts_id(+)=crs.crs_sts_to_id AND pffrom.FAC_ID(+)=facfrom.STS_PARENT_ID AND pfto.FAC_ID(+)=facto.STS_PARENT_ID AND cardfrom.CARD_ID(+)=pffrom.FAC_PARENT_ID AND cardto.CARD_ID(+)=pfto.FAC_PARENT_ID
             UNION
            -- Following SQL gets all FGTMM Subrate facility XCs in which supplied where the source/target facility parent is OCH/FAC
             SELECT crs.NE_ID neId, nvl(crs.CRS_ODU_CCTYPE,'') xcType, '' ccPath,
                  nvl(crs.CRS_ODU_CKTID,'') circuitId, cardfrom.CARD_AID fromEquipmentAid, cardto.CARD_AID toEquipmentAid,
                  crs.CRS_ODU_FROM_ID fromFacility, crs.CRS_ODU_TO_ID toFacility, ne.NE_TID neName,
                  facfrom.FAC_AID fromFacilityAid, '' fromMultiFacilityAid, facto.FAC_AID toFacilityAid,
                  '' toMultiFacilityAid, '' fromProtFacilityAid, '' toProtFacilityAid,
                  'primary' "split", '' fromVCGAid, '' toVCGAid,
                  DECODE(INSTR(Nvl(crs.CRS_ODU_SST,'-'),'RDLD'),0,'NO','YES') redline, '' fromProtEquipmentAid, '' toProtEquipmentAid,
                  '' fromProtFacilityId, '' toProtFacilityId, '' fromCompositeMap, '' toCompositeMap, xc.row_num row_num
               FROM CM_CRS_ODU crs, CM_FACILITY facfrom, CM_FACILITY facto, CM_CHANNEL_OCH pffrom, CM_FACILITY pfto, CM_CARD cardFrom, CM_CARD cardto, EMS_NE ne, NM_CIRCUIT_CRS_CACHE xc
               WHERE facfrom.FAC_ID=xc.from_id AND facto.FAC_ID=xc.to_id AND ne.NE_ID=crs.NE_ID AND crs.CRS_ODU_FROM_ID=facfrom.FAC_ID AND crs.CRS_ODU_TO_ID=facto.FAC_ID AND pffrom.OCH_ID=facfrom.FAC_PARENT_ID AND pfto.FAC_ID=facto.FAC_PARENT_ID AND cardfrom.CARD_ID=pffrom.OCH_PARENT_ID AND cardto.CARD_ID=pfto.FAC_PARENT_ID AND cardfrom.CARD_AID_TYPE='FGTMM' AND cardto.CARD_AID_TYPE='FGTMM'
             UNION
            -- Following SQL gets all FGTMM Subrate facility XCs in which supplied where the source/target facility parent is FAC/OCH
             SELECT crs.NE_ID neId, nvl(crs.CRS_ODU_CCTYPE,'') xcType, '' ccPath,
                  nvl(crs.CRS_ODU_CKTID,'') circuitId, cardfrom.CARD_AID fromEquipmentAid, cardto.CARD_AID toEquipmentAid,
                  crs.CRS_ODU_FROM_ID fromFacility, crs.CRS_ODU_TO_ID toFacility, ne.NE_TID neName,
                  facfrom.FAC_AID fromFacilityAid, '' fromMultiFacilityAid, facto.FAC_AID toFacilityAid,
                  '' toMultiFacilityAid, '' fromProtFacilityAid, '' toProtFacilityAid,
                  'primary' "split", '' fromVCGAid, '' toVCGAid,
                  DECODE(INSTR(Nvl(crs.CRS_ODU_SST,'-'),'RDLD'),0,'NO','YES') redline, '' fromProtEquipmentAid, '' toProtEquipmentAid,
                  '' fromProtFacilityId, '' toProtFacilityId, '' fromCompositeMap, '' toCompositeMap, xc.row_num row_num
               FROM CM_CRS_ODU crs, CM_FACILITY facfrom, CM_FACILITY facto, CM_FACILITY pffrom, CM_CHANNEL_OCH pfto, CM_CARD cardFrom, CM_CARD cardto, EMS_NE ne, NM_CIRCUIT_CRS_CACHE xc
               WHERE facfrom.FAC_ID=xc.from_id AND facto.FAC_ID=xc.to_id AND ne.NE_ID=crs.NE_ID AND crs.CRS_ODU_FROM_ID=facfrom.FAC_ID AND crs.CRS_ODU_TO_ID=facto.FAC_ID AND pffrom.FAC_ID=facfrom.FAC_PARENT_ID AND pfto.OCH_ID=facto.FAC_PARENT_ID AND cardfrom.CARD_ID=pffrom.FAC_PARENT_ID AND cardto.CARD_ID=pfto.OCH_PARENT_ID AND cardfrom.CARD_AID_TYPE='FGTMM' AND cardto.CARD_AID_TYPE='FGTMM'
             UNION
            -- Following SQL gets all OSM40/20 ODU2/ODU1 facility XCs in which supplied where the source/target facility parent is INTF/INTF
             SELECT crs.NE_ID neId, nvl(crs.CRS_ODU_CCTYPE,'') xcType, '' ccPath,
                  nvl(crs.CRS_ODU_CKTID,'') circuitId, cardfrom.CARD_AID fromEquipmentAid, cardto.CARD_AID toEquipmentAid,
                  facfrom.FAC_ID fromFacility, facto.FAC_ID toFacility, ne.NE_TID neName,
                  facfrom.FAC_AID fromFacilityAid, '' fromMultiFacilityAid, facto.FAC_AID toFacilityAid,
                  '' toMultiFacilityAid, CASE WHEN crs.CRS_ODU_FROM_ID=facfrom.FAC_ID THEN to_char(crs.crs_odu_src_prot) WHEN crs.crs_odu_src_prot_id=facfrom.FAC_ID THEN to_char(crsfrom.FAC_AID) ELSE to_char('') END fromProtFacilityAid, CASE WHEN crs.CRS_ODU_TO_ID=facto.FAC_ID THEN to_char(crs.crs_odu_dest_prot) WHEN crs.crs_odu_dest_prot_id=facto.FAC_ID THEN to_char(crsto.FAC_AID) ELSE to_char('') END toProtFacilityAid,
                  circuit_util.getCrsPRType(facfrom.FAC_ID,facto.FAC_ID) "split", '' fromVCGAid, '' toVCGAid,
                  DECODE(INSTR(Nvl(crs.CRS_ODU_SST,'-'),'RDLD'),0,'NO','YES') redline, '' fromProtEquipmentAid, '' toProtEquipmentAid,
                  CASE WHEN crs.CRS_ODU_FROM_ID=facfrom.FAC_ID THEN to_char(crs.crs_odu_src_prot_id) WHEN crs.crs_odu_src_prot_id=facfrom.FAC_ID THEN to_char(crs.CRS_ODU_FROM_ID) ELSE to_char('') END fromProtFacilityId, CASE WHEN crs.CRS_ODU_TO_ID=facto.FAC_ID THEN to_char(crs.crs_odu_dest_prot_id) WHEN crs.crs_odu_dest_prot_id=facto.FAC_ID THEN to_char(crs.CRS_ODU_TO_ID) ELSE to_char('') END toProtFacilityId, '' fromCompositeMap, '' toCompositeMap, xc.row_num row_num
               FROM CM_CRS_ODU crs, CM_FACILITY facfrom, CM_FACILITY facto, CM_CARD cardFrom, CM_CARD cardto, EMS_NE ne, CM_FACILITY crsfrom, CM_FACILITY crsto, NM_CIRCUIT_CRS_CACHE xc
               WHERE facfrom.FAC_ID=xc.from_id AND facto.FAC_ID=xc.to_id AND ne.NE_ID=crs.NE_ID AND (crs.CRS_ODU_FROM_ID=facfrom.FAC_ID or crs.crs_odu_src_prot_id=facfrom.FAC_ID) AND (crs.CRS_ODU_TO_ID=facto.FAC_ID or crs.crs_odu_dest_prot_id=facto.FAC_ID)
               AND cardfrom.NE_ID=facfrom.NE_ID AND cardfrom.CARD_AID_SHELF=facfrom.FAC_AID_SHELF AND cardfrom.CARD_AID_SLOT=facfrom.FAC_AID_SLOT AND cardfrom.CARD_AID_TYPE IN ('OSM20','OSM2S','OSM1S','OSM2C','OMMX','HGTMM','HGTMMS')
               AND cardto.NE_ID=facto.NE_ID AND cardto.CARD_AID_SHELF=facto.FAC_AID_SHELF AND cardto.CARD_AID_SLOT=facto.FAC_AID_SLOT AND cardto.CARD_AID_TYPE IN ('OSM20','OSM2S','OSM1S','OSM2C','OMMX','HGTMM','HGTMMS')
               AND crsfrom.FAC_ID = crs.CRS_ODU_FROM_ID AND crsto.FAC_ID = crs.CRS_ODU_TO_ID
          ) ORDER BY row_num ASC
        ) LOOP
            o_neIdList.EXTEND; o_neIdList(i) := l_conn.neId;
            o_xcTypeList.EXTEND; o_xcTypeList(i) := l_conn.xcType;
            o_ccPathList.EXTEND; o_ccPathList(i) := l_conn.ccPath;
            o_circuitIdList.EXTEND; o_circuitIdList(i) := l_conn.circuitId;
            o_fromEquipmentAidList.EXTEND; o_fromEquipmentAidList(i) := l_conn.fromEquipmentAid;
            o_toEquipmentAidList.EXTEND; o_toEquipmentAidList(i) := l_conn.toEquipmentAid;
            o_fromFacilityList.EXTEND; o_fromFacilityList(i) := l_conn.fromFacility;
            o_toFacilityList.EXTEND; o_toFacilityList(i) := l_conn.toFacility;
            o_neNameList.EXTEND; o_neNameList(i) := l_conn.neName;
            o_fromFacilityAidList.EXTEND; o_fromFacilityAidList(i) := l_conn.fromFacilityAid;
            o_fromMultiFacilityAidList.EXTEND; o_fromMultiFacilityAidList(i) := l_conn.fromMultiFacilityAid;
            o_toFacilityAidList.EXTEND; o_toFacilityAidList(i) := l_conn.toFacilityAid;
            o_toMultiFacilityAidList.EXTEND; o_toMultiFacilityAidList(i) := l_conn.toMultiFacilityAid;
            o_fromProtFacilityAidList.EXTEND; o_fromProtFacilityAidList(i) := l_conn.fromProtFacilityAid;
            o_toProtFacilityAidList.EXTEND; o_toProtFacilityAidList(i) := l_conn.toProtFacilityAid;
            o_splitList.EXTEND; o_splitList(i) := l_conn."split";
            o_fromVCGAidList.EXTEND; o_fromVCGAidList(i) := l_conn.fromVCGAid;
            o_toVCGAidList.EXTEND; o_toVCGAidList(i) := l_conn.toVCGAid;
            o_redlineList.EXTEND; o_redlineList(i) := l_conn.redline;
            o_fromProtEquipmentAidList.EXTEND; o_fromProtEquipmentAidList(i) := l_conn.fromProtEquipmentAid;
            o_toProtEquipmentAidList.EXTEND; o_toProtEquipmentAidList(i) := l_conn.toProtEquipmentAid;
            o_fromProtFacilityIdList.EXTEND; o_fromProtFacilityIdList(i) := l_conn.fromProtFacilityId;
            o_toProtFacilityIdList.EXTEND; o_toProtFacilityIdList(i) := l_conn.toProtFacilityId;
            o_fromCompositeMapList.EXTEND; o_fromCompositeMapList(i) := l_conn.fromCompositeMap;
            o_toCompositeMapList.EXTEND; o_toCompositeMapList(i) := l_conn.toCompositeMap;

            -- fill actual map (from DB) where exists and not the one calculated by the route
            IF  (o_fromEquipmentAidList(i) LIKE 'SMTMU%' OR o_fromEquipmentAidList(i) LIKE 'SSM%')  AND (o_toEquipmentAidList(i) LIKE 'SMTMU%' OR o_toEquipmentAidList(i) LIKE 'SSM%')
            THEN
                FOR l_xc IN (
                    SELECT from_composite_map, to_composite_map FROM NM_CIRCUIT_CRS_CACHE WHERE from_id=o_fromFacilityList(i) AND to_id=o_toFacilityList(i)
                ) LOOP
                    o_fromCompositeMapList(i) := l_xc.from_composite_map;
                    o_toCompositeMapList(i) := l_xc.to_composite_map;
                END LOOP;
            END IF;
            i := i + 1;
        END LOOP;
        COMMIT;
    circuit_util.print_end('getSTSConnectionInfo');
    END getSTSConnectionInfo;
END circuit_retrieval;
/
create or replace
PACKAGE circuit_discovery AS
    PROCEDURE clearCache;
    PROCEDURE discoverSTS(
        id IN VARCHAR2,                       links OUT NOCOPY V_B_TEXT,            connections OUT NOCOPY V_B_TEXT,
        expresses OUT NOCOPY V_B_STRING,      facilities OUT NOCOPY V_B_STRING,     equipments OUT NOCOPY V_B_STRING,
        ffps OUT NOCOPY V_B_STRING,           min_x_left OUT NOCOPY NUMBER,         max_x_right OUT NOCOPY NUMBER,
        min_y_top OUT NOCOPY NUMBER,          max_y_bottom OUT NOCOPY NUMBER,       wavelength OUT NOCOPY VARCHAR2,
        signalRate OUT NOCOPY VARCHAR2,       stsFacilities OUT NOCOPY V_B_STRING,  stsConnections OUT NOCOPY V_B_EXTEXT,
        compLinks OUT NOCOPY V_B_TEXT,        error OUT NOCOPY VARCHAR2,             childSts IN VARCHAR2,
        reportId NUMBER DEFAULT -1
    );
    PROCEDURE discoverVCG(
        id IN VARCHAR2,                       links OUT NOCOPY V_B_TEXT,            connections OUT NOCOPY V_B_TEXT,
        expresses OUT NOCOPY V_B_STRING,      facilities OUT NOCOPY V_B_STRING,     equipments OUT NOCOPY V_B_STRING,
        ffps OUT NOCOPY V_B_STRING,           min_x_left OUT NOCOPY NUMBER,         max_x_right OUT NOCOPY NUMBER,
        min_y_top OUT NOCOPY NUMBER,          max_y_bottom OUT NOCOPY NUMBER,       wavelength OUT NOCOPY VARCHAR2,
        signalRate OUT NOCOPY VARCHAR2,       stsFacilities OUT NOCOPY V_B_STRING,  stsConnections OUT NOCOPY V_B_EXTEXT,
        compLinks OUT NOCOPY V_B_TEXT,        error OUT NOCOPY VARCHAR2,             reportId NUMBER DEFAULT -1
    );
    PROCEDURE discoverRPR(
        id IN VARCHAR2,                       links OUT NOCOPY V_B_TEXT,            connections OUT NOCOPY V_B_TEXT,
        expresses OUT NOCOPY V_B_STRING,      facilities OUT NOCOPY V_B_STRING,     equipments OUT NOCOPY V_B_STRING,
        ffps OUT NOCOPY V_B_STRING,           min_x_left OUT NOCOPY NUMBER,         max_x_right OUT NOCOPY NUMBER,
        min_y_top OUT NOCOPY NUMBER,          max_y_bottom OUT NOCOPY NUMBER,       wavelength OUT NOCOPY VARCHAR2,
        signalRate OUT NOCOPY VARCHAR2,       neId IN VARCHAR2
    );
    PROCEDURE discoverEquipment(
        id IN VARCHAR2,                       links OUT NOCOPY V_B_TEXT,            connections OUT NOCOPY V_B_TEXT,
        expresses OUT NOCOPY V_B_STRING,      facilities OUT NOCOPY V_B_STRING,     equipments OUT NOCOPY V_B_STRING,
        ffps OUT NOCOPY V_B_STRING,           min_x_left OUT NOCOPY NUMBER,         max_x_right OUT NOCOPY NUMBER,
        min_y_top OUT NOCOPY NUMBER,          max_y_bottom OUT NOCOPY NUMBER,       wavelength OUT NOCOPY VARCHAR2,
        signalRate OUT NOCOPY VARCHAR2,       circuitType IN VARCHAR2,               supportingEntityAid IN VARCHAR2,
        stsConnections OUT NOCOPY V_B_EXTEXT, error OUT NOCOPY VARCHAR2,         sts1map IN VARCHAR2,
        circuitDir IN VARCHAR2,               childSts IN VARCHAR2,                  inSignalRate IN VARCHAR2,
        reportId NUMBER DEFAULT -1
    );
    PROCEDURE discoverEquipmentX(
        id IN VARCHAR2,                       links OUT NOCOPY V_B_TEXT,            connections OUT NOCOPY V_B_TEXT,
        stsConnections OUT NOCOPY V_B_EXTEXT, expresses OUT NOCOPY V_B_STRING,      facilities OUT NOCOPY V_B_STRING,
        equipments OUT NOCOPY V_B_STRING,     ffps OUT NOCOPY V_B_STRING,           min_x_left OUT NOCOPY NUMBER,
        max_x_right OUT NOCOPY NUMBER,        min_y_top OUT NOCOPY NUMBER,          max_y_bottom OUT NOCOPY NUMBER,
        wavelength OUT NOCOPY VARCHAR2,       signalRate OUT NOCOPY VARCHAR2,        circuitType IN VARCHAR2
    );
    PROCEDURE discoverLineOCH(
        id IN VARCHAR2,                       links OUT NOCOPY V_B_TEXT,            connections OUT NOCOPY V_B_TEXT,
        expresses OUT NOCOPY V_B_STRING,      facilities OUT NOCOPY V_B_STRING,     equipments OUT NOCOPY V_B_STRING,
        ffps OUT NOCOPY V_B_STRING,           min_x_left OUT NOCOPY NUMBER,         max_x_right OUT NOCOPY NUMBER,
        min_y_top OUT NOCOPY NUMBER,          max_y_bottom OUT NOCOPY NUMBER,       wavelength OUT NOCOPY VARCHAR2,
        signalRate OUT NOCOPY VARCHAR2,       circuitType IN VARCHAR2,               stsConnections OUT NOCOPY V_B_EXTEXT,
        error OUT NOCOPY VARCHAR2,            reportId NUMBER DEFAULT -1
    );
    PROCEDURE discoverLineOCHX(
        id IN VARCHAR2,                       links OUT NOCOPY V_B_TEXT,            connections OUT NOCOPY V_B_TEXT,
        stsConnections OUT NOCOPY V_B_EXTEXT, expresses OUT NOCOPY V_B_STRING,      facilities OUT NOCOPY V_B_STRING,
        equipments OUT NOCOPY V_B_STRING,     ffps OUT NOCOPY V_B_STRING,           min_x_left OUT NOCOPY NUMBER,
        max_x_right OUT NOCOPY NUMBER,        min_y_top OUT NOCOPY NUMBER,          max_y_bottom OUT NOCOPY NUMBER,
        wavelength OUT NOCOPY VARCHAR2,       signalRate OUT NOCOPY VARCHAR2,        circuitType IN VARCHAR2
    );
    PROCEDURE discoverLineOCHXWrap(
        id IN VARCHAR2,                       links OUT NOCOPY V_B_TEXT,            connections OUT NOCOPY V_B_TEXT,
        stsConnections OUT NOCOPY V_B_EXTEXT, expresses OUT NOCOPY V_B_STRING,      facilities OUT NOCOPY V_B_STRING,
        equipments OUT NOCOPY V_B_STRING,     ffps OUT NOCOPY V_B_STRING,           min_x_left OUT NOCOPY NUMBER,
        max_x_right OUT NOCOPY NUMBER,        min_y_top OUT NOCOPY NUMBER,          max_y_bottom OUT NOCOPY NUMBER,
        wavelength OUT NOCOPY VARCHAR2,       signalRate OUT NOCOPY VARCHAR2,       circuitType IN VARCHAR2
    );
    PROCEDURE discoverProtectionSwitch(
        id IN VARCHAR2,                       links OUT NOCOPY V_B_TEXT,            connections OUT NOCOPY V_B_TEXT,
        expresses OUT NOCOPY V_B_STRING,      facilities OUT NOCOPY V_B_STRING,     equipments OUT NOCOPY V_B_STRING,
        ffps OUT NOCOPY V_B_STRING,           min_x_left OUT NOCOPY NUMBER,         max_x_right OUT NOCOPY NUMBER,
        min_y_top OUT NOCOPY NUMBER,          max_y_bottom OUT NOCOPY NUMBER,       wavelength OUT NOCOPY VARCHAR2,
        signalRate OUT NOCOPY VARCHAR2
    );

    FUNCTION findXCFromOCHX(ochId IN NUMBER, thisOchPosInNextXC IN VARCHAR2, dontFindMeId IN NUMBER, circuitType IN VARCHAR2, processRptDrop BOOLEAN DEFAULT FALSE) RETURN VARCHAR2;
    PROCEDURE findXCFromOCH(ochId IN NUMBER, thisOchPosInNextXC IN VARCHAR2, dontFindMeId IN NUMBER, circuitType IN VARCHAR2);
END circuit_discovery;
/
create or replace
PACKAGE BODY circuit_discovery AS
    TYPE EMS_REF_CURSOR IS REF CURSOR;
    TYPE ID_ARRAY IS TABLE OF CHAR(1) INDEX BY VARCHAR2(70);
    TYPE IDX_ARRAY IS TABLE OF CHAR(1) INDEX BY VARCHAR2(2000);
    TYPE IntTable IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
    TYPE FacIdTable IS TABLE OF NUMBER INDEX BY VARCHAR2(40);
    TYPE StringTable70 IS TABLE OF VARCHAR2(70) INDEX BY BINARY_INTEGER;
    TYPE StringTable800 IS TABLE OF VARCHAR2(800) INDEX BY BINARY_INTEGER;
    TYPE StringTable80 IS TABLE OF VARCHAR2(80)   INDEX BY VARCHAR2(40);
    TYPE ODU_RECORD IS RECORD(
      ne_id NUMBER,
      odu_id NUMBER,
      odu_aid VARCHAR2(70)
    );
    TYPE ODU_TABLE IS TABLE OF ODU_RECORD INDEX BY PLS_INTEGER;
    TYPE FIBERLINK_RECORD IS RECORD(
      ne_id NUMBER,
      och_id NUMBER,
      och_aid VARCHAR2(40),
      fac_id NUMBER,
      fac_aid VARCHAR2(40),
      card_id NUMBER,
      other_ne_id NUMBER,
      other_och_id NUMBER,
      other_och_aid VARCHAR2(40),
      other_fac_id NUMBER,
      other_fac_aid VARCHAR2(40),
      other_card_id NUMBER,
      other_och_type VARCHAR2(20)
    );

    TYPE tribslot_array_t is varray(5) of cm_facility.fac_tribslot%type;

    FUNCTION findFiberLinkFromOCH(
        ochId IN NUMBER, thisOchPosInNextXC IN VARCHAR2, dontFindMeId IN NUMBER,
        circuitType IN VARCHAR2, fiberLink OUT FIBERLINK_RECORD, processRptDrop BOOLEAN DEFAULT FALSE
    ) RETURN VARCHAR2;

    C_discoverLineOCH NUMBER :=1;
    C_findXCFromOCH  NUMBER :=2;

    g_id_array           ID_ARRAY;
    g_id_array_sts        ID_ARRAY;
    g_id_array_odu        ID_ARRAY;
    g_empty_id_array     ID_ARRAY;
    g_flink_end_array    FacIdTable;
    g_empty_FacIdTable    FacIdTable;
    g_link_list    V_B_TEXT;
    g_conn_List    V_B_TEXT;
    g_sts_conn_list V_B_EXTEXT;
    g_exp_link_list    V_B_STRING;
    g_fac_List     V_B_STRING;
    g_sts_Fac_List  V_B_STRING;
    g_eqpt_List    V_B_STRING;
    g_ffp_List     V_B_STRING;
    g_link_array      IDX_ARRAY;
    g_conn_array      IDX_ARRAY;
    g_sts_conn_array   IDX_ARRAY;
    g_exp_link_array      IDX_ARRAY;
    g_fac_array       IDX_ARRAY;
    g_eqpt_array      IDX_ARRAY;
    g_ffp_array       IDX_ARRAY;
    g_empty_idx_array IDX_ARRAY;
    g_min_x       NUMBER(18,15);
    g_max_x       NUMBER(18,15);
    g_min_y       NUMBER(18,15);
    g_max_y       NUMBER(18,15);
    g_delimiter   CHAR(1) := ',';
    g_ne_id          NUMBER:=0;
    g_ne_idx          NUMBER:=0;
    g_card_id        NUMBER:=0;
    g_sts_id         NUMBER:=0;
    g_sts_aid        VARCHAR2(70):='';
    g_other_ne_id     NUMBER:=0;
    g_other_card_id   NUMBER:=0;
    g_other_sts_id    NUMBER:=0;
    g_other_sts1map  VARCHAR2(800);
    g_other_sts_aid   VARCHAR2(70):='';
    g_card_aid       VARCHAR2(70);
    g_other_card_aid  VARCHAR2(70);
    g_next_och_pos_in_next_xc  VARCHAR2(20);
    g_sts_type       VARCHAR2(70);
    g_error         VARCHAR2(1000);
    g_sts1map       VARCHAR2(800);
    g_child_sts      BOOLEAN;
    g_sts_discovery  VARCHAR2(5);
    g_discover_vcg   BOOLEAN DEFAULT FALSE;
    g_circuit_type   VARCHAR2(10);
    g_sts_passthrough_circuit BOOLEAN := FALSE;
    g_odu_tribslots tribslot_array_t := tribslot_array_t(null,null,null,null,null);
    g_odu_table      ODU_TABLE;
    g_empty_rpt_start_cache StringTable80;
    g_rpt_ffp_array       IDX_ARRAY;
    g_rpt_id          NUMBER := -1;
    g_rpt_init_id     NUMBER;
    g_cache_och_circuit BOOLEAN := FALSE;
    g_rpt_start_cache StringTable80;
    g_rpt_start_id    NUMBER := -1;
    g_rpt_end_id      NUMBER := -1;
    g_rpt_link_list    V_B_TEXT;
    g_rpt_conn_List    V_B_TEXT;
    g_rpt_sts_conn_list    V_B_EXTEXT;
    g_rpt_exp_list    V_B_STRING;
    g_rpt_fac_List     V_B_STRING;
    g_rpt_eqpt_List    V_B_STRING;
    g_rpt_ffp_List     V_B_STRING;
    g_rpt_direction    VARCHAR2(5);
    g_rpt_dontFindMeId NUMBER;
    g_rpt_id_list            V_B_STRING;
    g_rpt_sts_id_list        V_B_STRING;
    g_rpt_odu_id_list        V_B_STRING;

    PROCEDURE clearRptCache AS
    BEGIN
        g_cache_och_circuit := FALSE;
        g_rpt_start_id      := -1;
        g_rpt_end_id        := -1;
        g_rpt_link_list  := NULL;
        g_rpt_conn_List  := NULL;
        g_rpt_sts_conn_list := NULL;
        g_rpt_exp_list  := NULL;
        g_rpt_fac_List   := NULL;
        g_rpt_eqpt_List  := NULL;
        g_rpt_ffp_List   := NULL;
        g_rpt_id_list    := NULL;
        g_rpt_sts_id_list:= NULL;
        g_rpt_odu_id_list:= NULL;
        g_rpt_ffp_array := g_empty_idx_array;
    END clearRptCache;

    PROCEDURE clearCache AS
    BEGIN
        g_id_array:=g_empty_id_array;
        g_id_array_sts:=g_empty_id_array;
        g_id_array_odu:=g_empty_id_array;
        g_flink_end_array:=g_empty_FacIdTable;
        g_link_array:=g_empty_idx_array;
        g_conn_array:=g_empty_idx_array;
        g_sts_conn_array:=g_empty_idx_array;
        g_exp_link_array:=g_empty_idx_array;
        g_fac_array:=g_empty_idx_array;
        g_eqpt_array:=g_empty_idx_array;
        g_ffp_array:=g_empty_idx_array;

        g_ne_id:=0;
        g_ne_idx:=0;
        g_card_id:=0;
        g_sts_aid:='';
        g_other_ne_id:=0;
        g_other_card_id:=0;
        g_other_sts_id:=0;
        g_other_sts1map:='';
        g_other_sts_aid:='';
        g_card_aid:='';
        g_other_card_aid:='';
        g_next_och_pos_in_next_xc:='';
        g_sts_type:='';
        g_error:='';
        g_sts1map:='';
        g_child_sts:=FALSE;
        g_sts_discovery:='';
        g_discover_vcg:=FALSE;
        g_circuit_type:='';
        g_sts_passthrough_circuit := FALSE;
        g_odu_tribslots := tribslot_array_t(null,null,null,null,null);
        g_rpt_id            := -1;
        clearRptCache();
        g_rpt_start_cache := g_empty_rpt_start_cache;
    END clearCache;
    PROCEDURE initRptGlobalVariable(p_start_id NUMBER)
    AS
    BEGIN
        g_cache_och_circuit := TRUE;
        g_rpt_start_id      := p_start_id;
        g_rpt_end_id        := -1;
        g_rpt_link_list     := V_B_TEXT();
        g_rpt_conn_List     := V_B_TEXT();
        g_rpt_sts_conn_list := V_B_EXTEXT();
        g_rpt_exp_list     := V_B_STRING();
        g_rpt_fac_List      := V_B_STRING();
        g_rpt_eqpt_List     := V_B_STRING();
        g_rpt_ffp_List      := V_B_STRING();
        g_rpt_id_list       := V_B_STRING();
        g_rpt_sts_id_list   := V_B_STRING();
        g_rpt_odu_id_list   := V_B_STRING();
    END initRptGlobalVariable;
    PROCEDURE initGlobalVariable
    AS
    BEGIN
        g_link_list       := V_B_TEXT();
        g_conn_List       := V_B_TEXT();
        g_sts_conn_list   := V_B_EXTEXT();
        g_exp_link_list   := V_B_STRING();
        g_fac_List        := V_B_STRING();
        g_sts_Fac_List    := V_B_STRING();
        g_eqpt_List       := V_B_STRING();
        g_ffp_List        := V_B_STRING();

        g_min_x := 999;
        g_max_x := -999;
        g_min_y := 999;
        g_max_y := -999;
    END initGlobalVariable;

    PROCEDURE addLinkToListX(
       p_link_info VARCHAR2, p_add_to_rpt_cache BOOLEAN DEFAULT TRUE
    ) AS
    BEGIN
        IF circuit_util.g_log_enable THEN
            circuit_util.print_line('>>addLinkToListX: '||p_link_info);
        END IF;
        g_link_list.extend;
        g_link_list(g_link_list.count):=p_link_info;
        IF g_cache_och_circuit AND p_add_to_rpt_cache THEN
            g_rpt_link_list.EXTEND;
            g_rpt_link_list(g_rpt_link_list.count):=p_link_info;
        END IF;
    END addLinkToListX;
    PROCEDURE addExpLinkToListX(
        p_expsInfo VARCHAR2
    )AS
    BEGIN
        IF circuit_util.g_log_enable THEN
            circuit_util.print_line('>>addExpLinkToListX: '||p_expsInfo);
        END IF;
        g_exp_link_list.extend;
        g_exp_link_list(g_exp_link_list.count):=p_expsInfo;
        IF g_cache_och_circuit THEN
          g_rpt_exp_list.extend;
          g_rpt_exp_list(g_rpt_exp_list.COUNT):=p_expsInfo;
        END IF;
    END addExpLinkToListX;
    PROCEDURE addConnToListX(
        p_conn_info VARCHAR2
    ) AS
    BEGIN
        IF circuit_util.g_log_enable THEN
            circuit_util.print_line('>>addConnToListX: '||p_conn_info);
        END IF;
        g_conn_List.extend;
        g_conn_List(g_conn_List.count):=p_conn_info;
        IF g_cache_och_circuit THEN
          g_rpt_conn_List.extend;
          g_rpt_conn_List(g_rpt_conn_List.COUNT):=p_conn_info;
        END IF;
    END addConnToListX;
    PROCEDURE addStsConnToListX(
        p_conn_info VARCHAR2
    ) AS
    BEGIN
        IF circuit_util.g_log_enable THEN
            circuit_util.print_line('>>addStsConnToListX: '||p_conn_info);
        END IF;
        g_sts_Conn_List.extend;
        g_sts_Conn_List(g_sts_Conn_List.count):=p_conn_info;
    END addStsConnToListX;
    PROCEDURE addFFPToListX(p_ffpInfo VARCHAR2)
    AS
    BEGIN
        IF circuit_util.g_log_enable THEN
            circuit_util.print_line('>>addFFPToListX: '||p_ffpInfo);
        END IF;
        g_ffp_List.extend;
        g_ffp_List(g_ffp_List.count):=p_ffpInfo;
    END addFFPToListX;
    PROCEDURE addFacToListX(p_entityId VARCHAR2)
    AS
    BEGIN
        IF circuit_util.g_log_enable THEN
            circuit_util.print_line('>>addFacToListX: '||p_entityId);
        END IF;
        IF NOT g_fac_array.EXISTS(p_entityId) THEN
            g_fac_array(p_entityId) := 'X';
            g_fac_List.extend;
            g_fac_List(g_fac_List.count):=p_entityId;
            IF g_cache_och_circuit THEN
                g_rpt_fac_List.EXTEND;
                g_rpt_fac_List(g_rpt_fac_List.COUNT):=p_entityId;
            END IF;
        END IF;
    END addFacToListX;
    PROCEDURE addEqptToListX(p_entityId VARCHAR2)
    AS
    BEGIN
        IF circuit_util.g_log_enable THEN
            circuit_util.print_line('>>addEqptToListX: '||p_entityId);
        END IF;
        g_eqpt_List.extend;
        g_eqpt_List(g_eqpt_List.count):=p_entityId;
        IF g_cache_och_circuit THEN
            g_rpt_eqpt_List.extend;
            g_rpt_eqpt_List(g_rpt_eqpt_List.COUNT):=p_entityId;
        END IF;
    END addEqptToListX;

    PROCEDURE addFacilityToListX(neId IN NUMBER, entityId IN NUMBER) AS
        v_ref_cursor          EMS_REF_CURSOR;
        ochId                NUMBER;
        facAid               VARCHAR2(70);
    BEGIN circuit_util.print_start('addFacilityToListX');
        OPEN v_ref_cursor FOR SELECT VCG_AID FROM CM_VCG WHERE VCG_ID=entityId;
        FETCH v_ref_cursor INTO facAid;
        IF v_ref_cursor%FOUND AND g_discover_vcg<>TRUE THEN
            CLOSE v_ref_cursor;
            RETURN;
        ELSE
            CLOSE v_ref_cursor;
        END IF;

        addFacToListX(entityId);

        -- add SFP/XFP/SFPP if any to facilities
        ochId := circuit_util.getFacSFP(neId, entityId);
        IF ochId <> 0 THEN
            addFacToListX(ochId);
        END IF;

        -- add multiplexer OCH, if any to facilities
        ochId := circuit_util.getMultiplexerOCH(neId, entityId, 'OCH-1');
        IF ochId <> 0 THEN
            addFacToListX(ochId);
        END IF;

        -- add BMM OCH, if any to facilities for s.x HW only. Also note BMM can exist on slots 7, 12 only per CRM 4.0.5
        ochId := circuit_util.getMultiplexerOCH(neId, entityId, 'OCH-BP');
        IF ochId <> 0 THEN
            addFacToListX(ochId);
        END IF;

        -- add OCH-DP's parent, DP that is shown in the nav tree
        ochId := circuit_util.getExpressDP(neId, entityId);
        IF ochId <> 0 THEN
            addFacToListX(ochId);
        END IF;

        -- add STSnCNV or VCnCNV child STS
        IF entityId<>0 AND g_child_sts THEN
            FOR l_sts IN (
                SELECT sts_id FROM cm_sts WHERE sts_i_parent_type='STS' AND sts_parent_id=entityId
            )LOOP
                addFacToListX(l_sts.sts_id);
            END LOOP;
        END IF;
    circuit_util.print_end('addFacilityToListX');
    END addFacilityToListX;

    PROCEDURE addFacilityToList(neId IN NUMBER, entityId IN NUMBER) AS
    BEGIN circuit_util.print_start('addFacilityToList');
        IF entityId IS NULL THEN
            RETURN;
        END IF;
        circuit_util.print_line('addFacilityToList: '||entityId);
        IF NOT g_fac_array.EXISTS(entityId) THEN
           addFacilityToListX(neId, entityId);
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           g_fac_array(entityId) := 'X';
           circuit_util.print_line(entityId || ' WITH EXCEPTION: HAS BEEN ADDED TO g_fac_array');
       circuit_util.print_end('addFacilityToList');
    END addFacilityToList;

    PROCEDURE addDWDMLinkToList(
        linkId IN NUMBER,     linkName IN VARCHAR2,
        aNeId IN NUMBER,      zNeId IN NUMBER,      aNeTid IN VARCHAR2, zNeTid IN VARCHAR2,
        aNeType IN VARCHAR2,  zNeType IN VARCHAR2,  aNeSType VARCHAR2,  zNeSType IN VARCHAR2,
        aPort IN VARCHAR2,    zPort IN VARCHAR2,    ochIdA IN NUMBER,   ochIdZ IN NUMBER,
        aOtsChanTypes IN VARCHAR2,   zOtsChanTypes IN VARCHAR2
    ) AS
        linkInfo VARCHAR2(350);
        v_aOtsChanTypes VARCHAR2(20);
        v_zOtsChanTypes VARCHAR2(20);
    BEGIN
        circuit_util.print_start('addDWDMLinkToList');
        if aOtsChanTypes is null then
           v_aOtsChanTypes := 'MIXED';
        else
           v_aOtsChanTypes := aOtsChanTypes;
        end if;
        if zOtsChanTypes is null then
           v_zOtsChanTypes := 'MIXED';
        else
           v_zOtsChanTypes := zOtsChanTypes;
        end if;
        linkInfo:=to_char(linkId)||g_delimiter||to_char(aNeId)||g_delimiter||to_char(zNeId)||
            g_delimiter||nvl(aPort, ' ')||g_delimiter||nvl(zPort, ' ')||g_delimiter||nvl(linkName, ' ')||g_delimiter||nvl(to_char(ochIdA),' ')||g_delimiter||nvl(to_char(ochIdZ),' ')||
            g_delimiter||aNeTid||g_delimiter||zNeTid||g_delimiter||aNeType||g_delimiter||zNeType||g_delimiter||aNeSType||g_delimiter||zNeSType||g_delimiter||v_aOtsChanTypes||g_delimiter||v_zOtsChanTypes;
        linkInfo := linkInfo||g_delimiter||'DWDMLINK';
        IF NOT g_link_array.EXISTS(linkInfo) THEN
            g_link_array(linkInfo) := 'X';
            addLinkToListX(linkInfo);
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            g_link_array(linkInfo) := 'X';
            circuit_util.print_line(linkInfo || ' WITH EXCEPTION: HAS BEEN ADDED TO g_link_array');
           circuit_util.print_end('addDWDMLinkToList');
    END addDWDMLinkToList;

    PROCEDURE addFiberLinkToList(
        aNeId IN NUMBER, zNeId IN NUMBER, aEndSide IN VARCHAR2, zEndSide IN VARCHAR2,
        aEndAid IN VARCHAR2, zEndAid IN VARCHAR2, aXcEndAid IN VARCHAR2, zXcEndAid IN VARCHAR2,
        aEndId IN NUMBER, zEndId IN NUMBER, aXcEndId IN NUMBER, zXcEndId IN NUMBER
    ) AS
        linkInfo VARCHAR2(350);
    BEGIN
        circuit_util.print_start('addFiberLinkToList');
        if aEndId < zEndId then -- prevent dulplicated Link of A->Z and Z->A
           linkInfo:=to_char(aNeId)||g_delimiter||aEndSide||g_delimiter||aEndAid||g_delimiter||aXcEndAid||g_delimiter||
                  to_char(zNeId)||g_delimiter||zEndSide||g_delimiter||zEndAid||g_delimiter||zXcEndAid;
        else
           linkInfo:=to_char(zNeId)||g_delimiter||zEndSide||g_delimiter||zEndAid||g_delimiter||zXcEndAid||g_delimiter||
                  to_char(aNeId)||g_delimiter||aEndSide||g_delimiter||aEndAid||g_delimiter||aXcEndAid;
        end if;

        linkInfo := linkInfo||g_delimiter||'FIBERLINK';
        IF NOT g_link_array.EXISTS(linkInfo) THEN
            g_link_array(linkInfo) := 'X';
            addLinkToListX(linkInfo);
            -- add fiber link end to construct composite conn
            g_flink_end_array(aXcEndId) := aEndId;
            g_flink_end_array(zXcEndId) := zEndId;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            g_link_array(linkInfo) := 'X';
            circuit_util.print_line(linkInfo || ' WITH EXCEPTION: HAS BEEN ADDED TO g_link_array');
           circuit_util.print_end('addFiberLinkToList');
    END addFiberLinkToList;

    PROCEDURE addCompositeLinkToList(
      fromNeId IN NUMBER, toNeId IN NUMBER, fromOchDP IN VARCHAR2,
      toOchDP IN VARCHAR2, fromSide IN VARCHAR2, toSide IN VARCHAR2,
      xcchanNum IN NUMBER
    ) AS
      linkInfo VARCHAR2(1000);
    BEGIN
        linkInfo := circuit_util.constructLinkInfo(fromNeId, toNeId, fromOchDP, toOchDP, fromSide, toSide, xcchanNum, g_delimiter);
        IF NOT g_link_array.EXISTS(linkInfo) THEN
            g_link_array(linkInfo) := 'X';
            addLinkToListX(linkInfo, FALSE);
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            g_link_array(linkInfo) := 'X';
            circuit_util.print_line(linkInfo || ' WITH EXCEPTION: HAS BEEN ADDED TO g_link_array');
           circuit_util.print_end('addCompositeLinkToList');
    END addCompositeLinkToList;

    PROCEDURE addCompConnectionToList(
        neId IN NUMBER, crsFromFacilityKey IN NUMBER, crsToFacilityKey IN NUMBER,
        asscociateKeys IN VARCHAR2
    ) AS
        xcInfo   VARCHAR2(350);
    BEGIN circuit_util.print_start('addCompConnectionToList');
        xcInfo:=to_char(neId)||g_delimiter||nvl(to_char(crsFromFacilityKey), ' ')||g_delimiter||nvl(to_char(crsToFacilityKey), ' ')||g_delimiter||nvl(to_char(asscociateKeys), ' ');
        IF NOT g_conn_array.EXISTS(xcInfo) THEN
        g_conn_array(xcInfo) := 'X';
            addConnToListX(xcInfo);
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            g_conn_array(xcInfo) := 'X';
            circuit_util.print_line(xcInfo || ' WITH EXCEPTION: HAS BEEN ADDED TO g_conn_array');
           circuit_util.print_end('addCompConnectionToList');
    END addCompConnectionToList;
    PROCEDURE addODUCompositeLinkToList(
        fromNeId IN NUMBER, toNeId IN NUMBER, fromOchDP IN VARCHAR2,
        toOchDP IN VARCHAR2, fromSide IN VARCHAR2, toSide IN VARCHAR2,
        xcchanNum IN NUMBER
    ) AS
        linkInfo VARCHAR2(1000);
    BEGIN circuit_util.print_start('addODUCompositeLinkToList');
        linkInfo := circuit_util.constructLinkInfo(fromNeId, toNeId, fromOchDP, toOchDP, fromSide, toSide, xcchanNum, g_delimiter);
        IF NOT g_link_array.EXISTS(linkInfo) THEN
            g_link_array(linkInfo) := 'X';
            addLinkToListX(linkInfo, FALSE);
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            g_link_array(linkInfo) := 'X';
            circuit_util.print_line(linkInfo || ' WITH EXCEPTION: HAS BEEN ADDED TO g_link_array');
           circuit_util.print_end('addODUCompositeLinkToList');
    END addODUCompositeLinkToList;

    PROCEDURE addHDTGRegenFacilities(
        neId IN NUMBER, ochpId IN NUMBER, shelf IN NUMBER,
        slot IN NUMBER, ochpPort IN NUMBER
    ) AS
        v_ref_cursor    EMS_REF_CURSOR;
        facId    NUMBER;
        odu2Id   NUMBER;
        clientFacPort NUMBER;
    BEGIN
        addFacilityToList(neId, ochpId);
        clientFacPort := ochpPort+1;

        -- add client facility
        OPEN v_ref_cursor FOR SELECT FAC_ID FROM CM_FACILITY WHERE  NE_ID=neId AND FAC_AID_SHELF=shelf AND FAC_AID_SLOT=slot AND FAC_AID_PORT=clientFacPort AND fac_i_parent_type = 'CARD';
        FETCH v_ref_cursor INTO facId;
        IF v_ref_cursor%FOUND THEN
           addFacilityToList(neId, facId);
        END IF;
        CLOSE v_ref_cursor;

        -- add och-p/odu facility
        OPEN v_ref_cursor FOR SELECT FAC_ID FROM CM_FACILITY WHERE NE_ID=neId AND FAC_AID_SHELF=shelf AND FAC_AID_SLOT=slot AND FAC_PARENT_ID=ochpId AND FAC_AID LIKE 'ODU2%';
        FETCH v_ref_cursor INTO odu2Id;
        IF v_ref_cursor%FOUND THEN
           addFacilityToList(neId, odu2Id);
        END IF;
        CLOSE v_ref_cursor;

        -- add client/odu facility
        OPEN v_ref_cursor FOR SELECT FAC_ID FROM CM_FACILITY WHERE NE_ID=neId AND FAC_AID_SHELF=shelf AND FAC_AID_SLOT=slot AND FAC_PARENT_ID=facId AND FAC_AID LIKE 'ODU2%';
        FETCH v_ref_cursor INTO odu2Id;
        IF v_ref_cursor%FOUND THEN
           addFacilityToList(neId, odu2Id);
        END IF;
        CLOSE v_ref_cursor;
    END;

    PROCEDURE addConnectionToList(
        neId IN NUMBER, crsFromFacilityKey IN NUMBER, crsToFacilityKey IN NUMBER
    ) AS
        v_ref_cursor    EMS_REF_CURSOR;
        xcInfo   VARCHAR2(350);
        ochpId   NUMBER;
        ochpPort NUMBER;
        shelf    NUMBER;
        slot     NUMBER;
        cardId   NUMBER;
        channelNo NUMBER;
        side     VARCHAR2(4);
        cardAid  VARCHAR2(20);
    BEGIN circuit_util.print_start('addConnectionToList');
        addFacToListX(crsFromFacilityKey);
        addFacToListX(crsToFacilityKey);
          -- add port (client) facility and OCH-P/OTU2 ODU2
        OPEN v_ref_cursor FOR SELECT OCH_ID, OCH_AID_SHELF, OCH_AID_SLOT, OCH_AID_PORT, CARD_AID FROM CM_CARD card, CM_CHANNEL_OCH och WHERE card.NE_ID=neId AND och.NE_ID=neId AND CARD_ID=OCH_PARENT_ID AND (OCH_ID=crsFromFacilityKey OR OCH_ID=crsToFacilityKey) AND (CARD_AID LIKE 'HDTG%');
        FETCH v_ref_cursor INTO ochpId, shelf, slot, ochpPort, cardAid;
        CLOSE v_ref_cursor;
        IF ochpId IS NULL THEN
           -- handle case TRM-TRM, for adding OCH-P/Clt.Fac/ODU2 for both FROMCP and TOCP
            OPEN v_ref_cursor FOR SELECT CARD_ID, CARD_AID_SHELF, CARD_AID_SLOT, OCH_CHANNUM, OCH_DWDMSIDE, CRS_FROM_PORT FROM CM_CARD card, CM_CHANNEL_OCH och, CM_CRS WHERE card.NE_ID=neId AND och.NE_ID=neId AND card.NE_ID=neId AND CRS_FROM_ID=crsFromFacilityKey AND OCH_ID=crsFromFacilityKey AND CARD_AID LIKE 'HDTG%' AND CRS_CCPATH='TRM-TRM' AND CARD_ID=CRS_FROM_CP_ID;
            FETCH v_ref_cursor INTO cardId, shelf, slot, channelNo, side, ochpPort;
            IF v_ref_cursor%FOUND THEN
                circuit_util.print_line('HDTG Regen From Facilities: '||cardId||', '||shelf||', '||slot||', '||channelNo||', '||side||', '||ochpPort);
                CLOSE v_ref_cursor;

                OPEN v_ref_cursor FOR SELECT OCH_ID FROM CM_CHANNEL_OCH
                    WHERE NE_ID=neId AND OCH_AID_SHELF=shelf AND OCH_AID_SLOT=slot AND OCH_AID_PORT=ochpPort;
                FETCH v_ref_cursor INTO ochpId;
                addHDTGRegenFacilities(neId, ochpId, shelf, slot, ochpPort);
            END IF;
            CLOSE v_ref_cursor;

            OPEN v_ref_cursor FOR SELECT CARD_ID, CARD_AID_SHELF, CARD_AID_SLOT, OCH_CHANNUM, OCH_DWDMSIDE, CRS_TO_PORT FROM CM_CARD card, CM_CHANNEL_OCH och, CM_CRS WHERE card.NE_ID=neId AND och.NE_ID=neId AND card.NE_ID=neId AND CRS_TO_ID=crsToFacilityKey AND OCH_ID=crsToFacilityKey AND CARD_AID LIKE 'HDTG%' AND CRS_CCPATH='TRM-TRM' AND CARD_ID=CRS_TO_CP_ID;
            FETCH v_ref_cursor INTO cardId, shelf, slot, channelNo, side, ochpPort;
            IF v_ref_cursor%FOUND THEN
                circuit_util.print_line('HDTG Regen To Facilities: '||cardId||', '||shelf||', '||slot||', '||channelNo||', '||side||', '||ochpPort);
                CLOSE v_ref_cursor;
                OPEN v_ref_cursor FOR SELECT OCH_ID FROM CM_CHANNEL_OCH
                    WHERE NE_ID=neId AND OCH_AID_SHELF=shelf AND OCH_AID_SLOT=slot AND OCH_AID_PORT=ochpPort;
                FETCH v_ref_cursor INTO ochpId;
                addHDTGRegenFacilities(neId, ochpId, shelf, slot, ochpPort);
            END IF;
            CLOSE v_ref_cursor;
        ELSE
           IF cardAid LIKE 'HDTG%' THEN
                addHDTGRegenFacilities(neId, ochpId, shelf, slot, ochpPort);
           END IF;
        END IF;

        circuit_util.print_line('Add OCH connetion:'||neId||','||crsFromFacilityKey||','||crsToFacilityKey);
        xcInfo:=to_char(neId)||g_delimiter||nvl(to_char(crsFromFacilityKey), ' ')||g_delimiter||nvl(to_char(crsToFacilityKey), ' ');

        IF NOT g_conn_array.EXISTS(xcInfo) THEN
            g_conn_array(xcInfo) := 'X';
            addConnToListX(xcInfo);
        END IF;
       circuit_util.print_end('addConnectionToList');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           g_conn_array(xcInfo) := 'X';
           circuit_util.print_line(xcInfo || ' WITH EXCEPTION: HAS BEEN ADDED TO g_conn_array');
    END addConnectionToList;

    PROCEDURE addFFPToList(
        neId IN NUMBER, fromFacilityId IN NUMBER, toFacilityId IN NUMBER
    ) AS
        v_ffpInfo VARCHAR2(2000);
    BEGIN circuit_util.print_start('addFFPToList');
        IF fromFacilityId IS NULL OR toFacilityId IS NULL THEN
            RETURN;
        END IF;
        v_ffpInfo:=to_char(neId)||g_delimiter||nvl(to_char(fromFacilityId), ' ')||g_delimiter||nvl(to_char(toFacilityId), ' ');
        IF NOT g_ffp_array.EXISTS(v_ffpInfo) THEN
           g_ffp_array(v_ffpInfo) := 'X';
           addFFPToListX(v_ffpInfo);
           addFacilityToList(neId, fromFacilityId);
           addFacilityToList(neId, toFacilityId);
        END IF;
        IF g_cache_och_circuit AND NOT g_rpt_ffp_array.EXISTS(v_ffpInfo)THEN
            g_rpt_ffp_array(v_ffpInfo) := 'X';
            g_rpt_ffp_List.extend;
            g_rpt_ffp_List(g_rpt_ffp_List.COUNT):=v_ffpInfo;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            g_ffp_array(v_ffpInfo) := 'X';
            circuit_util.print_line(v_ffpInfo || ' WITH EXCEPTION: HAS BEEN ADDED TO g_ffp_array');
           circuit_util.print_end('addFFPToList');
    END addFFPToList;

    PROCEDURE addExpLinkToList(
        fromNeId IN NUMBER, toNeId IN NUMBER, fromOchDP IN VARCHAR2,
        toOchDP IN VARCHAR2, fromSide IN VARCHAR2, toSide IN VARCHAR
    ) AS
        v_expsInfo VARCHAR2(350);
    BEGIN circuit_util.print_start('addExpLinkToList');
        v_expsInfo:=to_char(fromNeId)||g_delimiter||to_char(toNeId)||g_delimiter||fromOchDP||g_delimiter||toOchDP||g_delimiter||nvl(fromSide, ' ')||g_delimiter||nvl(toSide, ' ');
        IF NOT g_exp_link_array.EXISTS(v_expsInfo) THEN
           g_exp_link_array(v_expsInfo) := 'X';
           addExpLinkToListX(v_expsInfo);
        END IF;
       circuit_util.print_end('addExpLinkToList');
    END addExpLinkToList;

    PROCEDURE addSTSConnectionToListX(
          neId IN NUMBER, crsFromFacilityKey IN NUMBER, crsToFacilityKey IN NUMBER,
          fromCompositeMap IN VARCHAR2, toCompositeMap IN VARCHAR2, v_entity_id_nomap VARCHAR2,v_entity_id_withmap VARCHAR2,
          p_overwritten_existed BOOLEAN DEFAULT FALSE
    ) AS
        v_ref_cursor          EMS_REF_CURSOR;
        ochId          NUMBER;
        vcgIdList      IntTable;
        v_duplicate BOOLEAN := FALSE;
    BEGIN circuit_util.print_start('addSTSConnectionToListX');

       FOR i IN 1..g_sts_Conn_List.count
       LOOP
           IF ( g_sts_Conn_List(i) = v_entity_id_nomap AND NOT g_sts_Conn_List(i) = v_entity_id_withmap )
           OR ( p_overwritten_existed AND g_sts_Conn_List(i) = v_entity_id_withmap ) THEN
                  v_duplicate := TRUE;
                  g_sts_Conn_List(i):=v_entity_id_withmap;
                  circuit_util.print_line('>>overwrite STSConnection('||i||')='||v_entity_id_withmap);
           END IF;
       END LOOP;

        IF v_duplicate = FALSE THEN
            addFacilityToList(neId, crsFromFacilityKey);
            addFacilityToList(neId, crsToFacilityKey);
            addStsConnToListX(v_entity_id_withmap);
            circuit_util.print_line('>>add STSConnection('||g_sts_Conn_List.count||')='||v_entity_id_withmap);
        END IF;

        -- to add src_prot/dest_prot to facilities
        OPEN v_ref_cursor FOR SELECT STS_ID FROM CM_CRS_STS crs, CM_STS fac
           WHERE (CRS_STS_FROM_ID=crsFromFacilityKey AND CRS_STS_TO_ID=crsToFacilityKey OR CRS_STS_FROM_ID=crsToFacilityKey AND CRS_STS_TO_ID=crsFromFacilityKey) AND STS_AID=CRS_STS_SRC_PROT AND crs.NE_ID=fac.NE_ID;
        FETCH v_ref_cursor INTO ochId;
        CLOSE v_ref_cursor;
        IF ochId<>0 THEN
           addFacilityToList(neId, ochId);
        END IF;

        OPEN v_ref_cursor FOR SELECT STS_ID FROM CM_CRS_STS crs, CM_STS fac
           WHERE (CRS_STS_FROM_ID=crsFromFacilityKey AND CRS_STS_TO_ID=crsToFacilityKey OR CRS_STS_FROM_ID=crsToFacilityKey AND CRS_STS_TO_ID=crsFromFacilityKey) AND STS_AID=CRS_STS_DEST_PROT AND crs.NE_ID=fac.NE_ID;
        FETCH v_ref_cursor INTO ochId;
        CLOSE v_ref_cursor;
        IF ochId<>0 THEN
           addFacilityToList(neId, ochId);
        END IF;

        -- add VCG to facilities if it is a TTP CRS
        IF g_discover_vcg THEN
            SELECT vcg_Id
               BULK COLLECT INTO vcgIdList
            FROM (
                SELECT STS_TTP_VCG_ID vcg_Id FROM CM_STS WHERE STS_ID IN (crsFromFacilityKey,crsToFacilityKey) AND STS_AID LIKE 'TTP%'
                UNION
                SELECT f.FAC_IVCG_ID vcg_Id FROM CM_FACILITY f, CM_STS s WHERE s.STS_ID IN (crsFromFacilityKey, crsToFacilityKey) AND f.FAC_PARENT_ID = s.STS_ID AND s.STS_AID LIKE 'TTP%'
            );

            FOR i IN 1..vcgIdList.count LOOP
              IF vcgIdList(i)<>0 THEN
                addFacilityToList(neId, vcgIdList(i));
              END IF;
            END LOOP;
        END IF;
    circuit_util.print_end('addSTSConnectionToListX');
    END addSTSConnectionToListX;

    PROCEDURE addSTSConnectionToList(neId IN NUMBER, crsFromFacilityKey IN NUMBER, crsToFacilityKey IN NUMBER,
          fromCompositeMap IN VARCHAR2, toCompositeMap IN VARCHAR2, p_overwritten_existed BOOLEAN DEFAULT FALSE
    ) AS
        v_entity_id_nomap VARCHAR2(2000);
        v_entity_id_withmap VARCHAR2(2000);
    BEGIN circuit_util.print_start('addSTSConnectionToList');
        IF crsFromFacilityKey IS NOT NULL OR  crsToFacilityKey IS NOT  NULL THEN
            v_entity_id_nomap := to_char(neId)||g_delimiter||nvl(to_char(crsFromFacilityKey), ' ')||g_delimiter||nvl(to_char(crsToFacilityKey), ' ');
            v_entity_id_withmap:=v_entity_id_nomap||g_delimiter||nvl(to_char(fromCompositeMap), ' ')||g_delimiter||nvl(to_char(toCompositeMap), ' ');
            v_entity_id_nomap:=v_entity_id_nomap||g_delimiter||' '||g_delimiter||' ';
            IF NOT g_sts_conn_array.EXISTS(v_entity_id_nomap)
            OR (g_sts_conn_array.EXISTS(v_entity_id_nomap) AND NOT g_sts_conn_array.EXISTS(v_entity_id_withmap))
            OR p_overwritten_existed THEN
               g_sts_conn_array(v_entity_id_nomap) := 'X';
               g_sts_conn_array(v_entity_id_withmap) := 'X';
               addSTSConnectionToListX(neId, crsFromFacilityKey, crsToFacilityKey, fromCompositeMap, toCompositeMap, v_entity_id_nomap, v_entity_id_withmap, p_overwritten_existed);
            END IF;
        END IF;
    EXCEPTION
           WHEN NO_DATA_FOUND THEN
           g_sts_conn_array(v_entity_id_withmap) := 'X';
           circuit_util.print_line(v_entity_id_withmap || ' WITH EXCEPTION: HAS BEEN ADDED TO g_sts_conn_array');
    circuit_util.print_end('addSTSConnectionToList');
    END addSTSConnectionToList;
    PROCEDURE addEquipmentToListX(neId IN NUMBER, entityId IN NUMBER) AS
        v_ref_cursor          EMS_REF_CURSOR;
        facId          NUMBER;
        cardAidType        VARCHAR2(20);
    BEGIN circuit_util.print_start('addEquipmentToListX');
        -- check if this id is a valid equipment
        OPEN v_ref_cursor FOR SELECT CARD_AID_TYPE FROM CM_CARD WHERE CARD_ID=entityId;
        FETCH v_ref_cursor INTO cardAidType;

        IF v_ref_cursor%FOUND THEN
            CLOSE v_ref_cursor;
           IF cardAidType LIKE 'SMTM%' THEN
              -- add SMTM line facility with port port matching 11 (OC192/48)
              OPEN v_ref_cursor FOR SELECT FAC_ID FROM CM_FACILITY WHERE FAC_PARENT_ID=entityId AND FAC_AID_PORT=11;
              FETCH v_ref_cursor INTO facId;
              IF v_ref_cursor%NOTFOUND THEN
                 circuit_util.print_line('No line Facility found for '||entityId||'.');
              ELSE
                 addFacilityToList(neId, facId);
              END IF;
              CLOSE v_ref_cursor;
           ELSIF cardAidType LIKE 'SSM%' OR cardAidType LIKE 'OTNM%' OR cardAidType LIKE 'HDTG%' OR cardAidType LIKE 'OPSM%' OR
                 cardAidType LIKE 'OSM%' OR cardAidType LIKE 'OMMX%' OR cardAidType LIKE 'ESM%' THEN
                -- Do Nothing
                circuit_util.print_line('OTNM/HDTG/OPSM/OSMxx Found - no need for other facilities to be added');
           ELSIF cardAidType LIKE 'HGTMM%' THEN
                -- add SMTM line facility with port port matching 11 (OC192/48)
              OPEN v_ref_cursor FOR SELECT FAC_ID FROM CM_FACILITY WHERE FAC_PARENT_ID=entityId AND FAC_AID_PORT=13;
              FETCH v_ref_cursor INTO facId;
              IF v_ref_cursor%NOTFOUND THEN
                 circuit_util.print_line('No line Facility found for '||entityId||'.');
              ELSE
                 addFacilityToList(neId, facId);
              END IF;
              CLOSE v_ref_cursor;
           ELSIF cardAidType LIKE 'FGTMM%' THEN
              -- add OCH-P facility, if any to facilities
              OPEN v_ref_cursor FOR SELECT OCH_ID FROM CM_CHANNEL_OCH WHERE (OCH_TYPE = 'P' OR OCH_TYPE = 'CP' OR OCH_TYPE = '1') AND OCH_PARENT_ID=entityId;
              FETCH v_ref_cursor INTO facId;
              IF v_ref_cursor%NOTFOUND THEN
                 circuit_util.print_line('No OCH/OCH-P/OCH-CP Facility found for '||entityId||'.');
              ELSE
                 addFacilityToList(neId, facId);
              END IF;
              CLOSE v_ref_cursor;
           ELSE -- handle other card types
              -- add port facility, if any to facilities
              OPEN v_ref_cursor FOR SELECT FAC_ID FROM CM_FACILITY WHERE FAC_PARENT_ID=entityId;
              FETCH v_ref_cursor INTO facId;
              IF v_ref_cursor%NOTFOUND THEN
                 circuit_util.print_line('No Port Facility found for '||entityId||'.');
              ELSE
                 addFacilityToList(neId, facId);
              END IF;
              CLOSE v_ref_cursor;

              -- add OCH-P facility, if any to facilities
              OPEN v_ref_cursor FOR SELECT OCH_ID FROM CM_CHANNEL_OCH WHERE (OCH_TYPE = 'P' OR OCH_TYPE = 'CP' OR OCH_TYPE = '1') AND OCH_PARENT_ID=entityId;
              FETCH v_ref_cursor INTO facId;
              IF v_ref_cursor%NOTFOUND THEN
                 circuit_util.print_line('No OCH/OCH-P/OCH-CP Facility found for '||entityId||'.');
              ELSE
                 addFacilityToList(neId, facId);
              END IF;
              CLOSE v_ref_cursor;
           END IF;

           addEqptToListX(entityId);
        END IF;
    circuit_util.print_end('addEquipmentToListX');
    END addEquipmentToListX;

    PROCEDURE addEquipmentToList(neId IN NUMBER, entityId IN NUMBER) AS
    BEGIN circuit_util.print_start('addEquipmentToList');
        IF NOT g_eqpt_array.EXISTS(entityId) THEN
           g_eqpt_array(entityId) := 'X';
           addEquipmentToListX(neId, entityId);
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           g_eqpt_array(entityId) := 'X';
           circuit_util.print_line(entityId || ' WITH EXCEPTION: HAS BEEN ADDED TO g_eqpt_array');
    circuit_util.print_end('addEquipmentToList');
    END addEquipmentToList;
    PROCEDURE addOSMSNCFFP(neId IN NUMBER, facilityId IN NUMBER) AS
        v_ref_cursor                 EMS_REF_CURSOR;
        SRCprotectingFacId    NUMBER;
        DSTprotectingFacId    NUMBER;
     BEGIN circuit_util.print_start('addOSMSNCFFP');
        OPEN v_ref_cursor FOR SELECT CRS_ODU_SRC_PROT_ID FROM CM_CRS_ODU WHERE CRS_ODU_FROM_ID = facilityId AND CRS_ODU_CCTYPE LIKE '%WAYPR' AND CRS_ODU_SRC_PROT_ID IS NOT NULL;
        FETCH v_ref_cursor INTO SRCprotectingFacId;
        IF v_ref_cursor%FOUND THEN
          CLOSE v_ref_cursor;
           addFFPtoList(neId,facilityId, SRCprotectingFacId);
        END IF;

        OPEN v_ref_cursor FOR SELECT CRS_ODU_DEST_PROT_ID FROM CM_CRS_ODU WHERE CRS_ODU_TO_ID = facilityId AND CRS_ODU_CCTYPE LIKE '%WAYPR' AND CRS_ODU_DEST_PROT_ID IS NOT NULL;
        FETCH v_ref_cursor INTO DSTprotectingFacId;
        IF v_ref_cursor%FOUND THEN
            CLOSE v_ref_cursor;
            addFFPtoList(neId,facilityId, DSTprotectingFacId);
        END IF;
    circuit_util.print_end('addOSMSNCFFP');
    END addOSMSNCFFP;

    FUNCTION addFiberNonTrmCrsResource(
        p_ne_id NUMBER,    p_ne_tid VARCHAR2,  p_crs_cctype1 VARCHAR2,
        p_crs_ccpath1 VARCHAR2, p_crs_och1_dwdmside VARCHAR2, p_fac_eqpt_id1 NUMBER,
        p_fac_eqpt_aid1 VARCHAR2, p_fac_id1 NUMBER, p_fac_aid1 VARCHAR2,
        p_ochp_id1 NUMBER, p_ochp_aid1 VARCHAR2, p_ochl_id1 VARCHAR2,
        p_fac_eqpt_id2 NUMBER, p_fac_eqpt_aid2 VARCHAR2, p_fac_id2 NUMBER,
        p_fac_aid2 VARCHAR2,   p_ochp_id2 NUMBER, p_ochp_aid2 VARCHAR2,
        p_ochp_port1 NUMBER, p_ochp_port2 NUMBER
    ) RETURN VARCHAR2 AS
        v_ochl_aid1 VARCHAR2(100);
        v_associate_key VARCHAR2(300);
        v_oeo_cctype VARCHAR2(20);
        v_crs_ochl_id2 NUMBER;
    BEGIN
        SELECT och_aid INTO v_ochl_aid1 FROM cm_channel_och WHERE och_id=p_ochl_id1;
        v_oeo_cctype := p_crs_cctype1;
        IF p_crs_cctype1 LIKE '1WAY%' THEN
            v_oeo_cctype := '1WAY';
        END IF;
        v_associate_key := p_ne_id;
        v_associate_key := v_associate_key ||p_ne_id||v_ochl_aid1||p_ne_id||p_ochp_aid1;
        v_associate_key := v_associate_key ||'&'||p_ne_id||p_ne_id||p_ochp_aid2||p_ne_id||p_ochp_aid2;

        v_associate_key := v_associate_key ||',COMPOSITE,'||v_oeo_cctype||',OEO REGEN,'||p_ne_tid||','||p_crs_och1_dwdmside||','||p_ochp_aid2||','||
        v_ochl_aid1||','||p_ochp_aid2||','||p_fac_eqpt_aid1||','||p_fac_eqpt_aid2||','||p_ochp_port1||','||p_ochp_port2;
        addCompConnectionToList(p_ne_id, p_ochl_id1, v_crs_ochl_id2, v_associate_key);
        
        RETURN v_crs_ochl_id2 ;
    END addFiberNonTrmCrsResource;
    
    FUNCTION addNonTrmCrsResource(
        p_ne_id NUMBER,    p_ne_tid VARCHAR2,  p_crs_cctype1 VARCHAR2,
        p_crs_ccpath1 VARCHAR2, p_crs_och1_dwdmside VARCHAR2, p_fac_eqpt_id1 NUMBER,
        p_fac_eqpt_aid1 VARCHAR2, p_fac_id1 NUMBER, p_fac_aid1 VARCHAR2,
        p_ochp_id1 NUMBER, p_ochp_aid1 VARCHAR2, p_ochl_id1 VARCHAR2,
        p_fac_eqpt_id2 NUMBER, p_fac_eqpt_aid2 VARCHAR2, p_fac_id2 NUMBER,
        p_fac_aid2 VARCHAR2,   p_ochp_id2 NUMBER, p_ochp_aid2 VARCHAR2,
        p_ochp_port1 NUMBER, p_ochp_port2 NUMBER, circuitType VARCHAR2
    ) RETURN VARCHAR2 AS
        v_ochl_aid1 VARCHAR2(100);
        v_associate_key VARCHAR2(300);
        v_oeo_cctype VARCHAR2(20);
        v_crs_ochl_id2 NUMBER;
        v_count NUMBER;
        v_fiberlink FIBERLINK_RECORD;
    BEGIN
        addEquipmentToList(p_ne_id, p_fac_eqpt_id1);
        addEquipmentToList(p_ne_id, p_fac_eqpt_id2);
        addFacilityToList(p_ne_id,  p_ochp_id1);addFacilityToList(p_ne_id, p_ochl_id1); addFacilityToList(p_ne_id, p_fac_id1);
        addFacilityToList(p_ne_id,  p_ochp_id2);addFacilityToList(p_ne_id, p_fac_id2);


        FOR l_crs IN (
              SELECT crs_from_id, crs_to_id, crs_cctype, ochl.och_aid ochl_aid2, ochl.och_dwdmside och1_dwdmside2,crs_from_aid_type,crs_to_aid_type
              FROM CM_CRS crs LEFT JOIN cm_channel_och ochl ON ( (crs_from_id=ochl.och_id AND crs_from_aid_type='OCH-L') OR (crs_to_id=ochl.och_id AND crs_to_aid_type='OCH-L'))
              WHERE (crs_from_id=p_ochp_id2 OR crs_to_id=p_ochp_id2) AND (crs_ccpath='ADD/DROP' OR crs_ccpath!=p_crs_ccpath1)
        )LOOP
            /*
            addEquipmentToList(p_ne_id, p_fac_eqpt_id1);
            addEquipmentToList(p_ne_id, p_fac_eqpt_id2);
            addFacilityToList(p_ne_id,  p_ochp_id1);addFacilityToList(p_ne_id, p_ochl_id1); addFacilityToList(p_ne_id, p_fac_id1);
            addFacilityToList(p_ne_id,  l_crs.crs_from_id);addFacilityToList(p_ne_id, l_crs.crs_to_id); addFacilityToList(p_ne_id, p_fac_id2);
            */
            --TWo ADD/DROP, one ADD + one DROP
            addConnectionToList(p_ne_id, l_crs.crs_from_id, l_crs.crs_to_id);
            --ochId;                    crsToFacilityKey := otherOchIdList(i);
            IF p_ochp_id2 = l_crs.crs_from_id THEN
                v_crs_ochl_id2 := l_crs.crs_to_id;
            ELSE
                v_crs_ochl_id2 := l_crs.crs_from_id;
            END IF;
            addFacilityToList(p_ne_id,  v_crs_ochl_id2);

            SELECT och_aid INTO v_ochl_aid1 FROM cm_channel_och WHERE och_id=p_ochl_id1;
            v_oeo_cctype := p_crs_cctype1;
            IF p_crs_cctype1 LIKE '1WAY%' OR l_crs.crs_cctype LIKE '1WAY%' THEN
                v_oeo_cctype := '1WAY';
            END IF;
            v_associate_key := p_ne_id;
            SELECT count(*) INTO v_count FROM cm_crs WHERE crs_from_id=p_ochp_id1;
            IF v_count=1 THEN
                v_associate_key := v_associate_key ||p_ne_id||p_ochp_aid1||p_ne_id||v_ochl_aid1;
            ELSE
                v_associate_key := v_associate_key ||p_ne_id||v_ochl_aid1||p_ne_id||p_ochp_aid1;
            END IF;

            IF l_crs.crs_from_id = p_ochp_id2 THEN
                v_associate_key := v_associate_key ||'&'||p_ne_id||p_ne_id||p_ochp_aid2||p_ne_id||l_crs.ochl_aid2;
            ELSE
                v_associate_key := v_associate_key ||'&'||p_ne_id||p_ne_id||l_crs.ochl_aid2||p_ne_id||p_ochp_aid2;
            END IF;

            v_associate_key := v_associate_key ||',COMPOSITE,'||v_oeo_cctype||',OEO REGEN,'||p_ne_tid||','||p_crs_och1_dwdmside||','||l_crs.och1_dwdmside2||','||
            v_ochl_aid1||','||l_crs.ochl_aid2||','||p_fac_eqpt_aid1||','||p_fac_eqpt_aid2||','||p_ochp_port1||','||p_ochp_port2;
            addCompConnectionToList(p_ne_id, p_ochl_id1, v_crs_ochl_id2, v_associate_key);
        END LOOP;

         if v_crs_ochl_id2 is null then
             v_crs_ochl_id2 := findFiberLinkFromOCH(p_ochp_id2, 'BOTH', 0, 'TRY_TO_FIND', v_fiberlink);
             if v_crs_ochl_id2 >0 then
               v_crs_ochl_id2 := addFiberNonTrmCrsResource(
               p_ne_id,            p_ne_tid,             p_crs_cctype1,
               p_crs_ccpath1,      p_crs_och1_dwdmside,  p_fac_eqpt_id1,
               p_fac_eqpt_aid1,    p_fac_id1,            p_fac_aid1,
               p_ochp_id1,         p_ochp_aid1,          p_ochl_id1,
               p_fac_eqpt_id2,     p_fac_eqpt_aid2,      p_fac_id2,
               p_fac_aid2,         p_ochp_id2,           p_ochp_aid2,
               p_ochp_port1,       p_ochp_port2); 
                                                
               v_crs_ochl_id2 := findXCFromOCHX(p_ochp_id2, 'BOTH', p_ochp_id1, circuitType);                      
             end if;                    
             v_crs_ochl_id2 := null;
         end if;
        
        RETURN v_crs_ochl_id2 ;
    END addNonTrmCrsResource;

    PROCEDURE addRptCircuitCache(circuitType VARCHAR2, p_store_point NUMBER)
    AS
        v_duplicate BOOLEAN := FALSE;
        v_selected_row VARCHAR2(200);
    BEGIN
        IF NOT g_rpt_start_cache.exists(g_rpt_start_id) THEN
            g_rpt_start_cache(g_rpt_start_id) := g_rpt_end_id;
        END IF;
        IF g_rpt_conn_List.count > 0 THEN
            circuit_util.print_line('Save OCH Circuit: g_rpt_id='||g_rpt_id||',g_rpt_start_id='||g_rpt_start_id||',g_rpt_end_id='||g_rpt_end_id);
            FOR v_circuit_resource IN(SELECT c.*,rowid FROM nm_circuit_cache c WHERE report_id=g_rpt_id AND start_id=g_rpt_start_id AND end_id=g_rpt_end_id AND direction=g_rpt_direction)
            LOOP
                v_duplicate := TRUE;
                v_selected_row := v_circuit_resource.rowid;
                circuit_util.PRINT_LINE('duplicate the circuit');
                IF v_circuit_resource.links IS NOT NULL AND v_circuit_resource.links.count !=0 THEN
                    FOR i IN v_circuit_resource.links.first..v_circuit_resource.links.last
                    LOOP
                        IF NOT g_link_array.EXISTS(v_circuit_resource.links(i)) THEN
                            g_rpt_link_List.EXTEND;
                            g_rpt_link_List(g_rpt_link_List.COUNT):=v_circuit_resource.links(i);
                            g_link_array(v_circuit_resource.links(i)) := 'X';
                        END IF;
                    END LOOP;
                END IF;
                IF v_circuit_resource.connections IS NOT NULL AND v_circuit_resource.connections.count !=0 THEN
                    FOR i IN v_circuit_resource.connections.first..v_circuit_resource.connections.last
                    LOOP
                        IF NOT g_conn_array.EXISTS(v_circuit_resource.connections(i)) THEN
                            g_rpt_conn_List.EXTEND;
                            g_rpt_conn_List(g_rpt_conn_List.COUNT):=v_circuit_resource.connections(i);
                            g_conn_array(v_circuit_resource.connections(i)) := 'X';
                        END IF;
                    END LOOP;
                END IF;
                IF v_circuit_resource.expresses IS NOT NULL AND v_circuit_resource.expresses.count !=0 THEN
                    FOR i IN v_circuit_resource.expresses.first..v_circuit_resource.expresses.last
                    LOOP
                        IF NOT g_exp_link_array.EXISTS(v_circuit_resource.expresses(i)) THEN
                            g_rpt_exp_List.EXTEND;
                            g_rpt_exp_List(g_rpt_exp_List.COUNT):=v_circuit_resource.expresses(i);
                            g_exp_link_array(v_circuit_resource.expresses(i)) := 'X';
                        END IF;
                    END LOOP;
                END IF;
                IF v_circuit_resource.facilities IS NOT NULL AND v_circuit_resource.facilities.count !=0 THEN
                    FOR i IN v_circuit_resource.facilities.first..v_circuit_resource.facilities.last
                    LOOP
                        IF NOT g_fac_array.EXISTS(v_circuit_resource.facilities(i)) THEN
                            g_fac_List.EXTEND;
                            g_fac_List(g_fac_List.COUNT):=v_circuit_resource.facilities(i);
                            g_fac_array(v_circuit_resource.facilities(i)) := 'X';
                        END IF;
                    END LOOP;
                END IF;
                IF v_circuit_resource.equipments IS NOT NULL AND v_circuit_resource.equipments.count !=0 THEN
                    FOR i IN v_circuit_resource.equipments.first..v_circuit_resource.equipments.last
                    LOOP
                        IF NOT g_eqpt_array.EXISTS(v_circuit_resource.equipments(i)) THEN
                            g_eqpt_List.EXTEND;
                            g_eqpt_List(g_eqpt_List.COUNT):=v_circuit_resource.equipments(i);
                            g_eqpt_array(v_circuit_resource.equipments(i)) := 'X';
                        END IF;
                    END LOOP;
                END IF;
                IF v_circuit_resource.ffps IS NOT NULL AND v_circuit_resource.ffps.count !=0 THEN
                    FOR i IN v_circuit_resource.ffps.first..v_circuit_resource.ffps.last
                    LOOP
                        IF NOT g_ffp_array.EXISTS(v_circuit_resource.ffps(i)) THEN
                            g_rpt_ffp_List.EXTEND;
                            g_rpt_ffp_List(g_rpt_ffp_List.COUNT):=v_circuit_resource.ffps(i);
                            g_ffp_array(v_circuit_resource.ffps(i)) := 'X';
                        END IF;
                    END LOOP;
                END IF;
            END LOOP;
            IF v_duplicate THEN
                DELETE FROM nm_circuit_cache WHERE rowid=v_selected_row;
            END IF;
            INSERT INTO NM_CIRCUIT_CACHE(circuit_id,report_id, start_id, end_id, direction, dontFindMeId, links, connections, expresses, facilities, equipments, ffps, min_x_left, max_x_right, min_y_top, max_y_bottom, init_id, store_point)
                  VALUES(seq_nm_circuit_cache.nextval,g_rpt_id, g_rpt_start_id, g_rpt_end_id, g_rpt_direction, g_rpt_dontFindMeId, g_rpt_link_list, g_rpt_conn_List, g_rpt_exp_list,g_rpt_fac_List,g_rpt_eqpt_List, g_rpt_ffp_List, g_min_x, g_max_x, g_min_y, g_max_y, g_rpt_init_id, p_store_point);
        END IF;
        clearRptCache();
    END addRptCircuitCache;
    FUNCTION buildCompLinkEnds(
        ochlId IN VARCHAR2, compLinksEnds OUT NOCOPY V_B_TEXT, compLinksEndsNEId OUT NOCOPY NUMBER,
        directions OUT NOCOPY V_B_TEXT
    ) RETURN NUMBER IS
        endsCounter NUMBER;
        otherOchIdList          IntTable;
        otherOchTypeList        StringTable70;
        otherOchAidList         StringTable70;
        otherOchNeIdList        StringTable70;
        xcCount NUMBER;
        odu2Id NUMBER;
        odu2Aid VARCHAR2(20);
        ochAid VARCHAR2(20);
        neId NUMBER;
        otherOchCCPathList StringTable70;
        ccinfolist StringTable70;
        v_ref_cursor     EMS_REF_CURSOR;
        interestXC    BOOLEAN;
    BEGIN
        compLinksEnds := NEW V_B_TEXT();
        directions := NEW V_B_TEXT();
        endsCounter := 0;
        EXECUTE IMMEDIATE
            'select c.crs_from_id, c.crs_from_aid_type, o.och_aid, o.ne_id, c.crs_ccpath,c.ne_id||'',''||C.CRS_FROM_ID||'',''||c.crs_to_id from cm_crs c , cm_channel_och o where c.crs_from_id = o.och_id and c.crs_to_id = ' ||ochlId||
            ' union '||
            'select c.crs_to_id, c.crs_to_aid_type, o.och_aid, o.ne_id, c.crs_ccpath,c.ne_id||'',''||C.CRS_FROM_ID||'',''||c.crs_to_id from cm_crs c , cm_channel_och o where c.crs_to_id = o.och_id and crs_from_id = ' ||ochlId
        BULK COLLECT INTO otherOchIdList, otherOchTypeList, otherOchAidList, otherOchNeIdList, otherOchCCPathList, ccinfolist;

        IF otherOchIdList IS NOT NULL THEN
            xcCount := otherOchIdList.COUNT;
        END IF;

        OPEN v_ref_cursor FOR SELECT OCH_AID,NE_ID FROM CM_CHANNEL_OCH WHERE OCH_ID = ochlId;
        FETCH v_ref_cursor INTO ochAid,neId;
        CLOSE v_ref_cursor;
        compLinksEndsNEId := neId;

        IF xcCount = 0 THEN
            -- no add/drop and no pass through XCs
            endsCounter := endsCounter + 1;
            compLinksEnds.extend;
            compLinksEnds(endsCounter) := ochAid;
            directions.extend;
            directions(endsCounter) := 'B';
        END IF;

        FOR i IN 1..xcCount LOOP
            interestXC := FALSE;
            FOR j IN 1..g_conn_List.count LOOP
                IF g_conn_List(j) = ccinfolist(i) THEN
                    interestXC := TRUE;
                    EXIT;
                END IF;
            END LOOP;
            IF interestXC = TRUE THEN
                endsCounter := endsCounter + 1;
                directions.extend;
                IF otherOchCCPathList(i) = 'DROP' THEN
                    directions(endsCounter) := 'Z';
                ELSIF otherOchCCPathList(i) = 'ADD' THEN
                    directions(endsCounter) := 'A';
                ELSE
                    directions(endsCounter) := 'B';
                END IF;

                IF otherOchTypeList(i) = 'OCH-L' THEN
                    -- ochl-ochl pass throughotherOchAid
                    compLinksEnds.extend;
                    compLinksEnds(endsCounter) := ochAid;
                ELSE
                    odu2Id := circuit_util.getMappingOduFromOchP(TO_NUMBER(otherOchNeIdList(i)), TO_NUMBER(otherOchIdList(i)));
                    IF odu2Id<>0 AND circuit_util.isOdu2Crossconnected(odu2Id) THEN
                        OPEN v_ref_cursor FOR SELECT FAC_AID FROM CM_FACILITY WHERE FAC_ID = odu2Id;
                        FETCH v_ref_cursor INTO odu2Aid;
                        CLOSE v_ref_cursor;
                        compLinksEnds.extend;
                        compLinksEnds(endsCounter) := odu2Aid;
                    ELSE
                        compLinksEnds.extend;
                        compLinksEnds(endsCounter) := ochAid;
                    END IF;
                END IF;
            END IF;
        END LOOP;
        RETURN endsCounter;
    END buildCompLinkEnds;


    PROCEDURE buildCompositeLinks AS
        v_ref_cursor    EMS_REF_CURSOR;
        linkInfo VARCHAR2(350);
        aOchId   VARCHAR2(50);
        zOchId   VARCHAR2(50);
        compLinksEndsA V_B_TEXT;
        compLinksEndsZ V_B_TEXT;
        compLinksEndsNeIdA NUMBER;
        compLinksEndsNeIdZ NUMBER;
        endsACounter NUMBER;
        endsZCounter NUMBER;
        aDwdmSide VARCHAR2(5);
        zDwdmSide VARCHAR2(5);
        xcchanNum NUMBER;
        directionsA V_B_TEXT;
        directionsZ V_B_TEXT;
    BEGIN
        FOR i IN 1..g_link_list.count LOOP
            linkInfo := g_link_list(i);
            aOchId := substr(linkInfo, instr(linkInfo, ',', -1, 3) + 1, instr(linkInfo, ',', -1, 2) - instr(linkInfo, ',', -1, 3) -1);
            zOchId := substr(linkInfo, instr(linkInfo, ',', -1, 2) + 1, instr(linkInfo, ',', -1, 1) - instr(linkInfo, ',', -1, 2) -1);

            OPEN v_ref_cursor FOR SELECT OCH_DWDMSIDE, OCH_CHANNUM FROM CM_CHANNEL_OCH WHERE OCH_ID = to_number(aOchId);
            FETCH v_ref_cursor INTO aDwdmSide, xcchanNum;
            CLOSE v_ref_cursor;

            OPEN v_ref_cursor FOR SELECT OCH_DWDMSIDE FROM CM_CHANNEL_OCH WHERE OCH_ID = to_number(zOchId);
            FETCH v_ref_cursor INTO zDwdmSide;
            CLOSE v_ref_cursor;

            endsACounter := buildCompLinkEnds(aOchId, compLinksEndsA, compLinksEndsNeIdA, directionsA);
            endsZCounter := buildCompLinkEnds(zOchId, compLinksEndsZ, compLinksEndsNeIdZ, directionsZ);

            FOR j IN 1..compLinksEndsA.count LOOP
                FOR k IN 1..compLinksEndsZ.count LOOP
                    IF substr(compLinksEndsA(j),1,5)!='OCH-L' OR substr(compLinksEndsZ(k),1,5)!='OCH-L' THEN
                        IF directionsA(j) = 'Z' OR directionsZ(k) = 'A' THEN
                            addCompositeLinkToList(compLinksEndsNeIdZ, compLinksEndsNeIdA, compLinksEndsZ(k), compLinksEndsA(j), zDwdmSide, aDwdmSide, xcchanNum);
                        ELSE
                            addCompositeLinkToList(compLinksEndsNeIdA, compLinksEndsNeIdZ, compLinksEndsA(j), compLinksEndsZ(k), aDwdmSide, zDwdmSide, xcchanNum);
                        END IF;
                    END IF;
                END LOOP;
            END LOOP;
            circuit_util.print_line('buildCompositeLinks:'||linkInfo);
            circuit_util.print_line('buildCompositeLinks:'||aOchId||':'||zOchId);
        END LOOP;
    END buildCompositeLinks;
    PROCEDURE buildCompositeConnections AS
        connInfo VARCHAR2(350);
        aOduId   NUMBER;
        zOduId   NUMBER;
        afacId   NUMBER;
        zfacId   NUMBER;

        aOchOduId NUMBER;
        zOchOduId NUMBER;
        odu_mapping_list V_B_STRING;
        odu_mapping_type_list V_B_STRING;
        odu_mapping_tribslot_list V_B_STRING;

        connkeyHead VARCHAR2(200);
        connkeyTail VARCHAR2(200);
        connections VARCHAR2(1000);
        ochIdfrom  VARCHAR2(50);
        ochIdto  VARCHAR2(50);
        aConnEnd VARCHAR2(50);
        zConnEnd VARCHAR2(50);
        neId  NUMBER;
        ochFromAid VARCHAR2(50);
        ochToAid VARCHAR2(50);
        aOduAid VARCHAR2(50);
        zOduAid VARCHAR2(50);
        compConnList V_B_TEXT;
        compConnCounter NUMBER;
        xcinfo VARCHAR2(1000);
        aDwdmSide VARCHAR2(50);
        zDwdmSide VARCHAR2(50);
        ccpathA VARCHAR2(10);
        cctypeA VARCHAR2(10);
        ccpathZ VARCHAR2(10);
        cctypeZ VARCHAR2(10);
        ochLA NUMBER;
        ochLZ NUMBER;
        ochlAAid VARCHAR2(50);
        ochlZAid VARCHAR2(50);
        oducctype VARCHAR2(20);
        oduccpath VARCHAR2(20);
        tmp VARCHAR2(10);
        neTid VARCHAR2(50);
        aEndAid VARCHAR2(50);
        zEndAid VARCHAR2(50);
        aEndEqpt VARCHAR2(50);
        zEndEqpt VARCHAR2(50);
        aEndOchpPort VARCHAR2(50);
        zEndOchpPort VARCHAR2(50);
        compType VARCHAR2(50);
        aLinkType VARCHAR2(10);
        zLinkType VARCHAR2(10);
        fac_aid   cm_facility.fac_aid%type;
        v_ref_cursor    EMS_REF_CURSOR;
    BEGIN circuit_util.print_start('buildCompositeConnections');
        compConnCounter := 1;
        compConnList := V_B_TEXT();
        FOR i IN 1..g_sts_conn_list.count LOOP
            connInfo := g_sts_conn_list(i);
            oducctype := '';
            connections := '';
            connkeyHead := ' ';
            connkeyTail := ' ';
            xcInfo := '';
            aEndOchpPort := ' ';
            zEndOchpPort := ' ';
            aLinkType := ' ';
            zLinkType := ' ';

            neId := substr(connInfo, 1, instr(connInfo, ',', 1, 1)-1);
            aOduId := substr(connInfo, instr(connInfo, ',', 1, 1) + 1, instr(connInfo, ',', 1, 2) - instr(connInfo, ',', 1, 1) -1);
            zOduId := substr(connInfo, instr(connInfo, ',', 1, 2) + 1, instr(connInfo, ',', 1, 3) - instr(connInfo, ',', 1, 2) -1);

            OPEN v_ref_cursor FOR select n.ne_tid, fac_aid from EMS_NE n, cm_facility f
            where n.ne_id = neId and f.ne_id = neId and f.fac_id = aOduId;
            FETCH v_ref_cursor INTO NeTid, fac_aid;
            CLOSE v_ref_cursor;

            if circuit_util.getOduLayer(fac_aid)<2 then
              goto for_loop_end;
            end if;

            afacId := 0;
            zfacId := 0;

            compType := 'COMPOSITE';
            afacId := circuit_util.getMappingOchPFromOdu(neId, aOduId);
            if afacId = 0 then
               afacId := circuit_util.getMappingFacFromOdu(neId, aOduId);
            end if;
            if afacId = 0 then
               aOchOduId := circuit_util.getTopMappingOduFromLower(neId, aOduId, odu_mapping_list,odu_mapping_type_list,odu_mapping_tribslot_list);
               afacId := circuit_util.getMappingOchPFromOdu(neId, aOchOduId);
               if afacId = 0 then
                  afacId := circuit_util.getMappingFacFromOdu(neId, aOchOduId);  
               end if;
               compType := 'ODU2_MUX';
            else
               aOchOduId := aOduId;
            end if;
            if g_flink_end_array.exists(aOchOduId) then
               aLinkType := 'FIBERLINK';
            end if;

            zfacId := circuit_util.getMappingOchPFromOdu(neId, zOduId);
            if zfacId = 0 then
               zfacId := circuit_util.getMappingFacFromOdu(neId, zOduId);
            end if;
            if zfacId = 0 then
              zOchOduId := circuit_util.getTopMappingOduFromLower(neId, zOduId, odu_mapping_list,odu_mapping_type_list,odu_mapping_tribslot_list);
              zfacId := circuit_util.getMappingOchPFromOdu(neId, zOchOduId);
              if zfacId = 0 then
                 zfacId := circuit_util.getMappingFacFromOdu(neId, zOchOduId);
              end if;
              compType := 'ODU2_MUX';
            else
              zOchOduId := zOduId;
            end if;
            if g_flink_end_array.exists(zOchOduId) then
              zLinkType := 'FIBERLINK';
            end if;

            -- don't know why previous codes set odu2_mux to composite..
            /*IF compType = 'ODU2_MUX' AND (afacId=0 OR zfacId=0) THEN
               compType := 'COMPOSITE';
            END IF;*/

            IF afacId <> 0 OR zfacId <> 0 THEN
                aConnEnd := '0';
                zConnEnd := '0';
                aEndEqpt := '0';
                zEndEqpt := '0';
                if aLinkType = 'FIBERLINK' then
                   aDwdmSide := circuit_util.getFacAidById(aOchOduId);
                else
                   aDwdmSide :='0';
                end if;
                if zLinkType = 'FIBERLINK' then
                   zDwdmSide := circuit_util.getFacAidById(zOchOduId);
                else
                   zDwdmSide :='0';
                end if;

                cctypeA := '';
                cctypeZ := '';
                ccpathA := '';
                ccpathZ := '';
                ochLA := 0;
                ochLZ := 0;

                FOR j IN 1..g_conn_List.count LOOP
                    ochIdfrom := substr(g_conn_List(j),instr(g_conn_List(j), ',', 1, 1) + 1, instr(g_conn_List(j), ',', 1, 2) - instr(g_conn_List(j), ',', 1, 1) -1);
                    ochIdto := substr(g_conn_List(j), instr(g_conn_List(j), ',', 1, 2) + 1);
                    IF aLinkType<>'FIBERLINK' and (afacId = ochIdfrom OR afacId = ochIdto) THEN
                        --get connectioninfo A
                        FOR l_crs IN (
                              SELECT CRS_CCTYPE, CRS_CCPATH,och_from.och_aid from_aid, och_from.och_aid_port from_port,och_from.och_type from_type,och_from.och_dwdmside from_side,
                                  och_to.och_aid to_aid, och_to.och_aid_port to_port,och_to.och_type to_type,och_to.och_dwdmside to_side
                              FROM cm_crs  LEFT JOIN cm_channel_och och_from ON CRS_FROM_ID = och_from.och_id
                                LEFT JOIN cm_channel_och och_to ON CRS_TO_ID = och_to.och_id
                              WHERE CRS_FROM_ID = ochIdfrom AND CRS_TO_ID = ochIdto
                        ) LOOP
                            cctypeA := l_crs.CRS_CCTYPE;
                            ccpathA := l_crs.CRS_CCPATH;
                            aLinkType := 'DWDMLINK';
                            IF l_crs.from_type = 'L' THEN
                                ochLA := ochIdfrom;
                                aDwdmSide := l_crs.from_side;
                                ochlAAid := l_crs.from_aid;
                                aEndOchpPort := l_crs.to_port;
                            ELSE
                                ochLA := ochIdto;
                                aDwdmSide := l_crs.to_side;
                                ochlAAid := l_crs.to_aid;
                                aEndOchpPort := l_crs.from_port;
                            END IF;
                            ochFromAid := l_crs.from_aid;
                            ochToAid := l_crs.to_aid;
                        END LOOP;
                        connkeyHead := neId||neId||ochFromAid||neId||ochToAid;
                    ELSIF zLinkType<>'FIBERLINK' and (zfacId = ochIdfrom OR zfacId = ochIdto) THEN
                        FOR l_crs IN (
                            SELECT CRS_CCTYPE, CRS_CCPATH,och_from.och_aid from_aid, och_from.och_aid_port from_port,och_from.och_type from_type,och_from.och_dwdmside from_side,
                                och_to.och_aid to_aid, och_to.och_aid_port to_port,och_to.och_type to_type,och_to.och_dwdmside to_side
                            FROM cm_crs  LEFT JOIN cm_channel_och och_from ON CRS_FROM_ID = och_from.och_id
                              LEFT JOIN cm_channel_och och_to ON CRS_TO_ID = och_to.och_id
                            WHERE CRS_FROM_ID = ochIdfrom AND CRS_TO_ID = ochIdto
                        ) LOOP
                            cctypeZ := l_crs.CRS_CCTYPE;
                            ccpathZ := l_crs.CRS_CCPATH;
                            zLinkType := 'DWDMLINK';
                            IF l_crs.from_type = 'L' THEN
                                ochLZ := ochIdfrom;
                                zDwdmSide := l_crs.from_side;
                                ochlZAid := l_crs.from_aid;
                                zEndOchpPort := l_crs.to_port;
                            ELSE
                                ochLZ := ochIdto;
                                zDwdmSide := l_crs.to_side;
                                ochlZAid := l_crs.to_aid;
                                zEndOchpPort := l_crs.from_port;
                            END IF;
                            ochFromAid := l_crs.from_aid;
                            ochToAid := l_crs.to_aid;
                        END LOOP;
                        connkeyTail := neId||neId||ochFromAid||neId||ochToAid;
                    END IF;
                END LOOP;

                OPEN v_ref_cursor FOR select CRS_ODU_CCTYPE from CM_CRS_ODU where CRS_ODU_FROM_ID = aOduId and CRS_ODU_TO_ID = zOduId;
                FETCH v_ref_cursor into oducctype;
                CLOSE v_ref_cursor;
                IF nvl(oducctype,'0') = '0' THEN
                    OPEN v_ref_cursor FOR select CRS_ODU_CCTYPE from CM_CRS_ODU where (CRS_ODU_FROM_ID = aOduId and CRS_ODU_DEST_PROT_ID = zOduId) or (CRS_ODU_SRC_PROT_ID = aOduId and CRS_ODU_TO_ID = zOduId) or (CRS_ODU_SRC_PROT_ID = aOduId and CRS_ODU_DEST_PROT_ID = zOduId);
                    FETCH v_ref_cursor into oducctype;
                    CLOSE v_ref_cursor;
                END IF;
                OPEN v_ref_cursor FOR select FAC_AID from CM_FACILITY where FAC_ID = aOduId;
                FETCH v_ref_cursor into aOduAid;
                CLOSE v_ref_cursor;
                OPEN v_ref_cursor FOR select FAC_AID from CM_FACILITY where FAC_ID = zOduId;
                FETCH v_ref_cursor  into zOduAid;
                CLOSE v_ref_cursor;

                IF (cctypeA LIKE '1WAY%' AND ccpathA = 'ADD') OR (cctypeZ LIKE '1WAY%' AND ccpathZ = 'DROP') THEN
                    IF ochLA <> 0 THEN
                        zConnEnd := ochLA;
                        zEndAid := ochlAAid;
                    ELSE
                        zConnEnd := aOduId;
                        zEndAid := aOduAid;
                    END IF;
                    IF ochLZ <> 0 THEN
                        aConnEnd := ochLZ;
                        aEndAid := ochlZAid;
                    ELSE
                        aConnEnd := zOduId;
                        aEndAid := zOduAid;
                    END IF;
                    tmp := zDwdmSide;
                    zDwdmSide := aDwdmSide;
                    aDwdmSide := tmp;
                ELSE
                    IF ochLA <> 0 THEN
                        aConnEnd := ochLA;
                        aEndAid := ochlAAid;
                    ELSE
                        aConnEnd := aOduId;
                        aEndAid := aOduAid;
                    END IF;
                    IF ochLZ <> 0 THEN
                        zConnEnd := ochLZ;
                        zEndAid := ochlZAid;
                    ELSE
                        zConnEnd := zOduId;
                        zEndAid := zOduAid;
                    END IF;
                END IF;

                IF cctypeA LIKE '1WAY%' OR cctypeZ LIKE '1WAY%' THEN
                    oducctype := '1WAY';
                    IF oducctype LIKE '%WAYPR' THEN
                       oducctype := '1WAYPR';
                    END IF;
                END IF;

                IF (nvl(ccpathA,'0') <> '0' OR aLinkType = 'FIBERLINK') AND
                   (nvl(ccpathZ,'0') <> '0' OR zLinkType = 'FIBERLINK')
                THEN
                    oduccpath := substr(aOduAid,0,instr( aOduAid,'-')-1)||' REGEN';
                ELSIF nvl(ccpathA,'0') <> '0' THEN
                    oduccpath := ccpathA;
                ELSIF nvl(ccpathZ,'0') <> '0' THEN
                    oduccpath := ccpathZ;
                ELSIF (aLinkType = 'FIBERLINK') OR (zLinkType = 'FIBERLINK') THEN
                    oduccpath := 'ADD/DROP';
                END IF;

                --IF substr(aEndAid,1,4) = 'ODU2' THEN
                IF circuit_util.getOduLayer(aEndAid) >1 THEN
                    OPEN v_ref_cursor FOR select c.card_aid from cm_card c, cm_facility f
                        where f.ne_id = c.ne_id and f.fac_aid_shelf = c.card_aid_shelf and f.fac_aid_slot = c.card_aid_slot
                        and f.fac_cptype = c.card_cptype and f.fac_id = aConnEnd;
                    FETCH v_ref_cursor into aEndEqpt;
                    CLOSE v_ref_cursor;
                END IF;
                --IF substr(zEndAid,1,4) = 'ODU2' THEN
                IF circuit_util.getOduLayer(zEndAid) >1 THEN
                    OPEN v_ref_cursor FOR select c.card_aid from cm_card c, cm_facility f
                        where f.ne_id = c.ne_id and f.fac_aid_shelf = c.card_aid_shelf and f.fac_aid_slot = c.card_aid_slot
                              and f.fac_cptype = c.card_cptype and f.fac_id = zConnEnd;
                      FETCH v_ref_cursor into zEndEqpt ;
                      CLOSE v_ref_cursor;
                END IF;

                IF connkeyHead <> ' ' THEN
                    connections := connkeyHead||'&';
                END IF;
                connections := connections||neId||neId||aOduAid||neId||zOduAid;
                IF connkeyTail <> ' ' THEN
                    connections := connections||'&'||connkeyTail;
                END IF;
                xcInfo:=to_char(neId)||g_delimiter||nvl(to_char(aConnEnd), ' ')||g_delimiter||nvl(to_char(zConnEnd), ' ')||g_delimiter||nvl(to_char(connections), ' ')||g_delimiter||compType||g_delimiter||oducctype||g_delimiter||nvl(oduccpath,' ')||g_delimiter||neTid||g_delimiter||aDwdmSide||g_delimiter||zDwdmSide||g_delimiter||aEndAid||g_delimiter||zEndAid||g_delimiter||aEndEqpt||g_delimiter||zEndEqpt||g_delimiter||nvl(aEndOchpPort,' ')||g_delimiter||nvl(zEndOchpPort,' ');

                compConnList.extend;
                compConnList(compConnCounter):=xcInfo;
                compConnCounter:=compConnCounter+1;
            END IF;
            <<for_loop_end>>
            null;
        END LOOP;

        FOR i IN 1..compConnList.count LOOP
            addConnToListX(compConnList(i));
        END LOOP;
        circuit_util.print_end('buildCompositeConnections');
    END buildCompositeConnections;

    PROCEDURE checkForDuplicateProcessing(duplicateCheckKey IN VARCHAR2, doesExist OUT NUMBER) AS
    BEGIN circuit_util.print_start('checkForDuplicateProcessing');
        doesExist := 0;
        IF g_id_array.EXISTS(duplicateCheckKey) THEN
           doesExist := 1;
           circuit_util.print_line(duplicateCheckKey || ' HAS ALREADY BEEN PROCESSED');
        ELSE
           g_id_array(duplicateCheckKey) := 'X';
        END IF;
       circuit_util.print_end('checkForDuplicateProcessing');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        g_id_array(duplicateCheckKey) := 'X';
        circuit_util.print_line(duplicateCheckKey || ' WITH EXCEPTION: HAS BEEN ADDED TO DUPLICATES');
        --circuit_util.print_line(duplicateCheckKey|| ' checkForDuplicateProcessing End');
    circuit_util.print_end('checkForDuplicateProcessing'); END;

    PROCEDURE checkForDuplicateProcessingSTS(duplicateCheckKey IN VARCHAR2, doesExist OUT NUMBER) AS
    BEGIN circuit_util.print_start('checkForDuplicateProcessingSTS');
        doesExist := 0;
        IF g_id_array_sts.EXISTS(duplicateCheckKey) THEN
           doesExist := 1;
           circuit_util.print_line(duplicateCheckKey || ' HAS ALREADY BEEN PROCESSED');
        ELSE
           g_id_array_sts(duplicateCheckKey) := 'X';
           IF g_cache_och_circuit THEN
              g_rpt_sts_id_list.EXTEND;
              g_rpt_sts_id_list(g_rpt_sts_id_list.count):=duplicateCheckKey;
           END IF;
        END IF;
       circuit_util.print_end('checkForDuplicateProcessingSTS');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            g_id_array_sts(duplicateCheckKey) := 'X';
            circuit_util.print_line(duplicateCheckKey || ' WITH EXCEPTION: HAS BEEN ADDED TO DUPLICATES');
    circuit_util.print_end('checkForDuplicateProcessingSTS'); END;
    PROCEDURE checkForDuplicateProcessingODU(
        duplicateCheckKey IN VARCHAR2, doesExist OUT NOCOPY NUMBER
    ) AS
    BEGIN circuit_util.print_start('checkForDuplicateProcessingODU');
        doesExist := 0;
        IF g_id_array_odu.EXISTS(duplicateCheckKey) THEN
           doesExist := 1;
           circuit_util.print_line(duplicateCheckKey || ' HAS ALREADY BEEN PROCESSED');
        ELSE
           g_id_array_odu(duplicateCheckKey) := 'X';
           IF g_cache_och_circuit THEN
              g_rpt_odu_id_list.EXTEND;
              g_rpt_odu_id_list(g_rpt_odu_id_list.count):=duplicateCheckKey;
           END IF;
        END IF;
       circuit_util.print_end('checkForDuplicateProcessingODU');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            g_id_array_odu(duplicateCheckKey) := 'X';
            circuit_util.print_line(duplicateCheckKey || ' WITH EXCEPTION: HAS BEEN ADDED TO DUPLICATES');
    END checkForDuplicateProcessingODU;

    PROCEDURE getOPSMDPFFP(
        neId IN NUMBER, eqptId IN VARCHAR2, channelNo IN VARCHAR2,
        side IN VARCHAR
    ) AS
        v_ref_cursor          EMS_REF_CURSOR;
        workingAid     VARCHAR2(20);
        protectingAid  VARCHAR2(20);
        frEqptId       NUMBER;
        toEqptId       NUMBER;
        frPort         NUMBER;
        toPort         NUMBER;
        intfId         NUMBER;
        facId          NUMBER;
        workingFacId       NUMBER;
        protectingFacId    NUMBER;
        intfPort           NUMBER;
     BEGIN circuit_util.print_start('getOPSMDPFFP');
        OPEN v_ref_cursor FOR SELECT CONN_FROM_ID, CONN_TO_ID, CONN_FROMPORT, CONN_TOPORT FROM CM_FIBR_CONN
           WHERE CM_FIBR_CONN.NE_ID=neId AND CONN_TO_ID=eqptId AND CONN_FROMPORT=channelNo AND CONN_DWDMSIDE=side;
        FETCH v_ref_cursor INTO frEqptId, toEqptId, frPort, toPort;
        IF v_ref_cursor%FOUND THEN
           CLOSE v_ref_cursor;

           intfPort := ceil(toPort/3);
           OPEN v_ref_cursor FOR SELECT INTF_ID, INTF_PROTECTEDAID, INTF_PROTECTINGAID FROM CM_INTERFACE
              WHERE NE_ID=neId AND INTF_PARENT_ID=toEqptId AND INTF_AID_PORT=intfPort;
           FETCH v_ref_cursor INTO intfId, workingAid, protectingAid;
           IF v_ref_cursor%FOUND THEN
              CLOSE v_ref_cursor;
              OPEN v_ref_cursor FOR SELECT a.FAC_ID, b.FAC_ID FROM CM_FACILITY a, CM_FACILITY b
                 WHERE a.NE_ID=neId AND b.NE_ID=neId AND a.FAC_PARENT_ID=intfId AND b.FAC_PARENT_ID=intfId AND a.FAC_AID=workingAid AND b.FAC_AID=protectingAid;
              FETCH v_ref_cursor INTO workingFacId, protectingFacId;
              IF v_ref_cursor%FOUND THEN
                 CLOSE v_ref_cursor;
                 addFFPtoList(neId,workingFacId, protectingFacId);
                 -- add GOPT-x-y to facilities
                 OPEN v_ref_cursor FOR SELECT FAC_ID FROM CM_FACILITY WHERE NE_ID=neId AND FAC_PARENT_ID=intfId AND FAC_AID LIKE 'GOPT'||SUBSTR(workingAid,7,INSTR(workingAid,'-',2))||'%';
                 FETCH v_ref_cursor INTO facId;
                 IF v_ref_cursor%NOTFOUND THEN
                    circuit_util.print_line('No GOPT-x-y found for '||eqptId||'.');
                 ELSE
                    addFacilityToList(neId, facId);
                 END IF;
              END IF;
           END IF;
        END IF;
        CLOSE v_ref_cursor;
       circuit_util.print_end('getOPSMDPFFP');
    END getOPSMDPFFP;

    FUNCTION getOPSMDPProtectionEquipmentId(
        neId IN NUMBER, entityId1 IN NUMBER, entityId2 IN NUMBER,
        otherRouteOchId OUT NUMBER
    ) RETURN NUMBER AS
        v_ref_cursor          EMS_REF_CURSOR;
        ochAid         VARCHAR2(20);
        eqptId         NUMBER;
        toPort         NUMBER;
        entityId       NUMBER;
        channelNo      VARCHAR2(5);
        channelNoFrom  VARCHAR2(5);
        channelNoTo    VARCHAR2(5);
        side           VARCHAR2(50);
        otherSide      VARCHAR2(1);
    BEGIN circuit_util.print_start('getOPSMDPProtectionEquipmentId');
        eqptId:=0;

        OPEN v_ref_cursor FOR SELECT OCH_ID, OCH_AID, OCH_DWDMSIDE FROM CM_CHANNEL_OCH
           WHERE CM_CHANNEL_OCH.NE_ID=neId AND OCH_TYPE = 'L' AND (OCH_ID=entityId1 OR OCH_ID=entityId2);
        FETCH v_ref_cursor INTO entityId, ochAid, side;
        IF v_ref_cursor%NOTFOUND THEN
           CLOSE v_ref_cursor;
           OPEN v_ref_cursor FOR SELECT OCH_AID, OCH_DWDMSIDE FROM CM_CRS, CM_CHANNEL_OCH
              WHERE CM_CRS.NE_ID=neId AND CM_CHANNEL_OCH.NE_ID=neId AND (CRS_FROM_ID=entityId OR CRS_TO_ID=entityId) AND OCH_AID=CRS_PROTECTION;
           FETCH v_ref_cursor INTO ochAid, side;
        END IF;
        CLOSE v_ref_cursor;

        channelNo := SUBSTR(ochAid,INSTR(ochAid,'-',4,5)+1,LENGTH(ochAid));
        OPEN v_ref_cursor FOR SELECT CONN_TO_ID FROM CM_FIBR_CONN, CM_CARD
           WHERE CM_FIBR_CONN.NE_ID=neId AND CARD_ID=CONN_TO_ID AND CARD_AID_TYPE = 'OPSM' AND CONN_FROMPORT=channelNo AND CONN_DWDMSIDE=side;
        FETCH v_ref_cursor INTO eqptId;
        IF v_ref_cursor%FOUND THEN
           --circuit_util.print_line('OPSM DPRING found for '||entityId||'.');
           getOPSMDPFFP(neId, eqptId, channelNo, side);
        END IF;
        CLOSE v_ref_cursor;

        IF eqptId=0 THEN
            OPEN v_ref_cursor FOR SELECT fiber1.CONN_TO_ID, CARD_FIBRECHANNEL, CARD_FIBRECHANNEL FROM CM_FIBR_CONN fiber1, CM_FIBR_CONN fiber2, CM_CARD
                WHERE fiber1.NE_ID=neId AND CARD_ID=fiber1.CONN_TO_ID AND CARD_AID LIKE 'OTNM%' AND fiber1.CONN_FROMPORT=channelNo AND fiber1.CONN_DWDMSIDE=side AND length (CARD_DWDMSIDE) > 1 AND
                  fiber2.NE_ID=neId AND fiber2.CONN_TO_ID = fiber1.CONN_TO_ID AND fiber2.CONN_FROMPORT = channelNo
            UNION   -- For Nano
            SELECT fiber1.CONN_TO_ID, fiber1.CONN_FROMPORT, fiber2.CONN_FROMPORT FROM CM_FIBR_CONN fiber1, CM_FIBR_CONN fiber2, CM_CARD
                WHERE fiber1.NE_ID=neId AND CARD_ID=fiber1.CONN_TO_ID AND CARD_AID LIKE 'OTNM%' AND fiber1.CONN_DWDMSIDE=side AND length (CARD_DWDMSIDE) > 1 AND
                  fiber2.NE_ID=neId AND fiber2.CONN_TO_ID = fiber1.CONN_TO_ID AND CARD_CHAN = channelNo AND (CARD_FROMPORT = fiber1.CONN_FROMPORT OR CARD_FROMPORT = fiber2.CONN_FROMPORT)
                  AND fiber1.CONN_TOPORT != fiber2.CONN_TOPORT;
            FETCH v_ref_cursor INTO eqptId, channelNoFrom, channelNoTo;
            IF v_ref_cursor%FOUND THEN
                getOPSMDPFFP(neId, eqptId, channelNoFrom, side);
            END IF;
            CLOSE v_ref_cursor;

            OPEN v_ref_cursor FOR SELECT CONN_TOPORT FROM CM_FIBR_CONN
              WHERE CM_FIBR_CONN.NE_ID=neId AND CONN_TO_ID=eqptId AND CONN_FROMPORT=channelNoFrom AND CONN_DWDMSIDE=side;
          -- find the other route starting line OCH
            FETCH v_ref_cursor INTO toPort;

            IF v_ref_cursor%FOUND THEN
              IF toPort=1 THEN
                  toPort:=2;
               ELSIF toPort=2 THEN
                  toPort:=1;
              END IF;
          END IF;
          CLOSE v_ref_cursor;
        ELSE
            channelNoTo := channelNo;
             -- find the other route starting line OCH
            OPEN v_ref_cursor FOR SELECT CONN_TOPORT FROM CM_FIBR_CONN
                WHERE CM_FIBR_CONN.NE_ID=neId AND CONN_TO_ID=eqptId AND CONN_FROMPORT=channelNo AND CONN_DWDMSIDE=side;
            FETCH v_ref_cursor INTO toPort;

            IF v_ref_cursor%FOUND THEN
                SELECT decode(mod(toPort,3), 2, toPort+1, toPort-1) INTO toPort FROM dual;
                CLOSE v_ref_cursor;
            END IF;
        END IF;

        OPEN v_ref_cursor FOR SELECT CONN_DWDMSIDE FROM CM_FIBR_CONN
            WHERE CM_FIBR_CONN.NE_ID=neId AND CONN_TO_ID=eqptId AND CONN_FROMPORT=channelNoTo AND CONN_TOPORT=toPort;
        FETCH v_ref_cursor INTO Otherside;
        CLOSE v_ref_cursor;

        OPEN v_ref_cursor FOR SELECT OCH_ID FROM CM_CHANNEL_OCH
            WHERE CM_CHANNEL_OCH.NE_ID=neId AND OCH_TYPE = 'L' AND OCH_CHANNUM=channelNo AND OCH_DWDMSIDE=otherSide;
        FETCH v_ref_cursor INTO otherRouteOchId; -- get the line OCH

        circuit_util.print_line('toPort: '||toPort||' channelNo:'||channelNo||' Otherside:'||Otherside|| ' otherRouteOchId:'||otherRouteOchId);
       circuit_util.print_end('getOPSMDPProtectionEquipmentId');

        RETURN eqptId;
    END getOPSMDPProtectionEquipmentId;

    FUNCTION getOPSM1Plus1ProtectionEqptId(
        neId IN NUMBER, ochFrom IN NUMBER, ochTo IN NUMBER,
        otherRouteOchId OUT NUMBER
    ) RETURN NUMBER AS
        v_ref_cursor          EMS_REF_CURSOR;
        trnFacId       NUMBER;
        fromFacId      NUMBER;
        toFacId        NUMBER;
        opsmFacId      NUMBER;
        facIdw         NUMBER;
        facIdp         NUMBER;
        eqptId         NUMBER;
        facId          NUMBER;
        intfId         NUMBER;
        tempFacId      NUMBER;
        facAid         VARCHAR2(20);
    BEGIN circuit_util.print_start('getOPSM1Plus1ProtectionEqptId');
        eqptId:=0;

        OPEN v_ref_cursor FOR SELECT CRS_FROM_ID, CRS_TO_ID, FAC_ID FROM CM_FACILITY fac, CM_CRS crs, CM_CHANNEL_OCH
           WHERE fac.NE_ID=neId AND crs.NE_ID=neId AND FAC_PARENT_ID=OCH_PARENT_ID AND (OCH_TYPE = 'P' OR OCH_TYPE = 'CP' OR OCH_TYPE = '1') AND (OCH_ID=ochFrom OR OCH_ID=ochTo) AND (CRS_FROM_ID=FAC_ID OR CRS_TO_ID=FAC_ID);
        FETCH v_ref_cursor INTO fromFacId, toFacId, trnFacId;
        IF v_ref_cursor%FOUND THEN

            addConnectionToList(neId, fromFacId, toFacId); -- TRN/OPSM port facility CRS
            IF fromFacId=trnFacId THEN
                opsmFacId:=toFacId;
            ELSE
                opsmFacId:=fromFacId;
            END IF;

            CLOSE v_ref_cursor;
            OPEN v_ref_cursor FOR SELECT INTF_ID, INTF_PARENT_ID, facFrom.FAC_ID, facTo.FAC_ID, INTF_PROTECTEDAID FROM CM_INTERFACE, CM_FACILITY fac, CM_FACILITY facFrom, CM_FACILITY facTo
                WHERE fac.FAC_ID=opsmFacId AND INTF_ID=fac.FAC_PARENT_ID AND facFrom.NE_ID=neId AND facTo.NE_ID=neId AND facFrom.FAC_AID=INTF_PROTECTEDAID AND facTo.FAC_AID=INTF_PROTECTINGAID;
            FETCH v_ref_cursor INTO intfId, eqptId, facIdw, facIdp, facAid;

            IF v_ref_cursor%FOUND THEN
                addFFPtoList(neId,facIdw, facIdp);
                -- add GOPT-x-y to facilities
                CLOSE v_ref_cursor;
                OPEN v_ref_cursor FOR SELECT FAC_ID FROM CM_FACILITY WHERE NE_ID=neId AND FAC_PARENT_ID=intfId AND FAC_AID LIKE 'GOPT'||SUBSTR(facAid,7,INSTR(facAid,'-',2))||'%';
                FETCH v_ref_cursor INTO facId;
                IF v_ref_cursor%NOTFOUND THEN
                    circuit_util.print_line('No GOPT-x-y found for '||facAid||','||intfId||'.');
                ELSE
                    addFacilityToList(neId,facId);
                END IF;
            END IF;
        END IF;
        CLOSE v_ref_cursor;

        -- find the other route starting line OCH
        IF facIdw=opsmFacId THEN
           tempFacId:=facIdp;
        ELSE
           tempFacId:=facIdw;
        END IF;

        --circuit_util.print_line('OPSM 1+1: facility Id='||opsmFacId||' other facility Id='||tempFacId);

        OPEN v_ref_cursor FOR SELECT CRS_FROM_ID, CRS_TO_ID FROM CM_FACILITY fac, CM_CRS crs
           WHERE fac.NE_ID=neId AND crs.NE_ID=neId AND (CRS_FROM_ID=tempFacId OR CRS_TO_ID=tempFacId);
        FETCH v_ref_cursor INTO fromFacId, toFacId;
        IF v_ref_cursor%FOUND THEN -- get the TRN port facility
            IF fromFacId=tempFacId THEN
                tempFacId:=toFacId;
            ELSE
                tempFacId:=fromFacId;
            END IF;
            CLOSE v_ref_cursor;

            OPEN v_ref_cursor FOR SELECT OCH_ID FROM CM_FACILITY fac, CM_CHANNEL_OCH och
                WHERE fac.NE_ID=neId AND och.NE_ID=neId AND fac.FAC_ID=tempFacId AND och.OCH_PARENT_ID=fac.FAC_PARENT_ID AND (och.OCH_TYPE = 'P' OR och.OCH_TYPE = 'CP' OR och.OCH_TYPE = '1');
            FETCH v_ref_cursor INTO tempFacId; -- get the TRN OCH facility
            CLOSE v_ref_cursor;

            OPEN v_ref_cursor FOR SELECT crs.CRS_FROM_ID, crs.CRS_TO_ID FROM CM_CRS crs
              WHERE crs.NE_ID=neId AND (crs.CRS_FROM_ID=tempFacId OR crs.CRS_TO_ID=tempFacId);
            FETCH v_ref_cursor INTO fromFacId, toFacId; -- get the TRN add/drop CRS OCH-L facility
            IF v_ref_cursor%FOUND THEN -- get the TRN CRS OCH-L facility
                IF fromFacId=tempFacId THEN
                    otherRouteOchId:=toFacId;
                ELSE
                    otherRouteOchId:=fromFacId;
                END IF;
            END IF;
        END IF;
        CLOSE v_ref_cursor;
        RETURN eqptId;
       circuit_util.print_end('getOPSM1Plus1ProtectionEqptId');
    END getOPSM1Plus1ProtectionEqptId;
    FUNCTION getSMTMFFP(neId IN NUMBER, cardId IN NUMBER) RETURN BOOLEAN IS
        v_ref_cursor              EMS_REF_CURSOR;
        protScheme         VARCHAR2(10);
        workOrProt         VARCHAR2(1);
        otherCardId        NUMBER;
        working_card_id      NUMBER;
        protecting_card_id   NUMBER;
        workingFacId       NUMBER;
        protectingFacId    NUMBER;
        retVal             BOOLEAN DEFAULT FALSE;
    BEGIN circuit_util.print_start('getSMTMFFP');
        OPEN v_ref_cursor FOR SELECT card1.CARD_ID, prot.PROT_SCHEME, prot.WORK_OR_PROT FROM SMTM_PROTECTION_CM_VW prot, CM_CARD card1, CM_CARD card2
           WHERE card1.NE_ID=neId AND prot.NE_ID=neId AND prot.CARD_ID=cardId AND card2.CARD_ID=cardId /*AND card1.CARD_CHAN=card2.CARD_CHAN*/ AND card1.CARD_AID=prot.OTHER_CARD_AID AND (prot.PROT_SCHEME='UPSR' OR prot.PROT_SCHEME='SNCPRING' OR prot.PROT_SCHEME='DPRING');
        FETCH v_ref_cursor INTO otherCardId, protScheme, workOrProt;
        IF v_ref_cursor%FOUND THEN
           retVal:=TRUE;
           CLOSE v_ref_cursor;

            IF workOrProt='W' THEN
                working_card_id:=cardId;
                protecting_card_id:=otherCardId;
            ELSE
                protecting_card_id:=cardId;
                working_card_id:=otherCardId;
            END IF;

            IF protScheme='UPSR' OR protScheme='SNCPRING' THEN
                OPEN v_ref_cursor FOR SELECT a.FAC_ID, b.FAC_ID FROM CM_FACILITY a, CM_FACILITY b, CM_CARD ac, CM_CARD bc
                    WHERE ac.CARD_ID=working_card_id AND bc.CARD_ID=protecting_card_id AND a.FAC_PARENT_ID=ac.CARD_ID AND b.FAC_PARENT_ID=bc.CARD_ID
                      AND ( (ac.card_aid_type LIKE 'SMTM%' OR ac.card_aid_type LIKE 'SSM_') AND a.fac_port_or_line='Line')
                      AND ( (bc.card_aid_type LIKE 'SMTM%' OR bc.card_aid_type LIKE 'SSM_') AND b.fac_port_or_line='Line');
                FETCH v_ref_cursor INTO workingFacId, protectingFacId;
            ELSIF protScheme='DPRING' THEN
                OPEN v_ref_cursor FOR SELECT a.OCH_ID, b.OCH_ID FROM CM_CHANNEL_OCH a, CM_CHANNEL_OCH b, CM_CARD ac, CM_CARD bc
                    WHERE ac.CARD_ID=working_card_id AND bc.CARD_ID=protecting_card_id AND a.OCH_PARENT_ID=ac.CARD_ID AND b.OCH_PARENT_ID=bc.CARD_ID AND (a.OCH_TYPE = 'P' OR a.OCH_TYPE = 'CP' OR a.OCH_TYPE = '1') AND (b.OCH_TYPE = 'P' OR b.OCH_TYPE = 'CP' OR b.OCH_TYPE = '1');
                FETCH v_ref_cursor INTO workingFacId, protectingFacId;
            ELSE
                circuit_util.print_line('SMTM/SSM not involved in a protection circuit '||cardId||'.');
            END IF;

            IF v_ref_cursor%FOUND THEN
                addFFPtoList(neId,workingFacId, protectingFacId);
            END IF;
        END IF;
        CLOSE v_ref_cursor;
        RETURN retVal;
    circuit_util.print_end('getSMTMFFP');
    END getSMTMFFP;

    FUNCTION getSTSYcableFFP(
        p_ne_id IN NUMBER, p_fac_id IN NUMBER
    ) RETURN NUMBER AS
          v_ref_cursor         EMS_REF_CURSOR;
          v_card_aid_type       VARCHAR2(10);
          v_oppside_fac_id      NUMBER DEFAULT 0;
          v_w_fac_id            NUMBER DEFAULT 0;
          v_p_fac_id            NUMBER DEFAULT 0;
    BEGIN circuit_util.print_start('getSTSYcableFFP');
        OPEN v_ref_cursor FOR SELECT c.card_aid_type FROM CM_FACILITY i, CM_CARD c
           WHERE c.NE_ID=p_ne_id AND i.fac_aid_shelf = c.card_aid_shelf AND i.fac_aid_slot = c.card_aid_slot AND i.fac_id = p_fac_id;
        FETCH v_ref_cursor INTO v_card_aid_type;
        CLOSE v_ref_cursor;
        IF v_card_aid_type = 'OTNMD' THEN
            OPEN v_ref_cursor FOR SELECT i.FAC_WORKINGID, i.FAC_PROTECTIONID, CASE WHEN i.fac_id = i.FAC_WORKINGID THEN i.FAC_PROTECTIONID WHEN i.fac_id = i.FAC_PROTECTIONID THEN i.FAC_WORKINGID END FROM CM_FACILITY i
                WHERE i.NE_ID=p_ne_id AND i.FAC_ID=p_fac_id AND i.FAC_SCHEME = 'YCABLE';
            FETCH v_ref_cursor INTO v_w_fac_id, v_p_fac_id, v_oppside_fac_id;
            CLOSE v_ref_cursor;
        ELSIF v_card_aid_type = 'FGTMM' THEN
            OPEN v_ref_cursor FOR SELECT i.FAC_WORKINGID, i.FAC_PROTECTIONID, CASE WHEN i.fac_id = i.FAC_WORKINGID THEN odup.fac_id WHEN i.fac_id = i.FAC_PROTECTIONID THEN oduw.fac_id END
                FROM CM_FACILITY o, CM_FACILITY i, CM_FACILITY oduw, CM_FACILITY odup
                WHERE o.FAC_ID=p_fac_id AND o.fac_parent_id = i.fac_id AND i.fac_scheme = 'YCABLE' AND i.fac_workingid = oduw.fac_parent_id AND i.fac_protectionid = odup.fac_parent_id;
            FETCH v_ref_cursor INTO v_w_fac_id, v_p_fac_id, v_oppside_fac_id;
            CLOSE v_ref_cursor;
        ELSIF v_card_aid_type LIKE 'OSM__' OR v_card_aid_type = 'OMMX' THEN
            OPEN v_ref_cursor FOR SELECT i.FAC_WORKINGID, i.FAC_PROTECTIONID, CASE WHEN i.fac_id = i.FAC_WORKINGID THEN odup.fac_id WHEN i.fac_id = i.FAC_PROTECTIONID THEN oduw.fac_id END
                FROM CM_FACILITY o, CM_FACILITY i, CM_FACILITY facw, CM_FACILITY facp, CM_FACILITY oduw, CM_FACILITY odup
                WHERE o.FAC_ID=p_fac_id AND i.ne_id = p_ne_id AND i.fac_id<>p_fac_id AND circuit_util.trimAidType(i.fac_aid) = circuit_util.trimAidType(o.fac_aid)
                AND i.fac_scheme = 'YCABLE'AND facw.fac_id = i.FAC_WORKINGID AND facp.fac_id = i.FAC_PROTECTIONID
                AND oduw.ne_id = p_ne_id AND oduw.fac_id<>facw.fac_id AND oduw.fac_aid_type LIKE 'ODU%' AND circuit_util.trimAidType(facw.fac_aid) = circuit_util.trimAidType(oduw.fac_aid)
                AND odup.ne_id = p_ne_id AND odup.fac_id<>facp.fac_id AND odup.fac_aid_type LIKE 'ODU%' AND circuit_util.trimAidType(facp.fac_aid) = circuit_util.trimAidType(odup.fac_aid);
            FETCH v_ref_cursor INTO v_w_fac_id, v_p_fac_id, v_oppside_fac_id;
            CLOSE v_ref_cursor;
        END IF;

        IF v_w_fac_id > 0 AND v_p_fac_id > 0 THEN
            addFFPtoList(p_ne_id,v_w_fac_id, v_p_fac_id);
        END IF;
        RETURN v_oppside_fac_id;
    circuit_util.print_end('getSTSYcableFFP');
    END getSTSYcableFFP;

    PROCEDURE getSMTMPortFFP(
        p_ne_id IN NUMBER, p_fac_id IN NUMBER
    ) AS
        v_ref_cursor   EMS_REF_CURSOR;
        v_w_fac_id      NUMBER;
        v_p_fac_id      NUMBER;
    BEGIN circuit_util.print_start('getSMTMPortFFP');
        OPEN v_ref_cursor FOR SELECT a.FAC_ID, b.FAC_ID FROM CM_FACILITY a, CM_FACILITY b, CM_FACILITY i
             WHERE a.NE_ID=p_ne_id AND b.NE_ID=p_ne_id AND i.NE_ID=p_ne_id AND i.FAC_ID=p_fac_id AND a.FAC_ID=i.FAC_WORKINGID AND b.FAC_ID=i.FAC_PROTECTIONID AND a.FAC_PORT_OR_LINE='Port' AND b.FAC_PORT_OR_LINE='Port';
        FETCH v_ref_cursor INTO v_w_fac_id, v_p_fac_id;
        IF v_ref_cursor%FOUND THEN
            addFFPtoList(p_ne_id,v_w_fac_id, v_p_fac_id);
            CLOSE v_ref_cursor;
        END IF;
    circuit_util.print_end('getSMTMPortFFP');
    END getSMTMPortFFP;

    FUNCTION getValidSlotPair(fromEqptSlot IN NUMBER, stype IN VARCHAR, shelfSubType VARCHAR2) RETURN NUMBER IS
        toEqptSlot        NUMBER;
    BEGIN circuit_util.print_start('getValidSlotPair');
        toEqptSlot:=0;
        IF shelfSubType = 'HCSS' THEN
            IF fromEqptSlot > 10 THEN
                toEqptSlot := fromEqptSlot - 10;
            ELSE
                toEqptSlot := fromEqptSlot + 10;
            END IF;
        ELSE
            IF stype LIKE '%_N' THEN -- case NANO
                IF fromEqptSlot > 3 THEN
                    toEqptSlot := fromEqptSlot - 3;
                ELSE
                    toEqptSlot := fromEqptSlot + 3;
                END IF;
            ELSE -- default
               toEqptSlot := 17 - fromEqptSlot;
            END IF;
        END IF;
       circuit_util.print_end('getvalidSlotPair');
        RETURN toEqptSlot;
    END getvalidSlotPair;

    FUNCTION getSMTMPPair(neId IN NUMBER, eqptId IN NUMBER, stype IN VARCHAR) RETURN VARCHAR IS
        v_ref_cursor      EMS_REF_CURSOR;
        eqptSlot          NUMBER;
        eqptShelf         NUMBER;
        otherEqptId       NUMBER;
        otherEqptSlot     NUMBER;
        channel           NUMBER;
        shelf_subtype         VARCHAR2(10);
    BEGIN circuit_util.print_start('getSMTMPPair');
        OPEN v_ref_cursor FOR SELECT CARD_AID_SHELF, CARD_AID_SLOT, CARD_CHAN, sh.shelf_subtype FROM CM_CARD card, cm_shelf sh
           WHERE (CARD_AID LIKE 'SMTMP%' OR CARD_AID LIKE 'TGIMP%') AND shelf_id=card.card_parent_id AND CARD_ID=eqptId;
        FETCH v_ref_cursor INTO eqptShelf, eqptSlot, channel, shelf_subtype;

        otherEqptSlot:=getValidSlotPair(eqptSlot, stype, shelf_subtype);

        OPEN v_ref_cursor FOR SELECT CARD_ID FROM CM_CARD
           WHERE NE_ID=neId AND (CARD_AID_TYPE = 'SMTMP' OR CARD_AID_TYPE = 'TGIMP') AND CARD_AID_SHELF=eqptShelf AND CARD_AID_SLOT=otherEqptSlot AND CARD_CHAN=channel;
        FETCH v_ref_cursor INTO otherEqptId;
        CLOSE v_ref_cursor;

        circuit_util.print_end('getSMTMPPair');
        RETURN otherEqptId;
    END getSMTMPPair;

    FUNCTION getSMTMProtectionEquipmentId(
        neId IN NUMBER, fromEqptId IN VARCHAR2, toEqptId IN VARCHAR2,
        ochpId IN NUMBER
    ) RETURN NUMBER AS
        v_ref_cursor       EMS_REF_CURSOR;
        eqptId      NUMBER;
        eqptSlot    NUMBER;
        otherEqptId NUMBER;
        eqptAid     VARCHAR2(70);
        stype       VARCHAR2(15);
        smallestSlot NUMBER;
    BEGIN circuit_util.print_start('getSMTMProtectionEquipmentId');
        eqptId:=0;
        smallestSlot:=8; -- default

        OPEN v_ref_cursor FOR SELECT CARD_ID, CARD_AID, CARD_AID_SLOT FROM CM_CARD
           WHERE NE_ID=neId AND (CARD_AID LIKE 'SMTM%' OR CARD_AID LIKE 'SSM%' OR CARD_AID_TYPE = 'TGIMP' OR CARD_AID_TYPE LIKE 'HDTG%') AND CARD_ID=fromEqptId;
        FETCH v_ref_cursor INTO eqptId, eqptAid, eqptSlot;
        IF v_ref_cursor%NOTFOUND THEN
           CLOSE v_ref_cursor;
           OPEN v_ref_cursor FOR SELECT CARD_ID, CARD_AID, CARD_AID_SLOT FROM CM_CARD
              WHERE NE_ID=neId AND (CARD_AID LIKE 'SMTM%' OR CARD_AID LIKE 'SSM%' OR CARD_AID_TYPE = 'TGIMP' OR CARD_AID_TYPE LIKE 'HDTG%') AND CARD_ID=toEqptId;
           FETCH v_ref_cursor INTO eqptId, eqptAid, eqptSlot;
        END IF;
        CLOSE v_ref_cursor;

        IF eqptAid LIKE 'SMTMP%' OR eqptAid LIKE 'TGIMP%' THEN
           OPEN v_ref_cursor FOR SELECT NE_STYPE FROM EMS_NE WHERE NE_ID=neId;
           FETCH v_ref_cursor INTO stype;

           otherEqptId := getSMTMPPair(neId, eqptId, stype);
           IF otherEqptId<>0 THEN
              IF stype LIKE '%_N' THEN
                 smallestSlot:=3;
              END IF;

              IF eqptSlot<=smallestSlot THEN -- always use the smallest slot AID as the FROM (for cooking FFP)
                 addFFPtoList(neId, eqptId, otherEqptId);
              ELSE
                 addFFPtoList(neId, otherEqptId, eqptId);
              END IF;
           END IF;
        ELSIF eqptAid LIKE 'HDTG%' THEN
           circuit_util.print_line('HDTG circuit found.');
           OPEN v_ref_cursor FOR SELECT OCH_SCHEME FROM CM_CHANNEL_OCH WHERE OCH_ID=ochpId;
           FETCH v_ref_cursor INTO stype;
              IF stype <> 'DPRING' THEN
                 eqptId:=0;
              END IF;
           CLOSE v_ref_cursor;
        ELSE
           IF getSMTMFFP(neId, eqptId)=FALSE THEN
              eqptId:=0;
           END IF;
        END IF;
       circuit_util.print_end('getSMTMProtectionEquipmentId');
        RETURN eqptId;
    END getSMTMProtectionEquipmentId;

    FUNCTION getYCABLEProtectionEquipmentId(neId IN NUMBER, fromEqptId IN VARCHAR2, toEqptId IN VARCHAR, ochpId IN NUMBER ) RETURN NUMBER IS
        v_ref_cursor       EMS_REF_CURSOR;
        eqptId      NUMBER;
        retVal      NUMBER;
        eqptAidType VARCHAR2(70);
    BEGIN circuit_util.print_start('getYCABLEProtectionEquipmentId');
        eqptId:=0;
        retVal:=0;

        OPEN v_ref_cursor FOR SELECT CARD_ID, CARD_AID_TYPE FROM CM_CARD
           WHERE NE_ID=neId AND CARD_AID_TYPE IN ('OTNMX','FGTM','TGTME','HDTG','HDTG2','HGTM','HGTMS','OSM20','OSM2S','OSM1S','OSM2C','OMMX') AND CARD_ID=fromEqptId;
        FETCH v_ref_cursor INTO eqptId, eqptAidType;
        IF v_ref_cursor%NOTFOUND THEN
           CLOSE v_ref_cursor;
           OPEN v_ref_cursor FOR SELECT CARD_ID, CARD_AID_TYPE FROM CM_CARD
              WHERE NE_ID=neId AND CARD_AID_TYPE IN ('OTNMX','FGTM','TGTME','HDTG','HDTG2','HGTM','HGTMS','OSM20','OSM2S','OSM1S','OSM2C','OMMX') AND CARD_ID=toEqptId;
           FETCH v_ref_cursor INTO eqptId, eqptAidType;
        END IF;
        CLOSE v_ref_cursor;

        IF eqptId > 0 THEN
          IF eqptAidType LIKE 'HDTG%' THEN
          --filter the facility type or just use scheme and leave it to cm
             OPEN v_ref_cursor FOR SELECT C2.CARD_ID FROM CM_FACILITY F1, CM_FACILITY F2, CM_CARD C1,CM_CARD C2, CM_CHANNEL_OCH O1
              WHERE C1.NE_ID = neId AND C1.CARD_ID = eqptId AND F1.FAC_PARENT_ID = C1.CARD_ID
              AND O1.NE_ID = neId AND O1.OCH_ID = ochpId AND O1.OCH_PARENT_ID = C1.CARD_ID AND F1.FAC_AID_PORT = o1.OCH_AID_PORT +1
              AND (F1.FAC_PROTECTIONID = F2.FAC_ID OR F2.FAC_PROTECTIONID = F1.FAC_ID)
              AND F2.FAC_PARENT_ID = C2.CARD_ID AND F1.FAC_ID <> F2.FAC_ID AND F1.FAC_SCHEME = 'YCABLE';
             FETCH v_ref_cursor INTO retVal;
             CLOSE v_ref_cursor;
           ELSE --may be exist other cardtype need to be partically handled
             OPEN v_ref_cursor FOR SELECT C2.CARD_ID FROM CM_FACILITY F1, CM_FACILITY F2, CM_CARD C1,CM_CARD C2
              WHERE c1.NE_ID = neId AND C1.CARD_ID = eqptId AND F1.FAC_PARENT_ID = C1.CARD_ID
              AND (F1.FAC_PROTECTIONID = F2.FAC_ID OR F2.FAC_PROTECTIONID = F1.FAC_ID)
              AND F2.FAC_PARENT_ID = C2.CARD_ID AND F1.FAC_ID <> F2.FAC_ID AND F1.FAC_SCHEME = 'YCABLE';
             FETCH v_ref_cursor INTO retVal;
             CLOSE v_ref_cursor;
           END IF;
        END IF;

        --add ffp later in handling ochp
        circuit_util.print_end('getYCABLEProtectionEquipmentId');
        RETURN retVal;
    END getYCABLEProtectionEquipmentId;
    PROCEDURE print_discover_result(p_discover_name VARCHAR2)
    AS
    BEGIN
        IF circuit_util.g_log_enable THEN
            circuit_util.print_line('******* '||p_discover_name||' *******');
            IF g_link_list IS NOT NULL THEN
                FOR i IN 1..g_link_list.COUNT LOOP
                    circuit_util.print_line('links('||i||')='||g_link_list(i));
                END LOOP;
            END IF;
            IF g_conn_List IS NOT NULL THEN
                FOR i IN 1..g_conn_List.COUNT LOOP
                    circuit_util.print_line('connections('||i||')='||g_conn_List(i));
                END LOOP;
            END IF;
            IF g_sts_conn_list IS NOT NULL THEN
                FOR i IN 1..g_sts_conn_list.COUNT LOOP
                    circuit_util.print_line('STSConnection('||i||')='||g_sts_conn_list(i));
                END LOOP;
            END IF;
            IF g_exp_link_list IS NOT NULL THEN
                FOR i IN 1..g_exp_link_list.COUNT LOOP
                    circuit_util.print_line('express links('||i||')='||g_exp_link_list(i));
                END LOOP;
            END IF;
            IF g_fac_List IS NOT NULL THEN
                FOR i IN 1..g_fac_List.COUNT LOOP
                    circuit_util.print_line('Facilities('||i||')='||g_fac_List(i));
                END LOOP;
            END IF;
            IF g_sts_Fac_List IS NOT NULL THEN
                FOR i IN 1..g_sts_Fac_List.COUNT LOOP
                    circuit_util.print_line('StsFaclities('||i||')='||g_sts_Fac_List(i));
                END LOOP;
            END IF;
            IF g_eqpt_List IS NOT NULL THEN
                FOR i IN 1..g_eqpt_List.COUNT LOOP
                    circuit_util.print_line('Equipments('||i||')='||g_eqpt_List(i));
                END LOOP;
            END IF;
            IF g_ffp_List IS NOT NULL THEN
                FOR i IN 1..g_ffp_List.COUNT LOOP
                    circuit_util.print_line('FFPs('||i||')='||g_ffp_List(i));
                END LOOP;
            END IF;
            circuit_util.print_line('CircuitType='||g_circuit_type);
            circuit_util.print_line('error='||g_error);
            circuit_util.print_line('bounds='||to_char(nvl(g_min_x,0))||g_delimiter||to_char(nvl(g_max_x,0))||g_delimiter||
                 to_char(nvl(g_min_y,0))||g_delimiter||to_char(nvl(g_max_y,0)));
        END IF;
    END print_discover_result;
    PROCEDURE updateCircuitBounds(neId IN NUMBER) AS
        v_ref_cursor          EMS_REF_CURSOR;
        x_coord        NUMBER(18,15);
        y_coord        NUMBER(18,15);
        isCoordFound   CHAR;
    BEGIN circuit_util.print_start('updateCircuitBounds');
        isCoordFound := 'N';
        OPEN v_ref_cursor FOR SELECT NE_X_COORD, NE_Y_COORD FROM EMS_NE_COORD, EMS_NE WHERE UPPER(NE_TID_CLLI)=UPPER(NE_TID) AND NE_ID=neId;
        FETCH v_ref_cursor INTO x_coord, y_coord;
        IF v_ref_cursor%NOTFOUND THEN
           OPEN v_ref_cursor FOR SELECT NE_X_COORD, NE_Y_COORD FROM EMS_NE_COORD, EMS_NE WHERE UPPER(NE_TID_CLLI)=UPPER(NE_CLLI) AND NE_ID=neId;
           FETCH v_ref_cursor INTO x_coord, y_coord;
           IF v_ref_cursor%NOTFOUND THEN
              circuit_util.print_line('No Co-ordinates found for '||neId||'.');
           ELSE
              isCoordFound := 'Y';
           END IF;
        ELSE
           isCoordFound := 'Y';
        END IF;
        CLOSE v_ref_cursor;
        IF isCoordFound = 'Y' THEN
           IF nvl(x_coord, 999) < g_min_x THEN
              g_min_x := x_coord;
           END IF;
           IF nvl(x_coord, -999) > g_max_x THEN
              g_max_x := x_coord;
           END IF;

           IF nvl(y_coord, 999) < g_min_y THEN
              g_min_y := y_coord;
           END IF;

           IF nvl(y_coord, -999) > g_max_y THEN
              g_max_y := y_coord;
           END IF;
         END IF;
    circuit_util.print_end('updateCircuitBounds'); END;
    FUNCTION findNonTrmCrsOeo(
        p_ne_id NUMBER,               p_ne_tid VARCHAR2,                  p_ne_type VARCHAR2,
        p_ne_stype VARCHAR2,          p_shelf_stype VARCHAR2,             p_crs_ccpath VARCHAR2,
        p_crs_cctype VARCHAR2,        p_crs_ochp_card_aid_type VARCHAR2,  p_ochp_aid_shelf NUMBER,
        p_ochp_aid_slot NUMBER,       p_ochp_aid_port NUMBER,             p_crs_ochp_id NUMBER,
        p_crs_ochl_id NUMBER,         p_crs_och1_dwdmside VARCHAR2,       circuitType VARCHAR2
    )RETURN NUMBER AS
        v_crs_ochl_id2 NUMBER;
    BEGIN
        IF p_shelf_stype = 'HCSS' THEN -- |sh1 - sh2| = 10
            IF p_crs_ochp_card_aid_type LIKE 'TGTM_' OR p_crs_ochp_card_aid_type LIKE 'MRTM_' OR p_crs_ochp_card_aid_type = 'FGTM' THEN
                FOR l_line1 IN (SELECT card1.card_id eqpt_id1, card1.card_aid eqpt_aid1, och1.och_id ochp_id1, och1.och_aid ochp_aid1, fac1.fac_id fac_id1, fac1.fac_aid fac_aid1, och1.och_aid_port och_port1,
                        card2.card_id eqpt_id2, card2.card_aid eqpt_aid2, och2.och_id ochp_id2, och2.och_aid ochp_aid2, fac2.fac_id fac_id2, fac2.fac_aid fac_aid2, och2.och_aid_port och_port2
                      FROM cm_channel_och och1, cm_channel_och och2, cm_facility fac1, cm_facility fac2, cm_card card1, cm_card card2
                      WHERE card1.card_id=och1.och_parent_id AND card2.card_id=och2.och_parent_id
                          AND abs(fac1.fac_aid_slot-fac2.fac_aid_slot)=10 AND fac1.fac_oeoregen='ENABLED' AND fac2.fac_oeoregen='ENABLED' AND fac1.fac_aid_shelf=och1.och_aid_shelf AND fac1.fac_aid_slot=och1.och_aid_slot
                          AND abs(och1.och_aid_slot-och2.och_aid_slot)=10  AND och1.och_aid_shelf=och2.och_aid_shelf AND och2.ne_id=och1.ne_id
                          AND fac1.fac_parent_id=och1.och_parent_id  AND fac1.ne_id=och1.ne_id AND fac2.ne_id=och1.ne_id AND och1.och_id=p_crs_ochp_id
                ) LOOP
                    v_crs_ochl_id2 := addNonTrmCrsResource(
                        p_ne_id,            p_ne_tid,             p_crs_cctype,
                        p_crs_ccpath,       p_crs_och1_dwdmside,  l_line1.eqpt_id1,
                        l_line1.eqpt_aid1,  l_line1.fac_id1,      l_line1.fac_aid1,
                        l_line1.ochp_id1,   l_line1.ochp_aid1,    p_crs_ochl_id,
                        l_line1.eqpt_id2,   l_line1.eqpt_aid2,    l_line1.fac_id2,
                        l_line1.fac_aid2,   l_line1.ochp_id2,     l_line1.ochp_aid2,
                        l_line1.och_port1,  l_line1.och_port2,    circuitType);
                END LOOP;
            ELSIF p_crs_ochp_card_aid_type = 'FGTMM' OR (p_crs_ochp_card_aid_type = 'HDTG' OR p_ochp_aid_port = 1) THEN
                FOR l_line1 IN (SELECT card1.card_id eqpt_id1, card1.card_aid eqpt_aid1, och1.och_id ochp_id1, och1.och_aid ochp_aid1, '' fac_id1, '' fac_aid1, och1.och_aid_port och_port1,
                        card2.card_id eqpt_id2, card2.card_aid eqpt_aid2, och2.och_id ochp_id2, och2.och_aid ochp_aid2, '' fac_id2, '' fac_aid2, och2.och_aid_port och_port2
                      FROM cm_channel_och och1, cm_channel_och och2, cm_card card1, cm_card card2
                      WHERE card1.card_id=och1.och_parent_id AND card2.card_id=och2.och_parent_id
                          AND abs(och1.och_aid_slot-och2.och_aid_slot)=10 AND och1.och_oeoregen='ENABLED' AND och2.och_oeoregen='ENABLED' AND och1.och_aid_shelf=och2.och_aid_shelf
                          AND och2.ne_id=och1.ne_id AND och1.och_id=p_crs_ochp_id
                ) LOOP
                    v_crs_ochl_id2 := addNonTrmCrsResource(
                        p_ne_id,            p_ne_tid,             p_crs_cctype,
                        p_crs_ccpath,       p_crs_och1_dwdmside,  l_line1.eqpt_id1,
                        l_line1.eqpt_aid1,  l_line1.fac_id1,      l_line1.fac_aid1,
                        l_line1.ochp_id1,   l_line1.ochp_aid1,    p_crs_ochl_id,
                        l_line1.eqpt_id2,   l_line1.eqpt_aid2,    l_line1.fac_id2,
                        l_line1.fac_aid2,   l_line1.ochp_id2,     l_line1.ochp_aid2,
                        l_line1.och_port1, l_line1.och_port2,     circuitType);
                END LOOP;
            END IF;
        ELSIF p_shelf_stype = 'USS' THEN
            IF instr(p_ne_stype, '_N') > 0 THEN --USS, NANO   -- |sh1 - sh2| = 3
                IF p_crs_ochp_card_aid_type LIKE 'TGTM_' OR p_crs_ochp_card_aid_type LIKE 'MRTM_' OR p_crs_ochp_card_aid_type = 'FGTM' THEN
                    FOR l_line1 IN (SELECT card1.card_id eqpt_id1, card1.card_aid eqpt_aid1, och1.och_id ochp_id1, och1.och_aid ochp_aid1, fac1.fac_id fac_id1, fac1.fac_aid fac_aid1, och1.och_aid_port och_port1,
                          card2.card_id eqpt_id2, card2.card_aid eqpt_aid2, och2.och_id ochp_id2, och2.och_aid ochp_aid2, fac2.fac_id fac_id2, fac2.fac_aid fac_aid2, och2.och_aid_port och_port2
                        FROM cm_channel_och och1, cm_channel_och och2, cm_facility fac1, cm_facility fac2, cm_card card1, cm_card card2
                        WHERE card1.card_id=och1.och_parent_id AND card2.card_id=och2.och_parent_id
                            AND abs(fac1.fac_aid_slot-fac2.fac_aid_slot)=3 AND fac1.fac_oeoregen='ENABLED' AND fac2.fac_oeoregen='ENABLED' AND fac1.fac_aid_shelf=och1.och_aid_shelf AND fac1.fac_aid_slot=och1.och_aid_slot
                            AND abs(och1.och_aid_slot-och2.och_aid_slot)=3  AND och1.och_aid_shelf=och2.och_aid_shelf AND och2.ne_id=och1.ne_id
                            AND fac1.fac_parent_id=och1.och_parent_id  AND fac1.ne_id=och1.ne_id AND fac2.ne_id=och1.ne_id AND och1.och_id=p_crs_ochp_id
                    ) LOOP
                        v_crs_ochl_id2 := addNonTrmCrsResource(
                            p_ne_id,            p_ne_tid,             p_crs_cctype,
                            p_crs_ccpath,       p_crs_och1_dwdmside,  l_line1.eqpt_id1,
                            l_line1.eqpt_aid1,  l_line1.fac_id1,      l_line1.fac_aid1,
                            l_line1.ochp_id1,   l_line1.ochp_aid1,    p_crs_ochl_id,
                            l_line1.eqpt_id2,   l_line1.eqpt_aid2,    l_line1.fac_id2,
                            l_line1.fac_aid2,   l_line1.ochp_id2,     l_line1.ochp_aid2,
                            l_line1.och_port1, l_line1.och_port2,     circuitType);
                    END LOOP;
                ELSIF p_crs_ochp_card_aid_type = 'FGTMM' OR (p_crs_ochp_card_aid_type = 'HDTG' OR p_ochp_aid_port = 1) THEN
                    FOR l_line1 IN (SELECT card1.card_id eqpt_id1, card1.card_aid eqpt_aid1, och1.och_id ochp_id1, och1.och_aid ochp_aid1, '' fac_id1, '' fac_aid1, och1.och_aid_port och_port1,
                          card2.card_id eqpt_id2, card2.card_aid eqpt_aid2, och2.och_id ochp_id2, och2.och_aid ochp_aid2, '' fac_id2, '' fac_aid2, och2.och_aid_port och_port2
                        FROM cm_channel_och och1, cm_channel_och och2, cm_card card1, cm_card card2
                        WHERE card1.card_id=och1.och_parent_id AND card2.card_id=och2.och_parent_id
                            AND abs(och1.och_aid_slot-och2.och_aid_slot)=3 AND och1.och_oeoregen='ENABLED' AND och2.och_oeoregen='ENABLED' AND och1.och_aid_shelf=och2.och_aid_shelf
                            AND och2.ne_id=och1.ne_id AND och1.och_id=p_crs_ochp_id
                    ) LOOP
                        v_crs_ochl_id2 := addNonTrmCrsResource(
                            p_ne_id,            p_ne_tid,             p_crs_cctype,
                            p_crs_ccpath,       p_crs_och1_dwdmside,  l_line1.eqpt_id1,
                            l_line1.eqpt_aid1,  l_line1.fac_id1,      l_line1.fac_aid1,
                            l_line1.ochp_id1,   l_line1.ochp_aid1,    p_crs_ochl_id,
                            l_line1.eqpt_id2,   l_line1.eqpt_aid2,    l_line1.fac_id2,
                            l_line1.fac_aid2,   l_line1.ochp_id2,     l_line1.ochp_aid2,
                            l_line1.och_port1, l_line1.och_port2,     circuitType);
                    END LOOP;
                END IF;
            ELSE  -- |sh1 + sh2| = 17
                IF p_crs_ochp_card_aid_type LIKE 'TGTM_' OR p_crs_ochp_card_aid_type LIKE 'MRTM_' OR p_crs_ochp_card_aid_type = 'FGTM' THEN
                    FOR l_line1 IN (SELECT card1.card_id eqpt_id1, card1.card_aid eqpt_aid1, och1.och_id ochp_id1, och1.och_aid ochp_aid1, fac1.fac_id fac_id1, fac1.fac_aid fac_aid1, och1.och_aid_port och_port1,
                          card2.card_id eqpt_id2, card2.card_aid eqpt_aid2, och2.och_id ochp_id2, och2.och_aid ochp_aid2, fac2.fac_id fac_id2, fac2.fac_aid fac_aid2, och2.och_aid_port och_port2
                        FROM cm_channel_och och1, cm_channel_och och2, cm_facility fac1, cm_facility fac2, cm_card card1, cm_card card2
                        WHERE card1.card_id=och1.och_parent_id AND card2.card_id=och2.och_parent_id
                            AND (fac1.fac_aid_slot+fac2.fac_aid_slot)=17 AND fac1.fac_oeoregen='ENABLED' AND fac2.fac_oeoregen='ENABLED' AND fac1.fac_aid_shelf=och1.och_aid_shelf AND fac1.fac_aid_slot=och1.och_aid_slot
                            AND  (och1.och_aid_slot+och2.och_aid_slot)=17  AND och1.och_aid_shelf=och2.och_aid_shelf AND och2.ne_id=och1.ne_id
                            AND fac1.fac_parent_id=och1.och_parent_id  AND fac1.ne_id=och1.ne_id AND fac2.ne_id=och1.ne_id AND och1.och_id=p_crs_ochp_id
                    ) LOOP
                        v_crs_ochl_id2 := addNonTrmCrsResource(
                            p_ne_id,            p_ne_tid,             p_crs_cctype,
                            p_crs_ccpath,       p_crs_och1_dwdmside,  l_line1.eqpt_id1,
                            l_line1.eqpt_aid1,  l_line1.fac_id1,      l_line1.fac_aid1,
                            l_line1.ochp_id1,   l_line1.ochp_aid1,    p_crs_ochl_id,
                            l_line1.eqpt_id2,   l_line1.eqpt_aid2,    l_line1.fac_id2,
                            l_line1.fac_aid2,   l_line1.ochp_id2,     l_line1.ochp_aid2,
                            l_line1.och_port1, l_line1.och_port2,     circuitType);
                    END LOOP;
                ELSIF p_crs_ochp_card_aid_type = 'FGTMM' OR (p_crs_ochp_card_aid_type = 'HDTG' OR p_ochp_aid_port = 1) THEN
                    FOR l_line1 IN (SELECT card1.card_id eqpt_id1, card1.card_aid eqpt_aid1, och1.och_id ochp_id1, och1.och_aid ochp_aid1, '' fac_id1, '' fac_aid1, och1.och_aid_port och_port1,
                          card2.card_id eqpt_id2, card2.card_aid eqpt_aid2, och2.och_id ochp_id2, och2.och_aid ochp_aid2, '' fac_id2, '' fac_aid2, och2.och_aid_port och_port2
                        FROM cm_channel_och och1, cm_channel_och och2, cm_card card1, cm_card card2
                        WHERE card1.card_id=och1.och_parent_id AND card2.card_id=och2.och_parent_id
                            AND (och1.och_aid_slot+och2.och_aid_slot)=17 AND och1.och_oeoregen='ENABLED' AND och2.och_oeoregen='ENABLED' AND och1.och_aid_shelf=och2.och_aid_shelf
                            AND och2.ne_id=och1.ne_id AND och1.och_id=p_crs_ochp_id
                    ) LOOP
                        v_crs_ochl_id2 := addNonTrmCrsResource(
                            p_ne_id,            p_ne_tid,             p_crs_cctype,
                            p_crs_ccpath,       p_crs_och1_dwdmside,  l_line1.eqpt_id1,
                            l_line1.eqpt_aid1,  l_line1.fac_id1,      l_line1.fac_aid1,
                            l_line1.ochp_id1,   l_line1.ochp_aid1,    p_crs_ochl_id,
                            l_line1.eqpt_id2,   l_line1.eqpt_aid2,    l_line1.fac_id2,
                            l_line1.fac_aid2,   l_line1.ochp_id2,     l_line1.ochp_aid2,
                            l_line1.och_port1, l_line1.och_port2,     circuitType);
                    END LOOP;
                END IF;
            END IF;
        END IF;

        IF (p_crs_ochp_card_aid_type = 'HDTG') THEN
            FOR l_line1 IN (select * from (
                 -- commented out in t71mr00197814, the external connection case need to be considered.
                /*SELECT card1.card_id eqpt_id1, card1.card_aid eqpt_aid1, och1.och_id ochp_id1, och1.och_aid ochp_aid1, '' fac_id1, '' fac_aid1, och1.och_aid_port och_port1,
                  card1.card_id eqpt_id2, card1.card_aid eqpt_aid2, och2.och_id ochp_id2, och2.och_aid ochp_aid2, '' fac_id2, '' fac_aid2, och2.och_aid_port och_port2, abs(och1.och_aid_port-och2.och_aid_port) port_diff
                  FROM cm_card card1, cm_crs crs, cm_channel_och och2, cm_channel_och och1
                  WHERE card1.card_id=och1.och_parent_id AND och1.och_parent_id=och2.och_parent_id AND (crs_from_id=och2.och_id OR crs_to_id=och2.och_id)
                    AND ( (abs(och1.och_aid_port-och2.och_aid_port)=1 AND och1.och_aid_port IN (1, 2) AND och2.och_aid_port  IN (1, 2) )
                      OR (abs(och1.och_aid_port-och2.och_aid_port) IN (1,2) AND och1.och_aid_port NOT IN (1, 2) AND och2.och_aid_port NOT IN (1, 2)))
                      AND och1.och_oeoregen='ENABLED' AND och2.och_oeoregen='ENABLED'  AND och1.och_id=p_crs_ochp_id
                      ORDER BY port_diff ASC */
                SELECT card1.card_id eqpt_id1, card1.card_aid eqpt_aid1, och1.och_id ochp_id1, och1.och_aid ochp_aid1, '' fac_id1, '' fac_aid1, och1.och_aid_port och_port1,
                  card1.card_id eqpt_id2, card1.card_aid eqpt_aid2, och2.och_id ochp_id2, och2.och_aid ochp_aid2, '' fac_id2, '' fac_aid2, och2.och_aid_port och_port2, abs(och1.och_aid_port-och2.och_aid_port) port_diff
                  FROM cm_card card1, cm_channel_och och2, cm_channel_och och1
                  WHERE card1.card_id=och1.och_parent_id AND och1.och_parent_id=och2.och_parent_id
                  AND ( och2.och_crossconnected='YES' or och2.och_extchan is not null )
                  AND ( (abs(och1.och_aid_port-och2.och_aid_port)=1 AND (och1.och_aid_port+och2.och_aid_port) IN (3,7,11,15,19) )
                  OR (abs(och1.och_aid_port-och2.och_aid_port)=2 AND (och1.och_aid_port+och2.och_aid_port) IN (8,16)) )
                  AND och1.och_oeoregen='ENABLED' AND och2.och_oeoregen='ENABLED'  AND och1.och_id=p_crs_ochp_id
                  ORDER BY port_diff ASC
                ) WHERE rownum=1
            ) LOOP
                v_crs_ochl_id2 := addNonTrmCrsResource(
                    p_ne_id,            p_ne_tid,             p_crs_cctype,
                    p_crs_ccpath,       p_crs_och1_dwdmside,  l_line1.eqpt_id1,
                    l_line1.eqpt_aid1,  l_line1.fac_id1,      l_line1.fac_aid1,
                    l_line1.ochp_id1,   l_line1.ochp_aid1,    p_crs_ochl_id,
                    l_line1.eqpt_id2,   l_line1.eqpt_aid2,    l_line1.fac_id2,
                    l_line1.fac_aid2,   l_line1.ochp_id2,     l_line1.ochp_aid2,
                    l_line1.och_port1, l_line1.och_port2,     circuitType);
            END LOOP;
        END IF;
        RETURN v_crs_ochl_id2;
    END findNonTrmCrsOeo;

    PROCEDURE findDWDMLinkAndOtherSideOCHL(ochId IN NUMBER, otherOchId OUT NUMBER) AS
        neId        NUMBER;
        v_oms_id    NUMBER;
        v_oms_other_id    NUMBER;
        v_ots_other_chanTypes VARCHAR2(20);
        v_och_num   NUMBER;
        v_ref_cursor       EMS_REF_CURSOR;

        l_lnk nm_circuit_oms_cache%ROWTYPE;
     BEGIN circuit_util.print_start('findDWDMLinkAndOtherSideOCHL');
        OPEN v_ref_cursor FOR SELECT och_parent_id, OCH_CHANNUM  FROM cm_channel_och WHERE och_id=ochId;
        FETCH v_ref_cursor INTO v_oms_id, v_och_num;
        IF v_ref_cursor%NOTFOUND THEN
            otherOchId := 0;
            RETURN;
        END IF;
        CLOSE v_ref_cursor;

        OPEN v_ref_cursor FOR SELECT * FROM nm_circuit_oms_cache WHERE report_id=g_rpt_id AND oms_id=v_oms_id;
        FETCH v_ref_cursor INTO l_lnk;
        IF v_ref_cursor%NOTFOUND THEN
            FOR l_lnk IN (
            SELECT lnk.LINK_ID, lnk.LINK_NAME, och.OCH_CHANNUM, lnk.LINK_PORT_A, lnk.LINK_PORT_Z, lnk.LINK_NE_ID_A, lnk.LINK_NE_ID_Z, ots.OTS_AID, och.NE_ID, oms_id
                , neA.ne_tid ne_tidA, neZ.ne_tid ne_tidZ, neA.ne_type ne_typeA, neA.ne_stype ne_stypeA, neZ.ne_type ne_typeZ, neZ.ne_stype ne_stypeZ, ots.ots_chanTypes
              FROM CM_LINK lnk, CM_CHANNEL_OCH och, CM_FACILITY_OMS oms, CM_FACILITY_OTS ots, EMS_NE neA, EMS_NE neZ
              WHERE och.OCH_ID=ochId AND neA.ne_id=lnk.LINK_NE_ID_A AND neZ.ne_id=lnk.LINK_NE_ID_Z AND
               ((och.NE_ID = lnk.LINK_NE_ID_A AND lnk.LINK_PORT_A = ots.OTS_AID AND ots.OTS_ID = oms.OMS_PARENT_ID AND oms.OMS_ID = och.OCH_PARENT_ID) OR
                (och.NE_ID = lnk.LINK_NE_ID_Z AND lnk.LINK_PORT_Z = ots.OTS_AID AND ots.OTS_ID = oms.OMS_PARENT_ID AND oms.OMS_ID = och.OCH_PARENT_ID))
              ) LOOP
                  updateCircuitBounds(neId);
                  IF (l_lnk.LINK_PORT_A = l_lnk.ots_aid AND l_lnk.LINK_NE_ID_A = l_lnk.ne_id) THEN -- ochId indicates A point
                      OPEN v_ref_cursor FOR SELECT och.OCH_ID,oms_id,ots.ots_chantypes FROM CM_CHANNEL_OCH och, CM_FACILITY_OMS oms, CM_FACILITY_OTS ots
                          WHERE och.OCH_PARENT_ID=oms.OMS_ID AND oms.OMS_PARENT_ID=OTS_ID AND ots.OTS_AID=l_lnk.LINK_PORT_Z AND ots.ne_id=l_lnk.LINK_NE_ID_Z
                          AND och.OCH_CHANNUM=l_lnk.OCH_CHANNUM;
                      FETCH v_ref_cursor INTO otherOchId,v_oms_other_id, v_ots_other_chanTypes;
                      CLOSE v_ref_cursor;
                      addDWDMLinkToList(l_lnk.link_id, l_lnk.link_name, l_lnk.link_ne_id_a, l_lnk.link_ne_id_z,l_lnk.ne_tidA, l_lnk.ne_tidZ,
                                        l_lnk.ne_typeA,l_lnk.ne_typeZ, l_lnk.ne_stypeA, l_lnk.ne_stypeZ, l_lnk.LINK_PORT_A, l_lnk.LINK_PORT_Z,
                                        ochId, otherOchId, l_lnk.ots_chanTypes, v_ots_other_chanTypes);
                  ELSE
                      OPEN v_ref_cursor FOR SELECT och.OCH_ID,oms_id,ots.ots_chantypes FROM CM_CHANNEL_OCH och, CM_FACILITY_OMS oms, CM_FACILITY_OTS ots
                          WHERE och.OCH_PARENT_ID=oms.OMS_ID AND oms.OMS_PARENT_ID=OTS_ID AND ots.OTS_AID=l_lnk.LINK_PORT_A AND ots.ne_id=l_lnk.LINK_NE_ID_A
                          AND och.OCH_CHANNUM=l_lnk.OCH_CHANNUM;
                      FETCH v_ref_cursor INTO otherOchId,v_oms_other_id, v_ots_other_chanTypes;
                      CLOSE v_ref_cursor;
                      addDWDMLinkToList(l_lnk.link_id, l_lnk.link_name, l_lnk.link_ne_id_a, l_lnk.link_ne_id_z,l_lnk.ne_tidA, l_lnk.ne_tidZ,
                                        l_lnk.ne_typeA,l_lnk.ne_typeZ, l_lnk.ne_stypeA, l_lnk.ne_stypeZ, l_lnk.LINK_PORT_A, l_lnk.LINK_PORT_Z,
                                        otherOchId, ochId, v_ots_other_chanTypes, l_lnk.ots_chanTypes);
                  END IF;
                  IF g_rpt_id > 0 THEN
                  INSERT INTO nm_circuit_oms_cache(OTS_AID,OMS_OTHER_ID,OMS_ID, NE_TYPEZ,
                      NE_TYPEA,NE_TIDZ,NE_TIDA,NE_STYPEZ,NE_STYPEA,
                      NE_ID,LINK_PORT_Z,LINK_PORT_A,LINK_NE_ID_Z,LINK_NE_ID_A,
                      LINK_NAME,LINK_ID,OTS_CHANTYPES,report_id)
                    VALUES(
                        l_lnk.ots_aid, v_oms_other_id, l_lnk.OMS_ID, l_lnk.ne_typez,
                        l_lnk.ne_typea, l_lnk.ne_tidz, l_lnk.ne_tida, l_lnk.ne_stypez, l_lnk.ne_stypea,
                        l_lnk.ne_id, l_lnk.link_port_z, l_lnk.link_port_a, l_lnk.link_ne_id_z, l_lnk.link_ne_id_a,
                        l_lnk.link_name, l_lnk.link_id, l_lnk.ots_chanTypes, g_rpt_id
                  );
                  COMMIT;
                  END IF;
              END LOOP;
            RETURN;
        END IF;
        CLOSE v_ref_cursor;

        -- commented out in t71mr00186333, because i think it is redundent codes, previous codes have already added the DWDM Link
        -- if somebody find it is actually needed, pls re-add it
        /*OPEN v_ref_cursor FOR SELECT och.OCH_ID, ots.ots_chantypes FROM CM_CHANNEL_OCH och, CM_FACILITY_OMS oms, CM_FACILITY_OTS ots
        WHERE och.OCH_PARENT_ID=l_lnk.OMS_other_ID AND  och.OCH_CHANNUM=v_och_num AND oms.OMS_ID=l_lnk.OMS_other_ID AND ots.ots_id=oms.Oms_Parent_Id;
        FETCH v_ref_cursor INTO otherOchId, v_ots_other_chanTypes;
        CLOSE v_ref_cursor;
        IF (l_lnk.LINK_PORT_A = l_lnk.ots_aid AND l_lnk.LINK_NE_ID_A = l_lnk.ne_id) THEN
            addDWDMLinkToList(l_lnk.link_id, l_lnk.link_name, l_lnk.link_ne_id_a, l_lnk.link_ne_id_z,l_lnk.ne_tidA, l_lnk.ne_tidZ,
                              l_lnk.ne_typeA,l_lnk.ne_typeZ, l_lnk.ne_stypeA, l_lnk.ne_stypeZ, l_lnk.LINK_PORT_A, l_lnk.LINK_PORT_Z,
                              ochId, otherOchId, l_lnk.ots_chantypes, v_ots_other_chanTypes);
        ELSE
            addDWDMLinkToList(l_lnk.link_id, l_lnk.link_name, l_lnk.link_ne_id_a, l_lnk.link_ne_id_z,l_lnk.ne_tidA, l_lnk.ne_tidZ,
                              l_lnk.ne_typeA,l_lnk.ne_typeZ, l_lnk.ne_stypeA, l_lnk.ne_stypeZ, l_lnk.LINK_PORT_A, l_lnk.LINK_PORT_Z,
                              otherOchId, ochId, v_ots_other_chanTypes, l_lnk.ots_chantypes);
        END IF;*/
    circuit_util.print_end('findDWDMLinkAndOtherSideOCHL'); END;

    PROCEDURE findExprsLinkAndOtherSideOCHDP(ochId IN NUMBER, otherOchId OUT NUMBER) AS
        neId           NUMBER;
        channel        NUMBER;
        otherNeId      NUMBER;
        otherRCMMPort  NUMBER;
        ochFromEqptId  NUMBER;
        ochToEqptId    NUMBER;
        fromSide       VARCHAR2(5);
        toSide         VARCHAR2(5);
        connectionInfo VARCHAR2(100);
        otherNeTid     VARCHAR2(50);
        otherRCMMAid   VARCHAR2(20);
        ochDpAid       VARCHAR2(20);
        otherOchDpAid  VARCHAR2(20);
        v_ref_cursor          EMS_REF_CURSOR;
    BEGIN circuit_util.print_start('findExprsLinkAndOtherSideOCHDP');
        circuit_util.print_line('Finding Express Link from OCH-DP:' ||ochId||' ...');
        OPEN v_ref_cursor FOR SELECT subDp.NE_ID, subDp.OCH_AID, mainDp.OCH_PARENT_ID, mainDp.OCH_DWDMSIDE, mainDp.OCH_CONNECTEDTO
           FROM CM_CHANNEL_OCH subDp, CM_CHANNEL_OCH mainDp
           WHERE subDp.OCH_ID=ochId AND subDp.OCH_PARENT_ID=mainDp.OCH_ID;
        FETCH v_ref_cursor INTO neId, ochDpAid, ochFromEqptId, fromSide, connectionInfo;
        IF v_ref_cursor%NOTFOUND THEN
           circuit_util.print_line('No OCH-DP found with Id '||ochId||'.');
        ELSE
           channel := NVL(TO_NUMBER(SUBSTR(ochDpAid, INSTR(ochDpAid, '-',1,5) + 1, LENGTH(ochDpAid))),0);
           otherNeTid := SUBSTR(connectionInfo, 1, INSTR(connectionInfo, ' ') - 1);
           otherRCMMAid := SUBSTR(connectionInfo, INSTR(connectionInfo, ' ') + 1, LENGTH(connectionInfo));
           otherRCMMPort := NVL(TO_NUMBER(SUBSTR(otherRCMMAid, INSTR(otherRCMMAid, '-',1,3) + 1, LENGTH(otherRCMMAid))),0);
           otherRCMMAid := SUBSTR(otherRCMMAid, 1, INSTR(otherRCMMAid, '-',1,3) - 1);
           otherOchDpAid := 'OCH-DP-' || SUBSTR(otherRCMMAid, 6, INSTR(otherRCMMAid, '-',1,1)) || '-' || otherRCMMPort || '-' || channel;

           circuit_util.print_line('CONNECTED TO '||fromSide||','||otherNeTid||','||otherOchDpAid);

           OPEN v_ref_cursor FOR SELECT ne.NE_ID, subDp.OCH_ID, mainDp.OCH_PARENT_ID, mainDp.OCH_DWDMSIDE
              FROM EMS_NE ne, CM_CHANNEL_OCH subDp, CM_CHANNEL_OCH mainDp
              WHERE ne.NE_TID=otherNeTid AND subDp.NE_ID=ne.NE_ID AND mainDp.NE_ID=ne.NE_ID AND
              subDp.OCH_AID=otherOchDpAid AND subDp.OCH_PARENT_ID=mainDp.OCH_ID;
           FETCH v_ref_cursor INTO otherNeId, otherOchId, ochToEqptId, toSide;
           IF v_ref_cursor%NOTFOUND THEN
              circuit_util.print_line('No OCH-DP found on other NE with other NE information provided in OCH-DP');
           ELSE
              updateCircuitBounds(neId);
              addExpLinkToList(neId,otherNeId,ochDpAid,otherOchDpAid,fromSide,toSide);
           END IF;
        END IF;
        CLOSE v_ref_cursor;
    circuit_util.print_end('findExprsLinkAndOtherSideOCHDP'); END;

    PROCEDURE findPassthrLinkAndOtherSideOCH(neId IN NUMBER, ochId IN NUMBER, ochType IN VARCHAR2, crsId IN VARCHAR2,
                                             thisOchPosInNextXC IN VARCHAR2, circuitType IN VARCHAR2, otherOchId OUT NUMBER) AS
        ncount         NUMBER;
        i              NUMBER;
        crsIndex       NUMBER;

        otherOchIdList     StringTable70;
        otherOchAidList    StringTable70;
        ochAidList         StringTable70;
        fromSideList       StringTable70;
        toSideList         StringTable70;
        otherNeIdList      StringTable70;
        otherNeTypeList    StringTable70;
        crsIdList          StringTable70;
        v_fiberlink             FIBERLINK_RECORD;
    BEGIN circuit_util.print_start('findPassthrLinkAndOtherSideOCH');
        crsIndex:=0;

        circuit_util.print_line('Finding Passthr Link from:' ||ochId||', type:'||ochType||' ...');

        SELECT a.OCH_ID, nvl(ac.CARD_AID,a.OCH_AID||'FW'), nvl(bc.CARD_AID,b.OCH_AID||'FW'), nvl(b.OCH_DWDMSIDE,'A'), nvl(a.OCH_DWDMSIDE,'A'), ane.NE_ID, ane.NE_TYPE, CRS_CKTID
          BULK COLLECT INTO otherOchIdList, otherOchAidList, ochAidList, fromSideList, toSideList, otherNeIdList, otherNeTypeList, crsIdList
        FROM CM_CHANNEL_OCH a, CM_CHANNEL_OCH b, CM_CARD ac, CM_CARD bc, CM_CRS, EMS_NE ane, EMS_NE bne
        WHERE ane.NE_CLLI=bne.NE_CLLI AND ane.NE_CLLI is not null AND bne.NE_CLLI is not null AND ane.NE_ID<>bne.NE_ID AND bne.NE_ID=b.NE_ID AND ane.NE_ID=a.NE_ID AND bc.NE_ID(+)=b.NE_ID AND ac.NE_ID(+)=a.NE_ID AND b.NE_ID=neId AND
            a.OCH_CHANNUM=b.OCH_CHANNUM AND b.OCH_ID=ochId AND a.OCH_TYPE IN('1','P','CP','BP') AND b.OCH_TYPE IN('1','P','CP','BP') AND
            ac.CARD_ID(+)=a.OCH_PARENT_ID AND bc.CARD_ID(+)=b.OCH_PARENT_ID AND (a.OCH_ID=CRS_FROM_ID OR a.OCH_ID=CRS_TO_ID);

        IF otherOchIdList IS NOT NULL THEN
           ncount:=otherOchIdList.COUNT;
           circuit_util.print_line('Total Passthr link destinations: '||ncount);
        ELSE
           circuit_util.print_line('No Passthr link destinations found for '||ochId);
        END IF;

        IF ochType='OCH-P' THEN
           IF ncount=1 THEN
              IF crsIdList(1)=crsId AND otherNeTypeList(1) LIKE '%OLT%' THEN
                 updateCircuitBounds(otherNeIdList(1));
                 addExpLinkToList(neId,otherNeIdList(1),ochAidList(1),otherOchAidList(1),fromSideList(1),toSideList(1));
                 otherOchId:=otherOchIdList(1);
              ELSE
                 circuit_util.print_line('Passthr link criteria not met for '||ochId);
              END IF;
           ELSE
              circuit_util.print_line('Passthr link criteria not met for '||ochId);
           END IF;
        ELSIF ochType='OCH' OR ochType='OCH-CP' OR ochType='OCH-BP' THEN
           crsIndex := 0;
           if ncount >0 then
              FOR i IN 1..ncount LOOP
                IF crsIdList(i)=crsId THEN
                   crsIndex:=i; -- take the first match
                   EXIT;
                END IF;
              END LOOP;
           elsif ochType='OCH' then
             otherOchId:=findFiberLinkFromOCH(ochId, thisOchPosInNextXC, 0, circuitType, v_fiberlink);
             otherOchId:=0;
           end if;
           IF crsIndex > 0 THEN
              updateCircuitBounds(otherNeIdList(crsIndex));
              addExpLinkToList(neId,otherNeIdList(crsIndex),ochAidList(crsIndex),otherOchAidList(crsIndex),fromSideList(crsIndex),toSideList(crsIndex));
              otherOchId:=otherOchIdList(crsIndex);
           END IF;
        END IF;
    circuit_util.print_end('findPassthrLinkAndOtherSideOCH'); END;

    FUNCTION findPairingOCH(neId IN number, cardId IN NUMBER, ochpId IN NUMBER DEFAULT NULL) RETURN NUMBER IS
        v_ref_cursor          EMS_REF_CURSOR;
        otherOCHPId    NUMBER;
        otherCardAid   VARCHAR2(20);
        otherCardId    NUMBER;
        stype          VARCHAR2(15);
        workingId      NUMBER;
        protectingId   NUMBER;
    BEGIN circuit_util.print_start('findPairingOCH');
        otherOCHPId:=0;

        IF ochpId IS NOT NULL THEN -- added for HDTG
           OPEN v_ref_cursor FOR select OCH_WORKINGID, OCH_PROTECTIONID from CM_CHANNEL_OCH where OCH_ID=ochpId;
           FETCH v_ref_cursor INTO workingId, protectingId;
           IF ochpId = workingId THEN
              otherOCHPId := protectingId;
              addFFPtoList(neId, workingId, protectingId); -- add HDTG FFP
           ELSIF ochpId = protectingId THEN
              otherOCHPId := workingId;
              addFFPtoList(neId, workingId, protectingId); -- add HDTG FFP
           END IF;
        END IF;

        IF otherOCHPId=0 THEN

        OPEN v_ref_cursor FOR SELECT OTHER_CARD_AID FROM SMTM_PROTECTION_CM_VW
           WHERE (PROT_SCHEME='UPSR' OR PROT_SCHEME='SNCPRING' OR PROT_SCHEME='DPRING') AND CARD_ID=cardId;
        FETCH v_ref_cursor INTO otherCardAid;
        IF v_ref_cursor%FOUND THEN
           CLOSE v_ref_cursor;
           OPEN v_ref_cursor FOR SELECT OCH_ID
              FROM CM_CHANNEL_OCH, CM_CARD, CM_CRS
              WHERE OCH_PARENT_ID=CARD_ID AND (CRS_FROM_ID=OCH_ID OR CRS_TO_ID=OCH_ID) AND CM_CARD.NE_ID=neId AND CM_CHANNEL_OCH.NE_ID=neId AND CM_CRS.NE_ID=neId AND CARD_AID=otherCardAid;
           FETCH v_ref_cursor INTO otherOCHPId;
        ELSE
           OPEN v_ref_cursor FOR SELECT NE_STYPE FROM EMS_NE WHERE NE_ID=neId;
           FETCH v_ref_cursor INTO stype;

           otherCardId:=getSMTMPPair(neId, cardId, stype);
           CLOSE v_ref_cursor;
           OPEN v_ref_cursor FOR SELECT OCH_ID
              FROM CM_CHANNEL_OCH, CM_CARD, CM_CRS
              WHERE OCH_PARENT_ID=CARD_ID AND (CRS_FROM_ID=OCH_ID OR CRS_TO_ID=OCH_ID) AND CM_CARD.NE_ID=neId AND CM_CHANNEL_OCH.NE_ID=neId AND CM_CRS.NE_ID=neId AND CARD_ID=otherCardId;
           FETCH v_ref_cursor INTO otherOCHPId;
        END IF;
        CLOSE v_ref_cursor;

        END IF;

        --circuit_util.print_line('SMTM/SSM/HDTG Pair other OCH-P:'||otherOCHPId);

     circuit_util.print_end('findPairingOCH');
        RETURN otherOCHPId;
     END findPairingOCH;

    FUNCTION findYCABLEPairingOCH(neId IN number, cardId IN NUMBER, ochpId IN NUMBER, circuitType IN VARCHAR DEFAULT NULL) RETURN NUMBER IS
        v_ref_cursor          EMS_REF_CURSOR;
        otherOCHPId    NUMBER;
        cardAidType    VARCHAR2(15);
        workingId      NUMBER;
        protectingId   NUMBER;
    BEGIN circuit_util.print_start('findYCABLEPairingOCH');
        otherOCHPId:=0;

        IF cardId IS NOT NULL THEN
          OPEN v_ref_cursor FOR SELECT CARD_AID_TYPE FROM CM_CARD
               WHERE NE_ID=neId AND CARD_ID = cardId;
          FETCH v_ref_cursor INTO cardAidType;
          CLOSE v_ref_cursor;

          IF cardAidType LIKE 'OSM__' OR cardAidType = 'OMMX' THEN
             IF circuitType = 'OCH' THEN
                OPEN v_ref_cursor FOR SELECT F1.FAC_WORKINGID, F1.FAC_PROTECTIONID, o2.och_id FROM CM_FACILITY F1, CM_FACILITY F2, CM_CHANNEL_OCH o1, CM_CHANNEL_OCH o2
                    WHERE o1.ne_id = neId AND o1.och_id = ochpId
                    AND F1.ne_id = neId AND F1.FAC_PARENT_ID = o1.och_parent_id AND F1.FAC_SCHEME = 'YCABLE' AND circuit_util.trimAidType(F1.fac_aid)=circuit_util.trimAidType(o1.och_aid)
                    AND F2.ne_id = neId AND (F1.FAC_PROTECTIONID = F2.FAC_ID OR F2.FAC_PROTECTIONID = F1.FAC_ID)
                    AND o2.ne_id = neId AND o2.och_id <> o1.och_id AND F2.FAC_PARENT_ID = o2.och_parent_id AND circuit_util.trimAidType(F2.fac_aid)=circuit_util.trimAidType(o2.och_aid);
                FETCH v_ref_cursor INTO workingId,protectingId,otherOCHPId;
                CLOSE v_ref_cursor;
             END IF;
          ELSIF cardAidType LIKE 'HDTG%' THEN
             IF circuitType = 'OCH' THEN
                OPEN v_ref_cursor FOR SELECT F1.FAC_WORKINGID, F1.FAC_PROTECTIONID, o2.och_id FROM CM_FACILITY F1, CM_FACILITY F2, CM_CHANNEL_OCH o1, CM_CHANNEL_OCH o2
                    WHERE o2.NE_ID = neId AND o1.ne_id = o2.ne_id
                    AND o1.och_parent_id = F1.FAC_PARENT_ID AND F2.FAC_PARENT_ID = o2.och_parent_id
                    AND (F1.FAC_PROTECTIONID = F2.FAC_ID OR F2.FAC_PROTECTIONID = F1.FAC_ID)
                    AND F1.FAC_SCHEME = 'YCABLE'
                    AND o1.och_id = ochpId AND o2.och_id <> o1.och_id
                    AND F1.FAC_AID_PORT = o1.OCH_AID_PORT +1 AND F2.FAC_AID_PORT = o2.OCH_AID_PORT +1;
                FETCH v_ref_cursor INTO workingId,protectingId,otherOCHPId;
                CLOSE v_ref_cursor;
             END IF;
          ELSIF cardAidType = 'FGTMM' THEN
             IF circuitType = 'STS' THEN
                OPEN v_ref_cursor FOR SELECT F1.FAC_WORKINGID, F1.FAC_PROTECTIONID, o2.och_id FROM CM_FACILITY F1, CM_FACILITY F2, CM_CHANNEL_OCH o1, CM_CHANNEL_OCH o2
                    WHERE o2.NE_ID = neId AND o1.ne_id = o2.ne_id
                    AND o1.och_parent_id = F1.FAC_PARENT_ID AND F2.FAC_PARENT_ID = o2.och_parent_id
                    AND (F1.FAC_PROTECTIONID = F2.FAC_ID OR F2.FAC_PROTECTIONID = F1.FAC_ID)
                    AND F1.FAC_SCHEME = 'YCABLE'-- AND F1.Fac_Aid_Type IN ('GOPT','GBEP','OTU1','STM16','OC48'
                    AND o1.och_id = ochpId AND o2.och_id <> o1.och_id;
                FETCH v_ref_cursor INTO workingId,protectingId,otherOCHPId;
                CLOSE v_ref_cursor;
             END IF;
          ELSIF cardAidType LIKE 'OTNM_' THEN
             IF circuitType = 'STS' THEN
                OPEN v_ref_cursor FOR SELECT F1.FAC_WORKINGID, F1.FAC_PROTECTIONID, o2.och_id FROM CM_FACILITY F1, CM_FACILITY F2, CM_CHANNEL_OCH o1, CM_CHANNEL_OCH o2
                    WHERE o2.NE_ID = neId AND o1.ne_id = o2.ne_id
                    AND o1.och_parent_id = F1.FAC_PARENT_ID AND F2.FAC_PARENT_ID = o2.och_parent_id
                    AND (F1.FAC_PROTECTIONID = F2.FAC_ID OR F2.FAC_PROTECTIONID = F1.FAC_ID)
                    AND F1.FAC_SCHEME = 'YCABLE'-- AND F1.Fac_Aid_Type IN ('GOPT','GBEP','OTU1','STM16','OC48'
                    AND o1.och_id = ochpId AND o2.och_id <> o1.och_id;
                FETCH v_ref_cursor INTO workingId,protectingId,otherOCHPId;
                CLOSE v_ref_cursor;
             END IF;
          ELSIF cardAidType IN ('FGTM','HGTM','HGTMS') OR cardAidType LIKE 'MRTM_' OR cardAidType LIKE 'TGTM_' THEN
              --FGTM, TGTME are straight forward with single OCH-P and no subrate port fac
              OPEN v_ref_cursor FOR SELECT F1.FAC_WORKINGID, F1.FAC_PROTECTIONID, o2.och_id FROM CM_FACILITY F1, CM_FACILITY F2, CM_CHANNEL_OCH o1, CM_CHANNEL_OCH o2
                  WHERE o2.NE_ID = neId AND o1.ne_id = o2.ne_id
                  AND o1.och_parent_id = F1.FAC_PARENT_ID AND F2.FAC_PARENT_ID = o2.och_parent_id
                  AND (F1.FAC_PROTECTIONID = F2.FAC_ID OR F2.FAC_PROTECTIONID = F1.FAC_ID)
                  AND F1.FAC_SCHEME = 'YCABLE'
                  AND o1.och_id = ochpId AND o2.och_id <> o1.och_id;
              FETCH v_ref_cursor INTO workingId,protectingId,otherOCHPId;
              CLOSE v_ref_cursor;
          END IF;

          IF workingId IS NOT NULL AND protectingId IS NOT NULL THEN
             addFFPtoList(neId, workingId, protectingId);--auto created for these TRN
          END IF;
        END IF;

     circuit_util.print_end('findYCABLEPairingOCH');
        RETURN otherOCHPId;
    END findYCABLEPairingOCH;

    PROCEDURE processStsPassthroughXc(
          p_ne_id NUMBER, p_sts_aid VARCHAR2, p_other_sts1map VARCHAR2
    ) AS
        v_sts_id NUMBER;
        v_first_slot_sts_id NUMBER;
        v_another_sts1map VARCHAR2(600);
        v_sts_aid_pattern VARCHAR2(40);
        v_first BOOLEAN := TRUE;
        v_int NUMBER;
    BEGIN
        circuit_util.print_start('processStsPassthroughXc');
        circuit_util.print_line(p_ne_id||','||p_sts_aid||','||p_other_sts1map);
        SELECT sts_id INTO v_sts_id FROM cm_sts WHERE ne_id=p_ne_id AND sts_aid =p_sts_aid;
        SELECT count(*) INTO v_int FROM cm_crs_sts WHERE crs_sts_to_id=v_sts_id;
        IF v_int = 0 THEN  --facility with sts_aid=p_sts_aid is from end in cm_crs_sts
            v_sts_aid_pattern := substr(p_sts_aid, 1, instr(p_sts_aid, '-', -1))||'%';
            FOR l_sts IN (
                  SELECT sts_aid_sts, sts_id FROM cm_sts WHERE sts_id IN (
                      SELECT crs_sts_to_id FROM cm_crs_sts WHERE crs_sts_from_id IN (
                          SELECT sts_id FROM cm_sts WHERE ne_id=p_ne_id AND sts_aid LIKE v_sts_aid_pattern AND p_other_sts1map||'&' LIKE '%'||sts_aid_sts||'&%'
                      ) OR crs_sts_to_id IN (
                        SELECT sts_id FROM cm_sts WHERE ne_id=p_ne_id AND sts_aid LIKE v_sts_aid_pattern AND p_other_sts1map||'&' LIKE '%'||sts_aid_sts||'&%'
                    )
                  ) ORDER BY sts_aid_sts ASC
            )LOOP
               IF v_first THEN
                    v_first := FALSE;
                    v_first_slot_sts_id := l_sts.sts_id;
                    v_another_sts1map := l_sts.sts_aid_sts;
                ELSE
                    v_another_sts1map := v_another_sts1map|| '&'||l_sts.sts_aid_sts;
                END IF;
            END LOOP;

            FOR l_crs IN (
                SELECT  crs_sts_from_id, crs_sts_to_id FROM cm_crs_sts WHERE crs_sts_from_id IN (
                      SELECT sts_id FROM cm_sts WHERE ne_id=p_ne_id AND sts_aid LIKE v_sts_aid_pattern AND p_other_sts1map||'&' LIKE '%'||sts_aid_sts||'&%'
                )
                UNION
                SELECT  crs_sts_from_id, crs_sts_to_id FROM cm_crs_sts WHERE crs_sts_to_id IN (
                      SELECT sts_id FROM cm_sts WHERE ne_id=p_ne_id AND sts_aid LIKE v_sts_aid_pattern AND p_other_sts1map||'&' LIKE '%'||sts_aid_sts||'&%'
                )
            )LOOP
                IF v_first_slot_sts_id IN (l_crs.crs_sts_from_id, l_crs.crs_sts_to_id) THEN
                    addSTSConnectionToList(p_ne_id, l_crs.crs_sts_from_id, l_crs.crs_sts_to_id, p_other_sts1map, v_another_sts1map, TRUE);
                ELSE
                    addSTSConnectionToList(p_ne_id, l_crs.crs_sts_from_id, l_crs.crs_sts_to_id, NULL, NULL, TRUE);
                END IF;
                addFacilityToList(p_ne_id,l_crs.crs_sts_from_id);
                addFacilityToList(p_ne_id,l_crs.crs_sts_to_id);
            END LOOP;
        ELSE  --facility with sts_aid=p_sts_aid is to-end in cm_crs_sts
            v_sts_aid_pattern := substr(p_sts_aid, 1, instr(p_sts_aid, '-', -1))||'%';
            FOR l_sts IN (
                SELECT sts_aid_sts, sts_id FROM cm_sts WHERE sts_id IN (
                    SELECT crs_sts_from_id FROM cm_crs_sts WHERE crs_sts_from_id IN (
                        SELECT sts_id FROM cm_sts WHERE ne_id=p_ne_id AND sts_aid LIKE v_sts_aid_pattern AND p_other_sts1map||'&' LIKE '%'||sts_aid_sts||'&%'
                    ) OR crs_sts_to_id IN (
                        SELECT sts_id FROM cm_sts WHERE ne_id=p_ne_id AND sts_aid LIKE v_sts_aid_pattern AND p_other_sts1map||'&' LIKE '%'||sts_aid_sts||'&%'
                    )
                ) ORDER BY sts_aid_sts ASC
            )LOOP
                IF v_first THEN
                    v_first := FALSE;
                    v_first_slot_sts_id := l_sts.sts_id;
                    v_another_sts1map := l_sts.sts_aid_sts;
                ELSE
                    v_another_sts1map := v_another_sts1map|| '&'||l_sts.sts_aid_sts;
                END IF;
            END LOOP;

            FOR l_crs IN (
                SELECT crs_sts_from_id, crs_sts_to_id FROM cm_crs_sts WHERE crs_sts_from_id IN (
                      SELECT sts_id FROM cm_sts WHERE ne_id=p_ne_id AND sts_aid LIKE v_sts_aid_pattern AND p_other_sts1map||'&' LIKE '%'||sts_aid_sts||'&%'
                )
                UNION
                SELECT crs_sts_from_id, crs_sts_to_id FROM cm_crs_sts WHERE crs_sts_to_id IN (
                      SELECT sts_id FROM cm_sts WHERE ne_id=p_ne_id AND sts_aid LIKE v_sts_aid_pattern AND p_other_sts1map||'&' LIKE '%'||sts_aid_sts||'&%'
                )
            )LOOP
                IF v_first_slot_sts_id IN (l_crs.crs_sts_from_id, l_crs.crs_sts_to_id) THEN
                    addSTSConnectionToList(p_ne_id, l_crs.crs_sts_from_id, l_crs.crs_sts_to_id, v_another_sts1map, p_other_sts1map, TRUE);
                ELSE
                    addSTSConnectionToList(p_ne_id, l_crs.crs_sts_from_id, l_crs.crs_sts_to_id, NULL, NULL, TRUE);
                END IF;
                addFacilityToList(p_ne_id,l_crs.crs_sts_from_id);
                addFacilityToList(p_ne_id,l_crs.crs_sts_to_id);
            END LOOP;
        END IF;
    circuit_util.print_end('processStsPassthroughXc');
    END processStsPassthroughXc;

    PROCEDURE findOCHCircuitAndOtherSideSTS(stsAid IN VARCHAR2, cardId IN NUMBER, neId IN NUMBER) AS
        v_ref_cursor       EMS_REF_CURSOR;
        duplicateKey NUMBER;
        links        V_B_TEXT;
        connections  V_B_TEXT;
        stsConnections  V_B_EXTEXT;
        expresses    V_B_STRING;
        facilities   V_B_STRING;
        equipments   V_B_STRING;
        ffps         V_B_STRING;
        min_x_left   NUMBER;
        max_x_right  NUMBER;
        min_y_top    NUMBER;
        max_y_bottom NUMBER;
        wavelength   VARCHAR2(5);
        signalRate   VARCHAR2(70);
        cardAid      VARCHAR2(20);
        odu1cId      NUMBER;
        odu2Id       NUMBER;
        odu3Id       NUMBER;
        otu3Id       NUMBER;
        odu_mapping_list V_B_STRING;
        odu_mapping_type_list V_B_STRING;
        odu_mapping_tribslot_list V_B_STRING;
        ochId        NUMBER;
        idx       NUMBER;
        facYcable    VARCHAR2(20);
        facCcpath    VARCHAR2(20);
        facSts1map   VARCHAR2(500);
        v_fiberlink  FIBERLINK_RECORD;
    BEGIN circuit_util.print_start('findOCHCircuitAndOtherSideSTS');

        circuit_util.print_line('~~~~~~~~~~~~~~~~~~~~ Finding OCH Circuit from cardId2:'||neId|| ','||cardId|| ','||stsAid||' BEGIN');
        OPEN v_ref_cursor FOR SELECT FAC_ID FROM CM_FACILITY WHERE NE_ID = neId AND FAC_AID = stsAid UNION SELECT sts_id FROM cm_sts WHERE ne_id=neId AND sts_aid=stsAid;
        FETCH v_ref_cursor INTO g_sts_id;
        CLOSE v_ref_cursor;

        checkForDuplicateProcessingSTS(g_sts_id ||'-'|| g_next_och_pos_in_next_xc, duplicateKey);

        IF duplicateKey<>0 THEN
           circuit_util.print_line('~~~~~~~~~~~~~~~~~~~~ Finding OCH Circuit from cardId3:' ||cardId||' END');
           RETURN;
        END IF;

        -- get ready to invoke OCH discovery
        -- it is a problem here, use one g_sts_aid for multil-level comp-link preHopStsAid
        -- there may be a better solution in the future
        IF g_sts_aid IS NULL OR
           circuit_util.getFacAidType(g_sts_aid)=circuit_util.getFacAidType(stsAid)
        THEN
           g_ne_id:=neId;
           g_ne_idx:=neId;
           g_sts_aid:=stsAid;
           g_card_id:=cardId;
        END IF;

        OPEN v_ref_cursor FOR SELECT CARD_AID FROM CM_CARD WHERE CARD_ID = cardId;
        FETCH v_ref_cursor INTO cardAid;
        CLOSE v_ref_cursor;

        IF stsAid LIKE 'ODU%' THEN
           OPEN v_ref_cursor FOR SELECT FAC_ID FROM CM_FACILITY WHERE NE_ID = neId AND FAC_AID = stsAid;
           FETCH v_ref_cursor INTO g_sts_id;
           CLOSE v_ref_cursor;
           g_odu_table(circuit_util.getOduLayer(stsAid)).ne_id := g_ne_id;
           g_odu_table(circuit_util.getOduLayer(stsAid)).odu_id := g_sts_id;
           g_odu_table(circuit_util.getOduLayer(stsAid)).odu_aid := stsAid;
        ELSE
            IF cardAid LIKE 'OTNM%' THEN
                OPEN v_ref_cursor FOR SELECT fac1.fac_id,fac2.fac_id, fac1.fac_sts1map, x.crs_ccpath
                    FROM cm_facility fac1, cm_facility fac2, cm_crs x, cm_channel_och o
                    WHERE fac1.fac_aid=stsAid AND fac1.fac_aid_type != 'ODU1-C' AND fac1.ne_id=neId AND fac2.ne_id=neId
                    AND fac2.fac_aid=circuit_util.getOTNMXCedLineFacility(Nvl(fac1.fac_sts1map,Nvl(g_sts1map,'')), neId, fac1.fac_aid)
                    AND((x.crs_from_aid_type='OCH-P' AND x.crs_from_id=o.och_id) OR (x.crs_to_aid_type='OCH-P' AND x.crs_to_id=o.och_id))
                    AND o.och_parent_id=cardId;
                FETCH v_ref_cursor INTO odu2Id, odu1cId, facSts1map, facCcpath;
                CLOSE v_ref_cursor;
                IF odu1cId IS NOT NULL THEN
                    addFacilityToList(neId, odu2Id);
                    addFacilityToList(neId, odu1cId);
                    IF facCcpath LIKE 'ADD%' THEN
                       addSTSConnectionToList(neId, odu2Id, odu1cId, facSts1map, NULL);
                    ELSE
                       addSTSConnectionToList(neId, odu1cId, odu2Id, NULL, facSts1map);
                    END IF;
                END IF;
            END IF;
        END IF;

        OPEN v_ref_cursor FOR SELECT FAC_SCHEME FROM CM_FACILITY WHERE NE_ID = neId AND FAC_AID = stsAid;
             FETCH v_ref_cursor INTO facYcable;
        CLOSE v_ref_cursor;

        circuit_util.print_line('g_ne_id='||g_ne_id||',g_card_id='||g_card_id||',g_sts_aid='||g_sts_aid);
        IF facYcable <> 'YCABLE' THEN
           g_id_array:=g_empty_id_array; -- reset the duplicate cache before discover every OCH hop. This is needed if STS has to traverse the same OCH hop multiple times.
        END IF;

        IF nvl(cardAid, '') LIKE 'OSM%' OR nvl(cardAid, '') LIKE 'OMMX%' OR nvl(cardAid, '') LIKE 'HGTMM%' THEN
           /*odu2Id := circuit_util.getMappingOdu2FromOdu1(neId, g_sts_id, odu0_tribslot, odu1_tribslot, odu2_tribslot, middleOduList);
           IF (odu0_tribslot IS NOT NULL AND odu0_tribslot<>'0') THEN
               g_odu_tribslots(1) := odu0_tribslot;
           END IF;
           IF (odu1_tribslot IS NOT NULL AND odu1_tribslot<>'0') THEN
               g_odu_tribslots(2) := odu1_tribslot;
           END IF;
           IF (odu2_tribslot IS NOT NULL AND odu2_tribslot<>'0') THEN
               g_odu_tribslots(3) := odu2_tribslot;
           END IF;
           IF middleOduList IS NOT NULL THEN
              FOR i IN 1..middleOduList.COUNT LOOP
                 addFacilityToList(neId, middleOduList(i));
              END LOOP;
           END IF;*/

           --TODO
           odu2Id := circuit_util.getTopMappingOduFromLower(neId, g_sts_id, odu_mapping_list, odu_mapping_type_list, odu_mapping_tribslot_list);
           IF odu2Id<>0 and odu_mapping_list.count>1 THEN
              FOR i IN 1..odu_mapping_list.COUNT LOOP
                 addFacilityToList(neId, odu_mapping_list(i));
                 if odu_mapping_tribslot_list(i) is not null then
                    idx := circuit_util.getOduLayer(odu_mapping_type_list(i));
                    g_odu_tribslots(idx+1) := odu_mapping_tribslot_list(i);
                 end if;
              END LOOP;
           END IF;

           --IF stsAid LIKE 'ODU0%' AND odu2Id<>0 THEN
           IF odu2Id<>0 THEN
              addFacilityToList(neId, odu2Id);
           ELSIF stsAid LIKE 'ODU2%' and (nvl(cardAid, '') LIKE 'HGTMM%' or nvl(cardAid, '') LIKE 'OSM2C%') then
              odu2Id := g_sts_id;
           END IF;
           IF odu2Id > 0 THEN
              ochId := circuit_util.getMappingOchPFromOdu(neId, odu2id);
              IF ochId > 0 THEN
                 duplicateKey := 0;
                 checkForDuplicateProcessingODU(odu2Id,duplicateKey);
                 IF duplicateKey<>0 THEN
                     circuit_util.print_line('~~~~~~~~~~~~~~~~~~~~ Finding odu :' ||g_sts_id||' END');
                     RETURN;
                 END IF;
                 addFacilityToList(neId, ochId);
                 discoverLineOCHX(ochId, links, connections, stsConnections, expresses, facilities, equipments, ffps,min_x_left,  max_x_right, min_y_top, max_y_bottom, wavelength, signalRate, 'STS');
              ELSE -- find if it is a OTU than support fiber link
                ochId := circuit_util.getMappingFacFromOdu(neId, odu2id);
                IF ochId > 0 THEN
                   duplicateKey := 0;
                   checkForDuplicateProcessingODU(odu2Id,duplicateKey);
                   IF duplicateKey<>0 THEN
                     circuit_util.print_line('~~~~~~~~~~~~~~~~~~~~ Finding odu :' ||g_sts_id||' END');
                     RETURN;
                   END IF;
                   ochId := findFiberLinkFromOCH(ochId, 'BOTH', 0, 'STS', v_fiberlink ); -- circuitType=STS because it's called in this function
                END IF;
              END IF;
           END IF;
        ELSIF nvl(cardAid, '') LIKE 'FGSM%' THEN
          odu3Id := circuit_util.getTopMappingOduFromLower(neId, g_sts_id, odu_mapping_list, odu_mapping_type_list, odu_mapping_tribslot_list);
          IF (odu3Id>0) THEN
             FOR j IN 1..odu_mapping_list.COUNT LOOP
                IF (j>2) THEN
                  addFacilityToList(neId, odu_mapping_list(j));
                END IF;
             END LOOP;
            --it may be not a odu3, but a odu2, it's OK since no otu3 will be found;
            otu3Id := circuit_util.getMappingFacFromOdu(neId, odu3Id);
            IF (otu3Id>0) THEN
              addFacilityToList(neId, otu3Id);
            END IF;
          END IF;
          addEquipmentToList(neId, cardId);
        ELSE
           discoverEquipmentX(cardId, links, connections, stsConnections, expresses, facilities, equipments, ffps, min_x_left, max_x_right, min_y_top, max_y_bottom, wavelength, signalRate, 'STS');
        END IF;
    circuit_util.print_end('findOCHCircuitAndOtherSideSTS'); END;

    PROCEDURE findPPGFromSts(
        p_ne_id NUMBER, p_sts_id NUMBER
    )AS
    BEGIN
          FOR l_sts IN (
            SELECT fac_from.fac_scheme from_parent_scheme, sts1.sts_id from_id, sts3.sts_id src_id, crd1.card_id to_card_id, sts3.sts_aid src_aid, sts1.sts_sts1map from_sts1map,sts1.sts_port_or_line from_port_or_line,
                   fac_to.fac_scheme to_parent_scheme, sts2.sts_id to_id, sts4.sts_id dest_id, crd2.card_id dest_card_id, sts4.sts_aid dest_aid, sts4.sts_sts1map dest_sts1map, sts4.sts_port_or_line dest_port_or_line,
                   och_from.och_scheme from_och_parent_scheme,och_to.och_scheme to_och_parent_scheme
                  FROM cm_crs_sts crs
                      LEFT JOIN cm_sts sts1 ON (crs.crs_sts_from_id=sts1.sts_id)
                      LEFT JOIN cm_sts sts2 ON (crs.crs_sts_to_id=sts2.sts_id)
                      LEFT JOIN cm_sts sts3 ON (crs.crs_sts_src_prot=sts3.sts_aid AND crs.ne_id=sts3.ne_id)
                      LEFT JOIN cm_sts sts4 ON (crs.crs_sts_dest_prot=sts4.sts_aid AND crs.ne_id=sts4.ne_id)
                      LEFT JOIN cm_card crd1 ON sts2.sts_aid_shelf=crd1.card_aid_shelf AND sts2.sts_aid_slot=crd1.card_aid_slot AND crd1.card_i_parent_type='SHELF' AND sts2.ne_id=crd1.ne_id
                      LEFT JOIN cm_card crd2 ON sts4.sts_aid_shelf=crd2.card_aid_shelf AND sts4.sts_aid_slot=crd2.card_aid_slot AND crd2.card_i_parent_type='SHELF' AND sts4.ne_id=crd2.ne_id
                      LEFT JOIN cm_facility fac_from ON fac_from.fac_id=sts1.sts_parent_id
                      LEFT JOIN cm_facility fac_to ON fac_to.fac_id=sts2.sts_parent_id
                      LEFT JOIN cm_channel_och och_from ON och_from.ne_id=p_ne_id AND och_from.och_aid=replace(fac_from.fac_aid,fac_from.fac_aid_type,'OCH-P')
                      LEFT JOIN cm_channel_och och_to ON och_to.ne_id=p_ne_id AND och_to.och_aid=replace(fac_to.fac_aid,fac_to.fac_aid_type,'OCH-P')
                WHERE  ( CRS_STS_FROM_ID=p_sts_id OR CRS_STS_TO_ID=p_sts_id )
                    AND ( crs_sts_src_prot IS NOT NULL OR crs_sts_dest_prot IS NOT NULL )
          )LOOP

              IF l_sts.src_id IS NULL AND l_sts.from_port_or_line = 'Port' AND l_sts.dest_port_or_line='Line' THEN
                  addSTSConnectionToList(p_ne_id, l_sts.from_id, l_sts.dest_id, null, null); --For CNV, except for sts passthrough. compositeMap should be blank
              END IF;
              IF nvl(l_sts.from_parent_scheme,'NOTPROTECTED') = 'NOTPROTECTED' AND nvl(l_sts.from_och_parent_scheme,'NOTPROTECTED') = 'NOTPROTECTED' THEN
                  addFFPToList(p_ne_id, l_sts.from_id, l_sts.src_id);
              END IF;

              IF nvl(l_sts.to_parent_scheme,'NOTPROTECTED') = 'NOTPROTECTED' AND nvl(l_sts.to_och_parent_scheme,'NOTPROTECTED') = 'NOTPROTECTED' THEN
                  addFFPToList(p_ne_id, l_sts.to_id, l_sts.dest_id);
              END IF;
          END LOOP;
    END findPPGFromSts;

    FUNCTION findXCFromSTS(ochId IN NUMBER, neId IN NUMBER, dontFindMeId IN NUMBER, noProcess IN BOOLEAN, dontAdd IN BOOLEAN, fromCompositeMap IN VARCHAR2, toCompositeMap IN VARCHAR2, otherId OUT NUMBER, otherTimeSlot OUT VARCHAR2, otherPortORLine OUT VARCHAR) RETURN BOOLEAN IS
        v_ref_cursor                   EMS_REF_CURSOR;
        ochCount                INTEGER;
        qId                     NUMBER;
        otherNeId               NUMBER;
        dontFindMeAgainId       NUMBER;
        eqptId                  NUMBER;
        duplicateOchL           NUMBER;
        esimId                  NUMBER;
        ttpFacilityId           NUMBER;
        duplicateCheckKey       VARCHAR2(50);
        crsFromFacilityKey      VARCHAR2(100);
        crsToFacilityKey        VARCHAR2(100);
        linePort                VARCHAR2(4);
        qIdList                 IntTable;
        otherNeIdList           IntTable;
        otherOchIdList          IntTable;
        ochIdList               IntTable;
        ochFromEqptIdList       IntTable;
        ochEqptIdList           IntTable;
        ochFromPFIdList         IntTable;
        ochToPFIdList           IntTable;
        ochEqptTypeList         StringTable70;
        ochSTSAidList           StringTable70;
        ochFromSTSAidList       StringTable70;
        otherOchLocationList    StringTable70;
        xcTypeList              StringTable70;
        crsIdList               StringTable70;
        ochTimeSlotList         StringTable70;
        l_idx1                  PLS_INTEGER;
        facility_token          VARCHAR2(1) := '&';
        facilityString          VARCHAR2(200);
        ofromCompositeMap       VARCHAR2(800);
        otoCompositeMap         VARCHAR2(800);
        otnmFAC                 VARCHAR2(70);
        retVal                  BOOLEAN DEFAULT FALSE;
        sts1Map                 VARCHAR2(800);
        cardType                 VARCHAR2(20);
        ycablefac               NUMBER DEFAULT 0;
        tmpId                   NUMBER;
        tmpTimeSlot             VARCHAR2(20);
        tmpPortORLine           VARCHAR2(20);
        tmpBoolean              BOOLEAN;
    BEGIN circuit_util.print_start('findXCFromSTS');

        circuit_util.print_line('findXCFromSTS:'||ochId||', g_next_och_pos_in_next_xc:'||g_next_och_pos_in_next_xc);

        IF (g_sts_aid LIKE '%ODU1-C%') THEN
            otnmFAC :=  g_other_sts_aid;
        ELSE
            otnmFAC :=  g_sts_aid;
        END IF;

        duplicateOchL:=0;

        IF noProcess=FALSE THEN
           duplicateCheckKey := ochId ||'-'|| g_next_och_pos_in_next_xc;
           circuit_util.print_line('Checking for duplicate key: '||duplicateCheckKey);
           checkForDuplicateProcessingSTS(duplicateCheckKey, duplicateOchL);
        END IF;

        -- convert sts1map if g_sts1map has valid valid, otherwise, continue with value copy from g_sts1map
        IF LENGTH(g_sts1map) > 0 AND g_sts1map <> 'x' THEN
            sts1Map := circuit_util.convertTimeslotToVC4(g_ne_id, neId, g_sts1map);
        ELSE
            sts1Map := g_sts1map;
        END IF;

        IF duplicateOchL = 0 AND ochId <> 0 THEN
            SELECT  qId, otherNeId, thisOchId, otherOchId,ochTimeSlot,ochFromEqptId,
                    ochEqptId,ochEqptType,ochFromPFId,ochToPFId,ochFromSTSAid,
                    ochSTSAid,xcType,crsId, otherOchLocation
                BULK COLLECT INTO
                    qIdList, otherNeIdList, ochIdList, otherOchIdList,ochTimeSlotList,ochFromEqptIdList,
                    ochEqptIdList,ochEqptTypeList,ochFromPFIdList,ochToPFIdList,ochFromSTSAidList,
                    ochSTSAidList,xcTypeList,crsIdList, otherOchLocationList
              FROM (
                SELECT 1 qId, fac2.NE_ID otherNeId, fac1.sts_id thisOchId, fac2.sts_id otherOchId, fac2.STS_PORT_OR_LINE ochTimeSlot, nvl(card1.CARD_ID,0) ochFromEqptId,
                    nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochEqptId, card2.CARD_AID_TYPE ochEqptType, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochFromPFId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID) ochToPFId, fac1.STS_AID ochFromSTSAid,
                    fac2.STS_AID ochSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, 'TO' otherOchLocation
                  FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
                  WHERE crs.NE_ID=neId AND fac1.NE_ID=neId AND fac2.NE_ID=neId AND pfac1.NE_ID(+)=neId AND pfac2.NE_ID(+)=neId AND card1.NE_ID(+)=neId AND card2.NE_ID(+)=neId
                    AND fac1.STS_ID=ochId AND fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%' AND pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND
                      pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND g_next_och_pos_in_next_xc<>'TO' AND CRS_STS_FROM_ID=fac1.STS_ID AND CRS_STS_TO_ID=fac2.STS_ID AND CRS_STS_TO_ID<> dontFindMeId
                --This sql splits the XC to get CRS_STS_FROM_ID, CRS_STS_TO_ID, given CRS_STS_FROM_ID
                UNION
                SELECT 2 qId, fac2.NE_ID otherNeId, fac1.sts_id thisOchId, fac2.sts_id otherOchId, fac2.STS_PORT_OR_LINE ochTimeSlot, nvl(card1.CARD_ID,0) ochFromEqptId,
                    nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochEqptId, card2.CARD_AID_TYPE ochEqptType, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochFromPFId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID) ochToPFId, fac1.STS_AID ochFromSTSAid,
                    fac2.STS_AID ochSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, 'FROM' otherOchLocation
                  FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
                  WHERE crs.NE_ID=neId AND fac1.NE_ID=neId AND fac2.NE_ID=neId AND pfac1.NE_ID(+)=neId AND pfac2.NE_ID(+)=neId AND card1.NE_ID(+)=neId AND card2.NE_ID(+)=neId
                    AND fac1.STS_ID=ochId AND fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%' AND pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND
                      pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND g_next_och_pos_in_next_xc<>'FROM' AND CRS_STS_TO_ID=fac1.STS_ID AND CRS_STS_FROM_ID=fac2.STS_ID AND CRS_STS_FROM_ID<> dontFindMeId
                --This sql splits the XC to get CRS_STS_FROM_ID, CRS_STS_TO_ID, given CRS_STS_TO_ID
                UNION
                SELECT 3 qId, fac2.NE_ID otherNeId, fac1.STS_ID thisOchId, fac2.STS_ID otherOchId, fac2.STS_PORT_OR_LINE ochTimeSlot, nvl(card1.CARD_ID,0) ochFromEqptId,
                    nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochEqptId, card2.CARD_AID_TYPE ochEqptType, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochFromPFId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID) ochToPFId, fac1.STS_AID ochFromSTSAid,
                    fac2.STS_AID ochSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, 'TO' otherOchLocation
                  FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
                  WHERE crs.NE_ID=neId AND fac1.NE_ID=neId AND fac2.NE_ID=neId AND pfac1.NE_ID(+)=neId AND pfac2.NE_ID(+)=neId AND card1.NE_ID(+)=neId AND card2.NE_ID(+)=neId
                    AND CRS_STS_DEST_PROT_ID=ochId AND pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%'
                    AND pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND g_next_och_pos_in_next_xc<>'FROM' AND CRS_STS_FROM_ID=fac1.STS_ID AND fac1.STS_PORT_OR_LINE='Port' AND CRS_STS_TO_ID=fac2.STS_ID AND CRS_STS_FROM_ID<>dontFindMeId AND CRS_STS_TO_ID<>dontFindMeId
                --This sql splits the WAYBR to get get CRS_STS_FROM_ID, CRS_STS_TO_ID, given CRS_STS_DEST_PROT_ID
                UNION
                SELECT 4 qId, fac2.NE_ID otherNeId, fac1.STS_ID thisOchId, fac2.STS_ID otherOchId, fac2.STS_PORT_OR_LINE ochTimeSlot, nvl(card1.CARD_ID,0) ochFromEqptId,
                    nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochEqptId, card2.CARD_AID_TYPE ochEqptType, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochFromPFId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID) ochToPFId, fac1.STS_AID ochFromSTSAid,
                    fac2.STS_AID ochSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, 'TO' otherOchLocation
                  FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
                  WHERE crs.NE_ID=neId AND fac1.NE_ID=neId AND fac2.NE_ID=neId AND pfac1.NE_ID(+)=neId AND pfac2.NE_ID(+)=neId AND card1.NE_ID(+)=neId AND card2.NE_ID(+)=neId
                    AND CRS_STS_SRC_PROT_ID=ochId AND pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%'
                    AND pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND g_next_och_pos_in_next_xc<>'TO' AND CRS_STS_FROM_ID=fac1.STS_ID AND fac2.STS_PORT_OR_LINE='Port' AND CRS_STS_TO_ID=fac2.STS_ID AND CRS_STS_FROM_ID<>dontFindMeId AND CRS_STS_TO_ID<>dontFindMeId
                --This sql splits the WAYPR to get CRS_STS_FROM_ID, CRS_STS_TO_ID, given CRS_STS_SRC_PROT_ID
                UNION
                SELECT 5 qId, fac2.NE_ID otherNeId, fac1.STS_ID thisOchId, fac2.STS_ID otherOchId, fac2.STS_PORT_OR_LINE ochTimeSlot, nvl(card1.CARD_ID,0) ochFromEqptId,
                    nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochEqptId, card2.CARD_AID_TYPE ochEqptType, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochFromPFId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID) ochToPFId, fac1.STS_AID ochFromSTSAid,
                    fac2.STS_AID ochSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, 'TO' otherOchLocation
                  FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
                  WHERE crs.NE_ID=neId AND fac1.NE_ID=neId AND fac2.NE_ID=neId AND pfac1.NE_ID(+)=neId AND pfac2.NE_ID(+)=neId AND card1.NE_ID(+)=neId AND card2.NE_ID(+)=neId
                    AND fac1.STS_ID=ochId AND pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%'
                    AND pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND g_next_och_pos_in_next_xc<>'TO' AND CRS_STS_FROM_ID=fac1.STS_ID AND fac1.STS_PORT_OR_LINE='Port' AND CRS_STS_DEST_PROT_ID=fac2.STS_ID AND CRS_STS_DEST_PROT_ID<> dontFindMeId
                    AND CRS_STS_SRC_PROT_ID IS NULL
                --This sql splits the WAYBR to get CRS_STS_FROM_ID, CRS_STS_DEST_PROT_ID, given CRS_STS_FROM_ID
                UNION
                SELECT 6 qId, fac2.NE_ID otherNeId, fac1.STS_ID thisOchId, fac2.STS_ID otherOchId, fac2.STS_PORT_OR_LINE ochTimeSlot, nvl(card1.CARD_ID,0) ochFromEqptId,
                    nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochEqptId, card2.CARD_AID_TYPE ochEqptType, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochFromPFId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID) ochToPFId, fac1.STS_AID ochFromSTSAid,
                    fac2.STS_AID ochSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, 'FROM' otherOchLocation
                  FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
                  WHERE crs.NE_ID=neId AND fac1.NE_ID=neId AND fac2.NE_ID=neId AND pfac1.NE_ID(+)=neId AND pfac2.NE_ID(+)=neId AND card1.NE_ID(+)=neId AND card2.NE_ID(+)=neId
                    AND fac1.STS_ID=ochId AND pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%'
                    AND pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND g_next_och_pos_in_next_xc<>'FROM' AND CRS_STS_FROM_ID=fac2.STS_ID AND fac2.STS_PORT_OR_LINE='Port' AND CRS_STS_DEST_PROT_ID=fac1.STS_ID AND CRS_STS_FROM_ID<> dontFindMeId
                    AND CRS_STS_SRC_PROT_ID IS NULL
                --This sql splits the WAYBR to get get CRS_STS_FROM_ID, CRS_STS_DEST_PROT_ID, given CRS_STS_DEST_PROT_ID
                UNION
                SELECT 7 qId, fac2.NE_ID otherNeId, fac1.STS_ID thisOchId, fac2.STS_ID otherOchId, fac2.STS_PORT_OR_LINE ochTimeSlot, nvl(card1.CARD_ID,0) ochFromEqptId,
                    nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochEqptId, card2.CARD_AID_TYPE ochEqptType, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochFromPFId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID) ochToPFId, fac1.STS_AID ochFromSTSAid,
                    fac2.STS_AID ochSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, 'TO' otherOchLocation
                  FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
                  WHERE crs.NE_ID=neId AND fac1.NE_ID=neId AND fac2.NE_ID=neId AND pfac1.NE_ID(+)=neId AND pfac2.NE_ID(+)=neId AND card1.NE_ID(+)=neId AND card2.NE_ID(+)=neId
                    AND CRS_STS_TO_ID=ochId AND pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%'
                    AND pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND g_next_och_pos_in_next_xc<>'FROM' AND CRS_STS_FROM_ID=fac1.STS_ID AND fac1.STS_PORT_OR_LINE='Port' AND CRS_STS_DEST_PROT_ID=fac2.STS_ID AND CRS_STS_FROM_ID<> dontFindMeId
                    AND CRS_STS_SRC_PROT_ID IS NULL
                --This sql splits the WAYBR to get get CRS_STS_FROM_ID, CRS_STS_DEST_PROT_ID, given CRS_STS_TO_ID
                UNION
                SELECT 8 qId, fac2.NE_ID otherNeId, fac1.STS_ID thisOchId, fac2.STS_ID otherOchId, fac2.STS_PORT_OR_LINE ochTimeSlot, nvl(card1.CARD_ID,0) ochFromEqptId,
                    nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochEqptId, card2.CARD_AID_TYPE ochEqptType, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochFromPFId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID) ochToPFId, fac1.STS_AID ochFromSTSAid,
                    fac2.STS_AID ochSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, 'TO' otherOchLocation
                  FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
                  WHERE crs.NE_ID=neId AND fac1.NE_ID=neId AND fac2.NE_ID=neId AND pfac1.NE_ID(+)=neId AND pfac2.NE_ID(+)=neId AND card1.NE_ID(+)=neId AND card2.NE_ID(+)=neId
                    AND fac1.STS_ID=ochId AND pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%'
                    AND pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND g_next_och_pos_in_next_xc<>'TO' AND CRS_STS_SRC_PROT_ID=fac1.STS_ID AND fac1.STS_PORT_OR_LINE='Port' AND CRS_STS_TO_ID=fac2.STS_ID AND CRS_STS_TO_ID<>dontFindMeId
                    AND CRS_STS_DEST_PROT_ID IS NULL
                --This sql splits the WAYPR to get CRS_STS_SRC_PROT_ID, CRS_STS_TO_ID, given CRS_STS_SRC_PROT_ID
                UNION
                SELECT 9 qId, fac2.NE_ID otherNeId, fac1.STS_ID thisOchId, fac2.STS_ID otherOchId, fac2.STS_PORT_OR_LINE ochTimeSlot, nvl(card1.CARD_ID,0) ochFromEqptId,
                    nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochEqptId, card2.CARD_AID_TYPE ochEqptType, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochFromPFId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID) ochToPFId, fac1.STS_AID ochFromSTSAid,
                    fac2.STS_AID ochSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, 'FROM' otherOchLocation
                  FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
                  WHERE crs.NE_ID=neId AND fac1.NE_ID=neId AND fac2.NE_ID=neId AND pfac1.NE_ID(+)=neId AND pfac2.NE_ID(+)=neId AND card1.NE_ID(+)=neId AND card2.NE_ID(+)=neId
                    AND fac1.STS_ID=ochId AND pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%'
                    AND pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND g_next_och_pos_in_next_xc<>'FROM' AND CRS_STS_SRC_PROT_ID=fac2.STS_ID AND fac2.STS_PORT_OR_LINE='Port' AND CRS_STS_TO_ID=fac1.STS_ID AND CRS_STS_SRC_PROT_ID<>dontFindMeId
                    AND CRS_STS_DEST_PROT_ID IS NULL
                --This sql splits the WAYPR to get CRS_STS_SRC_PROT_ID, CRS_STS_TO_ID, given CRS_STS_TO_ID
                UNION
                SELECT 10 qId, fac2.NE_ID otherNeId, fac1.STS_ID thisOchId, fac2.STS_ID otherOchId, fac2.STS_PORT_OR_LINE ochTimeSlot, nvl(card1.CARD_ID,0) ochFromEqptId,
                    nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochEqptId, card2.CARD_AID_TYPE ochEqptType, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochFromPFId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID) ochToPFId, fac1.STS_AID ochFromSTSAid,
                    fac2.STS_AID ochSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, 'TO' otherOchLocation
                  FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
                  WHERE crs.NE_ID=neId AND fac1.NE_ID=neId AND fac2.NE_ID=neId AND pfac1.NE_ID(+)=neId AND pfac2.NE_ID(+)=neId AND card1.NE_ID(+)=neId AND card2.NE_ID(+)=neId
                    AND CRS_STS_FROM_ID=ochId AND pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%'
                    AND pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND g_next_och_pos_in_next_xc<>'TO' AND CRS_STS_SRC_PROT_ID=fac1.STS_ID AND fac2.STS_PORT_OR_LINE='Port' AND CRS_STS_TO_ID=fac2.STS_ID AND CRS_STS_SRC_PROT_ID<>dontFindMeId
                    AND CRS_STS_DEST_PROT_ID IS NULL
                --This sql splits the WAYPR to get CRS_STS_SRC_PROT_ID, CRS_STS_TO_ID, given CRS_STS_FROM_ID
                UNION
                SELECT 11 qId, fac2.NE_ID otherNeId, fac1.STS_ID thisOchId, fac2.STS_ID otherOchId, fac2.STS_PORT_OR_LINE ochTimeSlot, nvl(card1.CARD_ID,0) ochFromEqptId,
                    nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochEqptId, card2.CARD_AID_TYPE ochEqptType, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochFromPFId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID) ochToPFId, fac1.STS_AID ochFromSTSAid,
                    fac2.STS_AID ochSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, 'TO' otherOchLocation
                  FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
                  WHERE crs.NE_ID=neId AND fac1.NE_ID=neId AND fac2.NE_ID=neId AND pfac1.NE_ID(+)=neId AND pfac2.NE_ID(+)=neId AND card1.NE_ID(+)=neId AND card2.NE_ID(+)=neId
                    AND CRS_STS_FROM_ID=ochId AND pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%'
                    AND pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND g_next_och_pos_in_next_xc<>'TO' AND CRS_STS_SRC_PROT_ID=fac1.STS_ID AND fac1.STS_PORT_OR_LINE='Port' AND CRS_STS_DEST_PROT_ID=fac2.STS_ID AND CRS_STS_SRC_PROT_ID<>dontFindMeId AND CRS_STS_DEST_PROT_ID<>dontFindMeId
                --This sql splits the WAYPR to get CRS_STS_SRC_PROT, CRS_STS_DEST_PROT, given CRS_STS_FROM_ID
                UNION
                SELECT 12 qId, fac2.NE_ID otherNeId, fac1.STS_ID thisOchId, fac2.STS_ID otherOchId, fac2.STS_PORT_OR_LINE ochTimeSlot, nvl(card1.CARD_ID,0) ochFromEqptId,
                    nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochEqptId, card2.CARD_AID_TYPE ochEqptType, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochFromPFId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID) ochToPFId, fac1.STS_AID ochFromSTSAid,
                    fac2.STS_AID ochSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, 'TO' otherOchLocation
                  FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
                  WHERE crs.NE_ID=neId AND fac1.NE_ID=neId AND fac2.NE_ID=neId AND pfac1.NE_ID(+)=neId AND pfac2.NE_ID(+)=neId AND card1.NE_ID(+)=neId AND card2.NE_ID(+)=neId
                    AND CRS_STS_TO_ID=ochId AND pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%'
                    AND pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND g_next_och_pos_in_next_xc<>'FROM' AND CRS_STS_SRC_PROT_ID=fac1.STS_ID AND fac1.STS_PORT_OR_LINE='Port' AND CRS_STS_DEST_PROT_ID=fac2.STS_ID AND CRS_STS_SRC_PROT_ID<>dontFindMeId AND CRS_STS_DEST_PROT_ID<>dontFindMeId
                --This sql splits the WAYPR to get CRS_STS_SRC_PROT, CRS_STS_DEST_PROT, given CRS_STS_TO_ID
                UNION
                SELECT 13 qId, fac2.NE_ID otherNeId, fac2.STS_ID thisOchId, fac1.STS_ID otherOchId, fac1.STS_PORT_OR_LINE ochTimeSlot, nvl(card2.CARD_ID,0) ochFromEqptId,
                    nvl(card1.CARD_ID,circuit_util.getVCGCardId(fac1.STS_TTP_VCG_ID)) ochEqptId, card1.CARD_AID_TYPE ochEqptType, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID) ochFromPFId, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochToPFId, fac2.STS_AID ochFromSTSAid,
                    fac1.STS_AID ochSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, 'TO' otherOchLocation
                  FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
                  WHERE crs.NE_ID=neId AND fac1.NE_ID=neId AND fac2.NE_ID=neId AND pfac1.NE_ID(+)=neId AND pfac2.NE_ID(+)=neId AND card1.NE_ID(+)=neId AND card2.NE_ID(+)=neId AND fac2.STS_ID=ochId AND pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID
                    AND fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%' AND pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID
                    AND g_next_och_pos_in_next_xc<>'TO' AND CRS_STS_SRC_PROT_ID=fac2.STS_ID AND CRS_STS_DEST_PROT_ID=fac1.STS_ID AND CRS_STS_SRC_PROT_ID<> dontFindMeId
                --This sql splits the WAYPR to get CRS_STS_SRC_PROT, CRS_STS_DEST_PROT, given CRS_STS_SRC_PROT
                UNION
                SELECT 14 qId, fac2.NE_ID otherNeId, fac1.STS_ID thisOchId, fac2.STS_ID otherOchId, fac2.STS_PORT_OR_LINE ochTimeSlot, nvl(card1.CARD_ID,0) ochFromEqptId,
                    nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochEqptId, card2.CARD_AID_TYPE ochEqptType, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochFromPFId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID) ochToPFId, fac1.STS_AID ochFromSTSAid,
                    fac2.STS_AID ochSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, 'FROM' otherOchLocation
                  FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
                  WHERE crs.NE_ID=neId AND fac1.NE_ID=neId AND fac2.NE_ID=neId AND pfac1.NE_ID(+)=neId AND pfac2.NE_ID(+)=neId AND card1.NE_ID(+)=neId AND card2.NE_ID(+)=neId AND fac1.STS_ID=ochId AND pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID
                    AND fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%' AND pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID
                    AND crs.NE_ID=fac1.NE_ID AND fac1.NE_ID=fac2.NE_ID AND g_next_och_pos_in_next_xc<>'FROM' AND CRS_STS_SRC_PROT_ID=fac2.STS_ID AND CRS_STS_DEST_PROT_ID=fac1.STS_ID AND CRS_STS_SRC_PROT_ID<> dontFindMeId
                --This sql splits the WAYPR to get CRS_STS_SRC_PROT, CRS_STS_DEST_PROT, given CRS_STS_DEST_PROT
                UNION
                SELECT 15 qId, fac2.NE_ID otherNeId, ochId thisOchId, circuit_util.getOtherOCH(CRS_STS_FROM_ID,CRS_STS_TO_ID,ochId) otherOchId,circuit_util.getOtherOCHTimeSlot(CRS_STS_FROM_ID,CRS_STS_TO_ID,ochId) ochTimeSlot, nvl(card1.CARD_ID,0) ochFromEqptId,
                    circuit_util.getOtherOCHCard(nvl(card1.CARD_ID,circuit_util.getVCGCardId(fac1.STS_TTP_VCG_ID)),nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)),CRS_STS_FROM_ID,CRS_STS_TO_ID,ochId) ochEqptId, card1.CARD_AID_TYPE ochEqptType, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochFromPFId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID) ochToPFId, circuit_util.getOtherOCHAid(fac2.STS_AID,fac1.STS_AID,CRS_STS_TO_ID,CRS_STS_FROM_ID,ochId) ochFromSTSAid,
                    circuit_util.getOtherOCHAid(fac1.STS_AID,fac2.STS_AID,CRS_STS_FROM_ID,CRS_STS_TO_ID,ochId) ochSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, circuit_util.getOtherOCHDirection(CRS_STS_FROM_ID,CRS_STS_TO_ID,ochId) otherOchLocation
                  FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
                  WHERE crs.NE_ID=neId AND fac1.NE_ID=neId AND fac2.NE_ID=neId AND pfac1.NE_ID(+)=neId AND pfac2.NE_ID(+)=neId AND card1.NE_ID(+)=neId AND card2.NE_ID(+)=neId AND (CRS_STS_FROM_ID=ochId OR CRS_STS_TO_ID=ochId) AND
                    fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%' AND pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND
                    (g_next_och_pos_in_next_xc='FROM' OR g_next_och_pos_in_next_xc='TO') AND CRS_STS_FROM_ID=fac1.STS_ID AND CRS_STS_TO_ID=fac2.STS_ID AND CRS_STS_CCTYPE like '%2WAY%'
                --Above SQL gets all XCs in which supplied OCH can be either at 'TO' or 'FROM' location in to a 2WAY XC. This sql is needed for 2WAY XC coming from 1 WAY, in a flipped situation
                UNION
                SELECT 16 qId, fac2.NE_ID otherNeId, fac2.STS_ID thisOchId, fac1.STS_ID otherOchId, fac1.STS_PORT_OR_LINE ochTimeSlot, nvl(card2.CARD_ID,0) ochFromEqptId,
                    nvl(card1.CARD_ID,circuit_util.getVCGCardId(fac1.STS_TTP_VCG_ID)) ochEqptId, card1.CARD_AID_TYPE ochEqptType, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID) ochFromPFId, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochToPFId, fac2.STS_AID ochFromSTSAid,
                    fac1.STS_AID ochSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, 'TO' otherOchLocation
                  FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
                  WHERE crs.NE_ID=neId AND fac1.NE_ID=neId AND fac2.NE_ID=neId AND pfac1.NE_ID(+)=neId AND pfac2.NE_ID(+)=neId AND card1.NE_ID(+)=neId AND card2.NE_ID(+)=neId AND fac1.STS_ID=ochId AND pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND
                    fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%' AND pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND
                    g_next_och_pos_in_next_xc<>'FROM' AND (crs_sts_src_prot_id=fac1.sts_id OR crs_sts_dest_prot_id=fac1.sts_id) AND fac2.sts_aid_type LIKE 'TTP%' AND crs_sts_from_id=fac2.sts_id AND (crs_sts_src_prot_id<> dontFindMeId OR crs_sts_dest_prot_id<> dontFindMeId)
                ---Process the TTP Protection
                UNION
                SELECT 17 qId, fac1.NE_ID otherNeId, fac1.FAC_ID thisOchId, circuit_util.getFacilityID(fac2.NE_ID,circuit_util.getOTNMXCedLineFacility(Nvl(fac1.FAC_STS1MAP,'0'),fac1.NE_ID,card.CARD_AID)) otherOchId, '' ochTimeSlot, 0 ochFromEqptId,
                    card.CARD_ID ochEqptId, card.CARD_AID_TYPE ochEqptType, 0 ochFromPFId, 0 ochToPFId, fac1.FAC_AID ochFromSTSAid,
                    circuit_util.getOTNMXCedAllLineFacility(fac1.FAC_STS1MAP,fac1.NE_ID,card.CARD_ID,card.CARD_AID) ochSTSAid, '2WAY' xcType, '0' crsId, 'TO' otherOchLocation
                  FROM  CM_CARD card, CM_FACILITY fac1, CM_FACILITY fac2, CM_CHANNEL_OCH och, CM_CRS crs
                  WHERE card.NE_ID=neId AND fac1.NE_ID=neId AND fac2.NE_ID=neId AND och.NE_ID=neId AND crs.NE_ID=neId AND
                    fac1.FAC_ID=ochId AND card.CARD_ID = fac1.FAC_PARENT_ID AND  card.CARD_ID = fac2.FAC_PARENT_ID AND fac1.FAC_ID != fac2.FAC_ID
                    AND g_next_och_pos_in_next_xc<>'TO' AND (nvl(g_sts_discovery, 'FALSE') = 'FALSE' AND fac1.FAC_AID like '%'||substr(otnmFAC, 1, instr(otnmFAC,'-')-1) ||'%') AND
                    nvl(fac1.FAC_STS1MAP,'X') != 'X' AND nvl(fac1.FAC_STS1MAP,'X') = nvl(sts1Map, fac1.FAC_STS1MAP)  AND och.och_parent_id = fac1.FAC_PARENT_ID AND (crs.CRS_FROM_ID = och.OCH_ID OR crs.CRS_TO_ID = och.OCH_ID) AND (crs.CRS_CCPATH = 'ADD')
                --Above added for OTNM facilities - SQL gets all fake XCs plus added condition that is not coming from Discover STS so check facility type
                UNION
                SELECT 18 qId, fac1.NE_ID otherNeId, fac1.FAC_ID thisOchId, circuit_util.getFacilityID(fac2.NE_ID,circuit_util.getOTNMXCedLineFacility(Nvl(fac1.FAC_STS1MAP,'0'),fac1.NE_ID,card.CARD_AID)) otherOchId, '' ochTimeSlot, 0 ochFromEqptId,
                    card.CARD_ID ochEqptId, card.CARD_AID_TYPE ochEqptType, 0 ochFromPFId, 0 ochToPFId, fac1.FAC_AID ochFromSTSAid,
                    circuit_util.getOTNMXCedAllLineFacility(fac1.FAC_STS1MAP,fac1.NE_ID,card.CARD_ID,card.CARD_AID) ochSTSAid, '2WAY' xcType, '0' crsId, 'TO' otherOchLocation
                  FROM  CM_CARD card, CM_FACILITY fac1, CM_FACILITY fac2, CM_CHANNEL_OCH och, CM_CRS crs
                  WHERE card.NE_ID=neId AND fac1.NE_ID=neId AND fac2.NE_ID=neId AND och.NE_ID=neId AND crs.NE_ID=neId AND fac1.FAC_ID=ochId AND card.CARD_ID = fac1.FAC_PARENT_ID AND
                    card.CARD_ID = fac2.FAC_PARENT_ID AND fac1.FAC_ID != fac2.FAC_ID AND g_next_och_pos_in_next_xc<>'TO' AND nvl(g_sts_discovery, 'FALSE') = 'TRUE' AND
                    nvl(fac1.FAC_STS1MAP,'X') != 'X' AND nvl(fac1.FAC_STS1MAP,'X') = nvl(sts1Map, fac1.FAC_STS1MAP) AND och.och_parent_id = fac1.FAC_PARENT_ID AND (crs.CRS_FROM_ID = och.OCH_ID OR crs.CRS_TO_ID = och.OCH_ID) AND (crs.CRS_CCPATH = 'ADD')
                --Above added for OTNM facilities - SQL gets all fake XCs plus added condition that is coming from Discover STS so do not check facility types
                UNION
                SELECT 19 qId, fac1.NE_ID otherNeId, circuit_util.getFacilityID(fac2.NE_ID,circuit_util.getOTNMXCedLineFacility(Nvl(fac1.FAC_STS1MAP,'0'),fac1.NE_ID,card.CARD_AID)) thisOchId, fac1.FAC_ID otherOchId, '' ochTimeSlot, 0 ochFromEqptId,
                    card.CARD_ID ochEqptId, card.CARD_AID_TYPE ochEqptType, 0 ochFromPFId, 0 ochToPFId, fac1.FAC_AID ochFromSTSAid,
                    circuit_util.getOTNMXCedAllLineFacility(fac1.FAC_STS1MAP,fac1.NE_ID,card.CARD_ID,card.CARD_AID) ochSTSAid, '2WAY' xcType, '0' crsId, 'TO' otherOchLocation
                  FROM  CM_CARD card, CM_FACILITY fac1, CM_FACILITY fac2, CM_CHANNEL_OCH och, CM_CRS crs
                  WHERE card.NE_ID=neId AND fac1.NE_ID=neId AND fac2.NE_ID=neId AND och.NE_ID=neId AND crs.NE_ID=neId AND fac1.FAC_ID=ochId AND card.CARD_ID = fac1.FAC_PARENT_ID AND
                    card.CARD_ID = fac2.FAC_PARENT_ID AND fac1.FAC_ID != fac2.FAC_ID  AND g_next_och_pos_in_next_xc<>'TO' AND (nvl(g_sts_discovery, 'FALSE') = 'FALSE' AND fac1.FAC_AID like '%'||substr(otnmFAC, 1, instr(otnmFAC,'-')-1) ||'%') AND
                    nvl(fac1.FAC_STS1MAP,'X') != 'X' AND nvl(fac1.FAC_STS1MAP,'X') =  nvl(sts1Map,fac1.FAC_STS1MAP)  AND och.och_parent_id = fac1.FAC_PARENT_ID AND (crs.CRS_FROM_ID = och.OCH_ID OR crs.CRS_TO_ID = och.OCH_ID) AND (crs.CRS_CCPATH = 'DROP' OR crs.CRS_CCPATH = 'ADD/DROP')
                --Above added for OTNM facilities - SQL gets all fake XCs plus added condition that is not coming from Discover STS so check facility type
                UNION
                SELECT 20 qId, fac1.NE_ID otherNeId, circuit_util.getFacilityID(fac2.NE_ID,circuit_util.getOTNMXCedLineFacility(Nvl(fac1.FAC_STS1MAP,'0'),fac1.NE_ID,card.CARD_AID)) thisOchId, fac1.FAC_ID otherOchId, '' ochTimeSlot, 0 ochFromEqptId,
                    card.CARD_ID ochEqptId, card.CARD_AID_TYPE ochEqptType, 0 ochFromPFId, 0 ochToPFId, fac1.FAC_AID ochFromSTSAid,
                    circuit_util.getOTNMXCedAllLineFacility(fac1.FAC_STS1MAP,fac1.NE_ID,card.CARD_ID,card.CARD_AID) ochSTSAid, '2WAY' xcType, '0' crsId, 'TO' otherOchLocation
                  FROM  CM_CARD card, CM_FACILITY fac1, CM_FACILITY fac2, CM_CHANNEL_OCH och, CM_CRS crs
                  WHERE card.NE_ID=neId AND fac1.NE_ID=neId AND fac2.NE_ID=neId AND och.NE_ID=neId AND crs.NE_ID=neId AND fac1.FAC_ID=ochId AND card.CARD_ID = fac1.FAC_PARENT_ID AND
                    card.CARD_ID = fac2.FAC_PARENT_ID AND fac1.FAC_ID != fac2.FAC_ID  AND g_next_och_pos_in_next_xc<>'TO' AND nvl(g_sts_discovery, 'FALSE') = 'TRUE' AND
                    nvl(fac1.FAC_STS1MAP,'X') != 'X' AND nvl(fac1.FAC_STS1MAP,'X') =  nvl(sts1Map,fac1.FAC_STS1MAP) AND och.och_parent_id = fac1.FAC_PARENT_ID AND (crs.CRS_FROM_ID = och.OCH_ID OR crs.CRS_TO_ID = och.OCH_ID) AND (crs.CRS_CCPATH = 'DROP' OR crs.CRS_CCPATH = 'ADD/DROP')
                --Above added for OTNM facilities - SQL gets all fake XCs plus added condition that is coming from Discover STS so do not check facility types
                UNION
                SELECT 21 qId, fac2.NE_ID otherNeId, CRS_ODU_FROM_ID thisOchId, CRS_ODU_TO_ID otherOchId, fac2.FAC_PORT_OR_LINE ochTimeSlot, nvl(card1.CARD_ID,0) ochFromEqptId,
                    card2.CARD_ID ochEqptId, card2.CARD_AID_TYPE ochEqptType, pfac1.FAC_ID ochFromPFId, pfac2.OCH_ID ochToPFId, fac1.FAC_AID ochFromSTSAid,
                    fac2.FAC_AID ochSTSAid, CRS_ODU_CCTYPE xcType, CRS_ODU_CKTID crsId, 'TO' otherOchLocation
                  FROM CM_CRS_ODU crs, CM_CARD card1, CM_CARD card2, CM_FACILITY fac1, CM_FACILITY fac2, CM_FACILITY pfac1, CM_CHANNEL_OCH pfac2
                  WHERE crs.NE_ID=neId AND fac1.NE_ID=neId AND fac2.NE_ID=neId AND pfac1.NE_ID=neId AND pfac2.NE_ID=neId AND card1.NE_ID=neId AND card2.NE_ID=neId AND fac1.FAC_ID=ochId AND fac1.FAC_AID like '%'||g_sts_type||'%' AND fac2.FAC_AID like '%'||g_sts_type||'%'
                    AND pfac1.FAC_ID=fac1.FAC_PARENT_ID AND card1.CARD_ID=pfac1.FAC_PARENT_ID AND pfac2.OCH_ID=fac2.FAC_PARENT_ID AND card2.CARD_ID=pfac2.OCH_PARENT_ID
                    AND card1.CARD_AID_TYPE='FGTMM' AND card2.CARD_AID_TYPE='FGTMM' AND g_next_och_pos_in_next_xc<>'TO' AND CRS_ODU_FROM_ID=fac1.FAC_ID AND CRS_ODU_TO_ID=fac2.FAC_ID AND CRS_ODU_TO_ID<> dontFindMeId
                --Above SQL gets all FGTMM XCs in which supplied facility can be either at 'TO' or 'BOTH' location with parent facility FAC to OCH XC
                UNION
                SELECT 22 qId, fac2.NE_ID, CRS_ODU_FROM_ID thisOchId, CRS_ODU_TO_ID otherOchId, fac2.FAC_PORT_OR_LINE ochTimeSlot, nvl(card1.CARD_ID,0) ochFromEqptId,
                    card2.CARD_ID ochEqptId, card2.CARD_AID_TYPE ochEqptType, pfac1.OCH_ID ochFromPFId, pfac2.FAC_ID ochToPFId, fac1.FAC_AID ochFromSTSAid,
                    fac2.FAC_AID ochSTSAid, CRS_ODU_CCTYPE xcType, CRS_ODU_CKTID crsId, 'TO' otherOchLocation
                  FROM CM_CRS_ODU crs, CM_CARD card1, CM_CARD card2, CM_FACILITY fac1, CM_FACILITY fac2, CM_CHANNEL_OCH pfac1, CM_FACILITY pfac2
                  WHERE crs.NE_ID=neId AND fac1.NE_ID=neId AND fac2.NE_ID=neId AND pfac1.NE_ID=neId AND pfac2.NE_ID=neId AND card1.NE_ID=neId AND card2.NE_ID=neId AND fac1.FAC_ID=ochId AND fac1.FAC_AID like '%'||g_sts_type||'%' AND fac2.FAC_AID like '%'||g_sts_type||'%'
                    AND pfac1.OCH_ID=fac1.FAC_PARENT_ID AND card1.CARD_ID=pfac1.OCH_PARENT_ID AND pfac2.FAC_ID=fac2.FAC_PARENT_ID AND card2.CARD_ID=pfac2.FAC_PARENT_ID
                    AND card1.CARD_AID_TYPE='FGTMM' AND card2.CARD_AID_TYPE='FGTMM' AND g_next_och_pos_in_next_xc<>'TO' AND CRS_ODU_FROM_ID=fac1.FAC_ID AND CRS_ODU_TO_ID=fac2.FAC_ID AND CRS_ODU_TO_ID<> dontFindMeId
                --Above SQL gets all FGTMM XCs in which supplied facility can be either at 'TO' or 'BOTH' location with parent facility OCH to FAC XC
                UNION
                SELECT 23 qId, fac2.NE_ID otherNeId, CRS_ODU_TO_ID thisOchId, CRS_ODU_FROM_ID otherOchId, fac2.FAC_PORT_OR_LINE ochTimeSlot, nvl(card1.CARD_ID,0) ochFromEqptId,
                    card2.CARD_ID ochEqptId, card2.CARD_AID_TYPE ochEqptType, pfac1.FAC_ID ochFromPFId, pfac2.OCH_ID ochToPFId, fac1.FAC_AID ochFromSTSAid,
                    fac2.FAC_AID ochSTSAid, CRS_ODU_CCTYPE xcType, CRS_ODU_CKTID crsId, 'FROM' otherOchLocation
                  FROM CM_CRS_ODU crs, CM_CARD card1, CM_CARD card2, CM_FACILITY fac1, CM_FACILITY fac2, CM_FACILITY pfac1, CM_CHANNEL_OCH pfac2
                  WHERE crs.NE_ID=neId AND fac1.NE_ID=neId AND fac2.NE_ID=neId AND pfac1.NE_ID=neId AND pfac2.NE_ID=neId AND card1.NE_ID=neId AND card2.NE_ID=neId AND fac1.FAC_ID=ochId AND fac1.FAC_AID like '%'||g_sts_type||'%' AND fac2.FAC_AID like '%'||g_sts_type||'%'
                    AND pfac1.FAC_ID=fac1.FAC_PARENT_ID AND card1.CARD_ID=pfac1.FAC_PARENT_ID AND pfac2.OCH_ID=fac2.FAC_PARENT_ID AND card2.CARD_ID=pfac2.OCH_PARENT_ID
                    AND card1.CARD_AID_TYPE='FGTMM' AND card2.CARD_AID_TYPE='FGTMM' AND g_next_och_pos_in_next_xc<>'FROM' AND CRS_ODU_TO_ID=fac1.FAC_ID AND CRS_ODU_FROM_ID=fac2.FAC_ID AND CRS_ODU_FROM_ID<> dontFindMeId
                --Above SQL gets all FGTMM XCs in which supplied facility can be either at 'FROM' or 'BOTH' location with parent facility FAC to OCH
                UNION
                SELECT 24 qId, fac2.NE_ID otherNeId, CRS_ODU_TO_ID thisOchId, CRS_ODU_FROM_ID otherOchId, fac2.FAC_PORT_OR_LINE ochTimeSlot, nvl(card1.CARD_ID,0) ochFromEqptId,
                    card2.CARD_ID ochEqptId, card2.CARD_AID_TYPE ochEqptType, pfac1.OCH_ID ochFromPFId, pfac2.FAC_ID ochToPFId, fac1.FAC_AID ochFromSTSAid,
                    fac2.FAC_AID ochSTSAid, CRS_ODU_CCTYPE xcType, CRS_ODU_CKTID crsId, 'FROM' otherOchLocation
                  FROM CM_CRS_ODU crs, CM_CARD card1, CM_CARD card2, CM_FACILITY fac1, CM_FACILITY fac2, CM_CHANNEL_OCH pfac1, CM_FACILITY pfac2
                  WHERE crs.NE_ID=neId AND fac1.NE_ID=neId AND fac2.NE_ID=neId AND pfac1.NE_ID=neId AND pfac2.NE_ID=neId AND card1.NE_ID=neId AND card2.NE_ID=neId AND fac1.FAC_ID=ochId AND fac1.FAC_AID like '%'||g_sts_type||'%' AND fac2.FAC_AID like '%'||g_sts_type||'%'
                    AND pfac1.OCH_ID=fac1.FAC_PARENT_ID AND card1.CARD_ID=pfac1.OCH_PARENT_ID AND pfac2.FAC_ID=fac2.FAC_PARENT_ID AND card2.CARD_ID=pfac2.FAC_PARENT_ID
                    AND card1.CARD_AID_TYPE='FGTMM' AND card2.CARD_AID_TYPE='FGTMM' AND g_next_och_pos_in_next_xc<>'FROM' AND CRS_ODU_TO_ID=fac1.FAC_ID AND CRS_ODU_FROM_ID=fac2.FAC_ID AND CRS_ODU_FROM_ID<> dontFindMeId
            );
        IF otherOchIdList IS NOT NULL THEN
           ochCount:=otherOchIdList.COUNT;
           circuit_util.print_line('Total STS connections found: '||ochCount);
           IF circuit_util.g_log_enable THEN
              FOR i IN 1..ochCount LOOP
                 circuit_util.print_line('('||i||'):qId='||qIdList(i)||',this='||ochIdList(i)||',other='||otherOchIdList(i)||',otherLocation='||otherOchLocationList(i));
              END LOOP;
           END IF;
        END IF;
        --circuit_util.print_line('Number of OCHs Connecting to '||ochId||' ='||ochCount);

        -- get crossconnect facility data
        -- crossconnect exist in same NE, so use NE id from first element (1 based index)

        IF ochCount>0 THEN
           addFacilityToList(neId, ochId); -- just one from facility
           retVal:=TRUE;
        END IF;

        dontFindMeAgainId:=ochId;
        otherId:=0;
        otherTimeSlot:=NULL;

        FOR i IN 1..ochCount LOOP

           -- get crossconnect facility data
           IF otherOchLocationList(i)='TO' THEN
              crsFromFacilityKey := ochIdList(i);
              crsToFacilityKey := otherOchIdList(i);
              otherId:=ochIdList(i);
              facilityString := ochSTSAidList(i);
              eqptId := ochEqptIdList(i);
              linePort := ochTimeSlotList(i);
              ofromCompositeMap:=fromCompositeMap;
              otoCompositeMap:=toCompositeMap;
           ELSIF otherOchLocationList(i)='FROM' THEN
              crsFromFacilityKey := otherOchIdList(i);
              crsToFacilityKey := ochIdList(i);
              otherId:=otherOchIdList(i);
              facilityString := ochFromSTSAidList(i);
              eqptId := ochEqptIdList(i);
              linePort := ochTimeSlotList(i);
              ofromCompositeMap:=toCompositeMap;
              otoCompositeMap:=fromCompositeMap;
           END IF;
           circuit_util.print_line('('||i||'):from='||crsFromFacilityKey||',to='||crsToFacilityKey);

           addEquipmentToList(otherNeIdList(i),ochFromEqptIdList(i));

           IF noProcess=TRUE THEN
              --IF linePort='Line' THEN
                 otherTimeSlot:=SUBSTR(ochSTSAidList(i),INSTR(ochSTSAidList(i),'-',1,4)+1,3);
                 otherPortORLine:=linePort;
              --END IF;

              IF dontAdd=FALSE THEN
                 addSTSConnectionToList(otherNeIdList(i), crsFromFacilityKey, crsToFacilityKey, ofromCompositeMap, otoCompositeMap);
                 addFacilityToList(otherNeIdList(i), ochIdList(i));
                 addFacilityToList(otherNeIdList(i), otherOchIdList(i));
              ELSE
                 circuit_util.print_line('dont add CRS');
              END IF;

              circuit_util.print_line('dont process. Return');
              GOTO end_loop;
           END IF;

           -- Used for OTNM right now since the ID column is numeric and cannot store multiple ID in there - need to convert
           l_idx1 := INSTR(facilityString,facility_token);

           IF l_idx1 > 0 THEN
               LOOP
                   l_idx1 := INSTR(facilityString,facility_token);
                   IF l_idx1 > 0 THEN
                       addFacilityToList(otherNeIdList(i), circuit_util.getFacilityID(otherNeIdList(i), substr( facilityString, 0, l_idx1-1)));
                       addFacilityToList(otherNeIdList(i), ochIdList(i));

                       facilityString := SUBSTR(facilityString,l_idx1+LENGTH(facility_token));
                   ELSE
                       addFacilityToList(otherNeIdList(i), circuit_util.getFacilityID(otherNeIdList(i), facilityString));
                       addFacilityToList(otherNeIdList(i), ochIdList(i));

                       EXIT;
                   END IF;
             END LOOP;
           ELSE
                  addFacilityToList(otherNeIdList(i), ochIdList(i));
                  addFacilityToList(otherNeIdList(i), otherOchIdList(i));
           END IF;

          IF ochEqptIdList(i) >0 THEN --t71mr00182907
             addEquipmentToList(otherNeIdList(i), ochEqptIdList(i));
          END IF;

          IF ochFromEqptIdList(i) >0 THEN --t71mr00182907
             addEquipmentToList(otherNeIdList(i), ochFromEqptIdList(i));
          END IF;

          IF ochFromPFIdList(i) > 0 THEN
             addFacilityToList(otherNeIdList(i), ochFromPFIdList(i));
          END IF;
          IF ochToPFIdList(i) > 0 THEN
             addFacilityToList(otherNeIdList(i), ochToPFIdList(i));
          END IF;

           addSTSConnectionToList(otherNeIdList(i), crsFromFacilityKey, crsToFacilityKey, ofromCompositeMap, otoCompositeMap);

           getSMTMPortFFP(otherNeIdList(i), ochFromPFIdList(i));
           getSMTMPortFFP(otherNeIdList(i), ochToPFIdList(i));

           ycablefac := getSTSYcableFFP(neId, ochId);

            --to add ESIM equipment     COMMIT; facility, IVCG has been added in adding sts cc
            IF ochFromSTSAidList(i) LIKE 'TTP%' THEN
                ttpFacilityId := ochIdList(i);
            ELSIF ochSTSAidList(i) LIKE 'TTP%' THEN
                ttpFacilityId := otherOchIdList(i);
            END IF;

              OPEN v_ref_cursor FOR select CARD_ID, CARD_AID_TYPE from CM_CARD left join CM_INTERFACE on CARD_ID = INTF_PARENT_ID left join CM_STS on INTF_ID = STS_PARENT_ID where STS_ID = ttpFacilityId;
              FETCH v_ref_cursor INTO esimId,cardType;
              IF v_ref_cursor%FOUND AND cardType = 'ESIM' THEN
                  addEquipmentToList(otherNeIdList(i), esimId);
              END IF;
              CLOSE v_ref_cursor;

           --Find next XCs orientation
           IF xcTypeList(i) LIKE '%2WAY%' THEN
              IF g_next_och_pos_in_next_xc<>'BOTH' THEN
                 g_next_och_pos_in_next_xc:='BOTH';
              ELSE
                 g_next_och_pos_in_next_xc:='BOTH';
              END IF;
           ELSIF xcTypeList(i) LIKE '%1WAY%' THEN
              IF otherOchLocationList(i)='TO' THEN
                 g_next_och_pos_in_next_xc:='FROM';
              ELSIF otherOchLocationList(i)='FROM' THEN
                 -- Add to find broadcast drop
                 IF linePort='Line' THEN
                    g_next_och_pos_in_next_xc:='FROM';
                    tmpBoolean:=findXCFromSTS(otherOchIdList(i), otherNeIdList(i), ochIdList(i), TRUE, FALSE, fromCompositeMap, toCompositeMap, tmpId, tmpTimeSlot, tmpPortORLine);
                 END IF;
                 -- End add
                 g_next_och_pos_in_next_xc:='TO';
              END IF;
           END IF;

           IF linePort='Line' OR ycablefac > 0 THEN
              findOCHCircuitAndOtherSideSTS(ochSTSAidList(i), eqptId, otherNeIdList(i));
           END IF;

           <<end_loop>>
           NULL; -- this is to make the prev statement work
        END LOOP;
        END IF;
    circuit_util.print_end('findXCFromSTS');
        RETURN retVal;
    END findXCFromSTS;


    PROCEDURE findXCFromODU1(oduId IN NUMBER, thisOduPosInNextXC IN VARCHAR2, dontFindMeId IN NUMBER, circuitType IN VARCHAR) AS
        v_ref_cursor          EMS_REF_CURSOR;
        oduCount                NUMBER;
        duplicateOdu2           NUMBER;
        fromEqptId              NUMBER;
        toEqptId                NUMBER;
        nextOduPosInNextXC      VARCHAR2(20);


        duplicateCheckKey       VARCHAR2(50);
        crsFromFacilityKey      VARCHAR2(100);
        crsToFacilityKey        VARCHAR2(100);
        crsFromCPKey            VARCHAR2(100);
        crsToCPKey              VARCHAR2(100);
        neIdList                IntTable;
        oduFromEqptIdList       IntTable;
        oduToEqptIdList         IntTable;
        otherOduIdList          IntTable;
        otherOduLocationList    StringTable70;
        xcTypeList              StringTable70;
        ccOduIdList             IntTable;
        crsIdList               StringTable70;
        dontFindMeAgainId       NUMBER;
        facId                   NUMBER;
        neId                    NUMBER;
        ochpId                  NUMBER;
        otherCardId             NUMBER;
        odu1Aid                 VARCHAR2(20);
        otherOdu1Aid            VARCHAR2(20);
        ycableFacId             NUMBER;
        ycableoduId             NUMBER;
        ycableWorkingId         NUMBER;
        ycableProtectionId      NUMBER;
        odu_mapping_list V_B_STRING;
        odu_mapping_type_list V_B_STRING;
        odu_mapping_tribslot_list V_B_STRING;
        idx                     NUMBER;
        v_fiberlink             FIBERLINK_RECORD;
    BEGIN
         circuit_util.print_start('findXCFromODU1');
         circuit_util.print_line('Finding connections from ODU:' || oduId);
         duplicateCheckKey := oduId ||'-'|| thisOduPosInNextXC;
         checkForDuplicateProcessingSTS(duplicateCheckKey, duplicateOdu2);

         IF duplicateOdu2 = 0 AND oduId <> 0 THEN
            EXECUTE IMMEDIATE
               'SELECT crs.NE_ID, crs.CRS_ODU_TO_ID, fromCard.CARD_ID, toCard.CARD_ID,crs.CRS_ODU_CCTYPE, crs.CRS_ODU_FROM_ID,''TO'',crs.CRS_ODU_CKTID '||
               'FROM CM_CRS_ODU crs, CM_FACILITY fromFac, CM_FACILITY toFac, CM_CARD fromCard, CM_CARD toCard '||
               'WHERE (crs.CRS_ODU_FROM_ID ='||oduId||' OR crs.CRS_ODU_SRC_PROT_ID='||oduId||') AND (crs.CRS_ODU_CCTYPE LIKE ''2WAY%'' OR (crs.CRS_ODU_CCTYPE LIKE ''1WAY%'' AND '''||thisOduPosInNextXC||'''<>''TO'')) AND crs.CRS_ODU_TO_ID<> '||dontFindMeId||' AND crs.CRS_ODU_FROM_ID=fromFac.FAC_ID AND crs.CRS_ODU_TO_ID=toFac.FAC_ID '||
               'AND fromCard.CARD_I_PARENT_TYPE=''SHELF'' AND fromCard.NE_ID = crs.NE_ID AND fromCard.CARD_AID_SHELF = fromFac.FAC_AID_SHELF AND fromCard.CARD_AID_SLOT = fromFac.FAC_AID_SLOT '||
               'AND toCard.CARD_I_PARENT_TYPE=''SHELF'' AND toCard.NE_ID = crs.NE_ID AND toCard.CARD_AID_SHELF = toFac.FAC_AID_SHELF AND toCard.CARD_AID_SLOT = toFac.FAC_AID_SLOT '||
               /*FROM-TO*/
               ' UNION '||
               /*TO-FROM*/
               'SELECT crs.NE_ID, crs.CRS_ODU_FROM_ID, fromCard.CARD_ID, toCard.CARD_ID, crs.CRS_ODU_CCTYPE, crs.CRS_ODU_TO_ID,''FROM'',crs.CRS_ODU_CKTID '||
               'FROM CM_CRS_ODU crs, CM_FACILITY fromFac, CM_FACILITY toFac, CM_CARD fromCard, CM_CARD toCard  '||
               'WHERE (crs.CRS_ODU_TO_ID ='||oduId||' OR crs.CRS_ODU_DEST_PROT_ID='||oduId||') AND (('''||thisOduPosInNextXC||'''<>''FROM'' AND crs.CRS_ODU_CCTYPE LIKE ''1WAY%'') OR crs.CRS_ODU_CCTYPE LIKE ''2WAY%'') AND crs.CRS_ODU_FROM_ID<> '||dontFindMeId||' AND crs.CRS_ODU_FROM_ID=fromFac.FAC_ID AND crs.CRS_ODU_TO_ID=toFac.FAC_ID '||
               'AND fromCard.CARD_I_PARENT_TYPE=''SHELF'' AND fromCard.NE_ID = crs.NE_ID AND fromCard.CARD_AID_SHELF = fromFac.FAC_AID_SHELF AND fromCard.CARD_AID_SLOT = fromFac.FAC_AID_SLOT '||
               'AND toCard.CARD_I_PARENT_TYPE=''SHELF'' AND toCard.NE_ID = crs.NE_ID AND toCard.CARD_AID_SHELF = toFac.FAC_AID_SHELF AND toCard.CARD_AID_SLOT = toFac.FAC_AID_SLOT '||
               ' UNION '||
               /*FROM-DEST*/
               'SELECT crs.NE_ID, crs.CRS_ODU_DEST_PROT_ID, fromCard.CARD_ID, toCard.CARD_ID,crs.CRS_ODU_CCTYPE, crs.CRS_ODU_FROM_ID,''TO'',crs.CRS_ODU_CKTID '||
               'FROM CM_CRS_ODU crs, CM_FACILITY fromFac, CM_FACILITY toFac, CM_CARD fromCard, CM_CARD toCard '||
               'WHERE crs.CRS_ODU_FROM_ID ='||oduId||' AND (crs.CRS_ODU_CCTYPE LIKE ''2WAY%'' OR (crs.CRS_ODU_CCTYPE LIKE ''1WAY%'' AND '''||thisOduPosInNextXC||'''<>''TO'')) AND crs.CRS_ODU_DEST_PROT_ID<> '||dontFindMeId||' AND crs.CRS_ODU_FROM_ID=fromFac.FAC_ID AND crs.CRS_ODU_DEST_PROT_ID=toFac.FAC_ID '||
               'AND fromCard.CARD_I_PARENT_TYPE=''SHELF'' AND fromCard.NE_ID = crs.NE_ID AND fromCard.CARD_AID_SHELF = fromFac.FAC_AID_SHELF AND fromCard.CARD_AID_SLOT = fromFac.FAC_AID_SLOT '||
               'AND toCard.CARD_I_PARENT_TYPE=''SHELF'' AND toCard.NE_ID = crs.NE_ID AND toCard.CARD_AID_SHELF = toFac.FAC_AID_SHELF AND toCard.CARD_AID_SLOT = toFac.FAC_AID_SLOT '||
               'AND crs.CRS_ODU_SRC_PROT_ID IS NULL AND crs.CRS_ODU_DEST_PROT_ID IS NOT NULL'||
               ' UNION '||
               /*SRC-TO*/
               'SELECT crs.NE_ID, crs.CRS_ODU_TO_ID, fromCard.CARD_ID, toCard.CARD_ID,crs.CRS_ODU_CCTYPE, crs.CRS_ODU_SRC_PROT_ID,''TO'',crs.CRS_ODU_CKTID '||
               'FROM CM_CRS_ODU crs, CM_FACILITY fromFac, CM_FACILITY toFac, CM_CARD fromCard, CM_CARD toCard '||
               'WHERE (crs.CRS_ODU_FROM_ID ='||oduId||' OR crs.CRS_ODU_SRC_PROT_ID='||oduId||') AND (crs.CRS_ODU_CCTYPE LIKE ''2WAY%'' OR (crs.CRS_ODU_CCTYPE LIKE ''1WAY%'' AND '''||thisOduPosInNextXC||'''<>''TO'')) AND crs.CRS_ODU_TO_ID<> '||dontFindMeId||' AND crs.CRS_ODU_SRC_PROT_ID=fromFac.FAC_ID AND crs.CRS_ODU_TO_ID=toFac.FAC_ID '||
               'AND fromCard.CARD_I_PARENT_TYPE=''SHELF'' AND fromCard.NE_ID = crs.NE_ID AND fromCard.CARD_AID_SHELF = fromFac.FAC_AID_SHELF AND fromCard.CARD_AID_SLOT = fromFac.FAC_AID_SLOT '||
               'AND toCard.CARD_I_PARENT_TYPE=''SHELF'' AND toCard.NE_ID = crs.NE_ID AND toCard.CARD_AID_SHELF = toFac.FAC_AID_SHELF AND toCard.CARD_AID_SLOT = toFac.FAC_AID_SLOT '||
               'AND crs.CRS_ODU_SRC_PROT_ID IS NOT NULL AND crs.CRS_ODU_DEST_PROT_ID IS NULL'||
               ' UNION '||
               /*SRC-DEST*/
               'SELECT crs.NE_ID, crs.CRS_ODU_DEST_PROT_ID, fromCard.CARD_ID, toCard.CARD_ID,crs.CRS_ODU_CCTYPE, crs.CRS_ODU_SRC_PROT_ID,''TO'',crs.CRS_ODU_CKTID '||
               'FROM CM_CRS_ODU crs, CM_FACILITY fromFac, CM_FACILITY toFac, CM_CARD fromCard, CM_CARD toCard '||
               'WHERE (crs.CRS_ODU_FROM_ID ='||oduId||' OR crs.CRS_ODU_SRC_PROT_ID='||oduId||') AND (crs.CRS_ODU_CCTYPE LIKE ''2WAY%'' OR (crs.CRS_ODU_CCTYPE LIKE ''1WAY%'' AND '''||thisOduPosInNextXC||'''<>''TO'')) AND crs.CRS_ODU_DEST_PROT_ID<> '||dontFindMeId||' AND crs.CRS_ODU_SRC_PROT_ID=fromFac.FAC_ID AND crs.CRS_ODU_DEST_PROT_ID=toFac.FAC_ID '||
               'AND fromCard.CARD_I_PARENT_TYPE=''SHELF'' AND fromCard.NE_ID = crs.NE_ID AND fromCard.CARD_AID_SHELF = fromFac.FAC_AID_SHELF AND fromCard.CARD_AID_SLOT = fromFac.FAC_AID_SLOT '||
               'AND toCard.CARD_I_PARENT_TYPE=''SHELF'' AND toCard.NE_ID = crs.NE_ID AND toCard.CARD_AID_SHELF = toFac.FAC_AID_SHELF AND toCard.CARD_AID_SLOT = toFac.FAC_AID_SLOT '||
               'AND crs.CRS_ODU_SRC_PROT_ID IS NOT NULL AND crs.CRS_ODU_DEST_PROT_ID IS NOT NULL'||
               ' UNION '||
               /*TO - SRC*/
               'SELECT crs.NE_ID, crs.CRS_ODU_SRC_PROT_ID, fromCard.CARD_ID, toCard.CARD_ID, crs.CRS_ODU_CCTYPE, crs.CRS_ODU_TO_ID,''FROM'',crs.CRS_ODU_CKTID '||
               'FROM CM_CRS_ODU crs, CM_FACILITY fromFac, CM_FACILITY toFac, CM_CARD fromCard, CM_CARD toCard  '||
               'WHERE crs.CRS_ODU_TO_ID ='||oduId||' AND (('''||thisOduPosInNextXC||'''<>''FROM'' AND crs.CRS_ODU_CCTYPE LIKE ''1WAY%'') OR crs.CRS_ODU_CCTYPE LIKE ''2WAY%'') AND crs.CRS_ODU_SRC_PROT_ID<> '||dontFindMeId||' AND crs.CRS_ODU_SRC_PROT_ID=fromFac.FAC_ID AND crs.CRS_ODU_TO_ID=toFac.FAC_ID '||
               'AND fromCard.CARD_I_PARENT_TYPE=''SHELF'' AND fromCard.NE_ID = crs.NE_ID AND fromCard.CARD_AID_SHELF = fromFac.FAC_AID_SHELF AND fromCard.CARD_AID_SLOT = fromFac.FAC_AID_SLOT '||
               'AND toCard.CARD_I_PARENT_TYPE=''SHELF'' AND toCard.NE_ID = crs.NE_ID AND toCard.CARD_AID_SHELF = toFac.FAC_AID_SHELF AND toCard.CARD_AID_SLOT = toFac.FAC_AID_SLOT '||
               'AND crs.CRS_ODU_SRC_PROT_ID IS NOT NULL AND crs.CRS_ODU_DEST_PROT_ID IS NULL'||
               ' UNION '||
               /*DEST - FROM*/
               'SELECT crs.NE_ID, crs.CRS_ODU_FROM_ID, fromCard.CARD_ID, toCard.CARD_ID, crs.CRS_ODU_CCTYPE, crs.CRS_ODU_DEST_PROT_ID,''FROM'',crs.CRS_ODU_CKTID '||
               'FROM CM_CRS_ODU crs, CM_FACILITY fromFac, CM_FACILITY toFac, CM_CARD fromCard, CM_CARD toCard  '||
               'WHERE (crs.CRS_ODU_TO_ID ='||oduId||' OR crs.CRS_ODU_DEST_PROT_ID ='||oduId||') AND (('''||thisOduPosInNextXC||'''<>''FROM'' AND crs.CRS_ODU_CCTYPE LIKE ''1WAY%'') OR crs.CRS_ODU_CCTYPE LIKE ''2WAY%'') AND crs.CRS_ODU_FROM_ID<> '||dontFindMeId||' AND crs.CRS_ODU_FROM_ID=fromFac.FAC_ID AND crs.CRS_ODU_DEST_PROT_ID=toFac.FAC_ID '||
               'AND fromCard.CARD_I_PARENT_TYPE=''SHELF'' AND fromCard.NE_ID = crs.NE_ID AND fromCard.CARD_AID_SHELF = fromFac.FAC_AID_SHELF AND fromCard.CARD_AID_SLOT = fromFac.FAC_AID_SLOT '||
               'AND toCard.CARD_I_PARENT_TYPE=''SHELF'' AND toCard.NE_ID = crs.NE_ID AND toCard.CARD_AID_SHELF = toFac.FAC_AID_SHELF AND toCard.CARD_AID_SLOT = toFac.FAC_AID_SLOT '||
               'AND crs.CRS_ODU_SRC_PROT_ID IS NULL AND crs.CRS_ODU_DEST_PROT_ID IS NOT NULL'||
               ' UNION '||
               /*DEST - SRC*/
               'SELECT crs.NE_ID, crs.CRS_ODU_SRC_PROT_ID, fromCard.CARD_ID, toCard.CARD_ID, crs.CRS_ODU_CCTYPE, crs.CRS_ODU_DEST_PROT_ID,''FROM'',crs.CRS_ODU_CKTID '||
               'FROM CM_CRS_ODU crs, CM_FACILITY fromFac, CM_FACILITY toFac, CM_CARD fromCard, CM_CARD toCard  '||
               'WHERE (crs.CRS_ODU_TO_ID ='||oduId||' OR crs.CRS_ODU_DEST_PROT_ID ='||oduId||') AND (('''||thisOduPosInNextXC||'''<>''FROM'' AND crs.CRS_ODU_CCTYPE LIKE ''1WAY%'') OR crs.CRS_ODU_CCTYPE LIKE ''2WAY%'') AND crs.CRS_ODU_SRC_PROT_ID<> '||dontFindMeId||' AND crs.CRS_ODU_SRC_PROT_ID=fromFac.FAC_ID AND crs.CRS_ODU_DEST_PROT_ID=toFac.FAC_ID '||
               'AND fromCard.CARD_I_PARENT_TYPE=''SHELF'' AND fromCard.NE_ID = crs.NE_ID AND fromCard.CARD_AID_SHELF = fromFac.FAC_AID_SHELF AND fromCard.CARD_AID_SLOT = fromFac.FAC_AID_SLOT '||
               'AND toCard.CARD_I_PARENT_TYPE=''SHELF'' AND toCard.NE_ID = crs.NE_ID AND toCard.CARD_AID_SHELF = toFac.FAC_AID_SHELF AND toCard.CARD_AID_SLOT = toFac.FAC_AID_SLOT '||
               'AND crs.CRS_ODU_SRC_PROT_ID IS NOT NULL AND crs.CRS_ODU_DEST_PROT_ID IS NOT NULL'

            BULK COLLECT INTO neIdList,otherOduIdList,oduFromEqptIdList,oduToEqptIdList,xcTypeList,ccOduIdList,otherOduLocationList,crsIdList;

            IF oduFromEqptIdList IS NOT NULL THEN
               oduCount:=oduFromEqptIdList.COUNT;
               circuit_util.print_line('Total ODU connections found2: '||oduCount);
            END IF;

            IF oduCount >= 1 THEN
               addFacilityToList(neIdList(1), oduId); -- just one from facility
            END IF;

            dontFindMeAgainId:=oduId;
            FOR i IN 1..oduCount LOOP
               fromEqptId := oduFromEqptIdList(i);
               toEqptId := oduToEqptIdList(i);

               -- get crossconnect facility data
               IF otherOduLocationList(i)='TO' THEN
                  crsFromFacilityKey := ccOduIdList(i);
                  crsToFacilityKey := otherOduIdList(i);
                  otherCardId := toEqptId;
               ELSIF otherOduLocationList(i)='FROM' THEN
                  crsFromFacilityKey := otherOduIdList(i);
                  crsToFacilityKey := ccOduIdList(i);
                  otherCardId := fromEqptId;
               END IF;

               addFacilityToList(neIdList(i), otherOduIdList(i)); -- crs_to_id
               addFacilityToList(neIdList(i), ccOduIdList(i)); --for WAYPR

               -- get crossconnect fromcp/tocp equipment/fiber data
               crsFromCPKey := fromEqptId;
               addEquipmentToList(neIdList(i),fromEqptId);
               crsToCPKey := toEqptId;
               addEquipmentToList(neIdList(i),toEqptId);

               addSTSConnectionToList(neIdList(i), crsFromFacilityKey, crsToFacilityKey, NULL, NULL);

               addOSMSNCFFP(neIdList(i),crsFromFacilityKey);
               addOSMSNCFFP(neIdList(i),crsToFacilityKey);

               -- to add far-end facility
               facId := circuit_util.getMappingFacFromOdu(g_ne_idx, g_sts_id);
               IF facId <> 0 THEN
                   circuit_util.print_line('OCH Circuit terminated at client facility');
                   addFacilityToList(g_ne_idx, facId);
               END IF;

               facId := circuit_util.getMappingFacFromOdu(neIdList(i), otherOduIdList(i));
               IF facId <> 0 THEN
                   -- If it is a OTUx, may have a fiber link
                   odu1Aid := circuit_util.getFacAidById(facId);
                   if odu1Aid like 'OTU%' then
                     ochpId := findFiberLinkFromOCH(facId, 'BOTH', 0, 'TRY_TO_FIND', v_fiberlink);
                   else
                     ochpId := -1;
                   end if;
                   if ochpId >0 then
                      ochpId := findXCFromOCHX(facId, 'BOTH', 0, circuitType);
                   elsif ochpId < 0 then
                      circuit_util.print_line('OCH Circuit terminated at client facility');
                      addFacilityToList(neIdList(i), facId);
                      OPEN v_ref_cursor FOR SELECT FAC_WORKINGID,FAC_PROTECTIONID,CASE WHEN FAC_WORKINGID = facId THEN FAC_PROTECTIONID WHEN FAC_PROTECTIONID = facId THEN FAC_WORKINGID END
                        FROM CM_FACILITY WHERE FAC_ID = facId AND FAC_SCHEME = 'YCABLE';
                      FETCH v_ref_cursor INTO ycableWorkingId,ycableProtectionId,ycableFacId;
                      CLOSE v_ref_cursor;
                      IF ycableFacId > 0 THEN
                        addFFPToList(neIdList(i),ycableWorkingId,ycableProtectionId);
                        OPEN v_ref_cursor FOR SELECT o.Fac_Id FROM CM_FACILITY f, CM_FACILITY o
                        WHERE f.Fac_Id = ycableFacId AND f.NE_ID = o.NE_ID AND f.fac_id<>o.fac_id AND o.fac_aid_type LIKE 'ODU%'
                        AND circuit_util.trimAidType(f.fac_aid) = circuit_util.trimAidType(o.fac_aid);
                        FETCH v_ref_cursor INTO ycableoduId;
                        CLOSE v_ref_cursor;
                        IF ycableoduId > 0 THEN
                           findXCFromODU1(ycableoduId, nextOduPosInNextXC, 0, circuitType);
                        END IF;
                      END IF;
                   end if;
               ELSE
                  /*facId := circuit_util.getMappingOdu2FromOdu1(neIdList(i), otherOduIdList(i), odu0_tribslot, odu1_tribslot, odu2_tribslot, middleOduList);
                   IF (odu0_tribslot IS NOT NULL AND odu0_tribslot<>'0') THEN
                       g_odu_tribslots(1) := odu0_tribslot;
                   END IF;
                   IF (odu1_tribslot IS NOT NULL AND odu1_tribslot<>'0') THEN
                       g_odu_tribslots(2) := odu1_tribslot;
                   END IF;
                   IF (odu2_tribslot IS NOT NULL AND odu2_tribslot<>'0') THEN
                       g_odu_tribslots(3) := odu2_tribslot;
                   END IF;
                  IF middleOduList IS NOT NULL THEN
                     FOR j IN 1..middleOduList.COUNT LOOP
                        addFacilityToList(neIdList(i), middleOduList(j));
                     END LOOP;
                  END IF; */
                  facId := circuit_util.getTopMappingOduFromLower(neIdList(i), otherOduIdList(i), odu_mapping_list, odu_mapping_type_list, odu_mapping_tribslot_list);
                  IF facId<>0 THEN
                    IF odu_mapping_list.count>1 THEN
                       FOR i IN 1..odu_mapping_list.COUNT LOOP
                           addFacilityToList(neId, odu_mapping_list(i));
                           if odu_mapping_tribslot_list(i) is not null then
                              idx := circuit_util.getOduLayer(odu_mapping_type_list(i));
                              g_odu_tribslots(idx+1) := odu_mapping_tribslot_list(i);
                           end if;
                       END LOOP;
                       OPEN v_ref_cursor FOR SELECT FAC_AID FROM CM_FACILITY WHERE NE_ID = neIdList(i) AND FAC_ID = otherOduIdList(i);
                       FETCH v_ref_cursor INTO otherOdu1Aid;
                       CLOSE v_ref_cursor;
                       -- to make composite link
                       g_odu_table(circuit_util.getOduLayer(otherOdu1Aid)).ne_id := neIdList(i);
                       g_odu_table(circuit_util.getOduLayer(otherOdu1Aid)).odu_id := otherOduIdList(i);
                       g_odu_table(circuit_util.getOduLayer(otherOdu1Aid)).odu_aid := otherOdu1Aid;
                       IF g_sts_aid IS NULL OR
                          circuit_util.getFacAidType(g_sts_aid)=circuit_util.getFacAidType(otherOdu1Aid) THEN
                          g_ne_idx:=neIdList(i);
                          g_sts_aid:=otherOdu1Aid;
                       END IF;
                    END IF;

                    IF circuit_util.getFacCardType(otherOduIdList(i)) IN ('HGTMM','HGTMMS','OSM2C') THEN
                      ochpId := circuit_util.getMappingOchPFromOdu(neIdList(i),facId);
                      if ochpId <> 0 then
                         addFacilityToList(neIdList(i), ochpId);
                         ochpId := findXCFromOCHX(ochpId, 'BOTH', 0, circuitType);
                      end if;
                    ELSE
                      OPEN v_ref_cursor FOR select FAC_AID from CM_FACILITY where FAC_ID = otherOduIdList(i);
                      FETCH v_ref_cursor INTO odu1Aid;
                      CLOSE v_ref_cursor;
                      addFacilityToList(neIdList(i), facId);
                      findOCHCircuitAndOtherSideSTS(odu1Aid, otherCardId, neIdList(i));
                    END IF;

                  END IF;
               END IF;

               --for WAYPR
               IF xcTypeList(i) LIKE '%WAYPR%' AND dontFindMeAgainId != ccOduIdList(i) THEN
                 facId := circuit_util.getMappingFacFromOdu(neIdList(i), ccOduIdList(i));
                 IF facId <> 0 THEN
                     circuit_util.print_line('OCH Circuit terminated at client facility');
                     addFacilityToList(neIdList(i), facId);
                     OPEN v_ref_cursor FOR SELECT FAC_WORKINGID,FAC_PROTECTIONID,CASE WHEN FAC_WORKINGID = facId THEN FAC_PROTECTIONID WHEN FAC_PROTECTIONID = facId THEN FAC_WORKINGID END
                        FROM CM_FACILITY WHERE FAC_ID = facId AND FAC_SCHEME = 'YCABLE';
                     FETCH v_ref_cursor INTO ycableWorkingId,ycableProtectionId,ycableFacId;
                     CLOSE v_ref_cursor;
                     IF ycableFacId > 0 THEN
                        addFFPToList(neIdList(i),ycableWorkingId,ycableProtectionId);
                        OPEN v_ref_cursor FOR SELECT o.Fac_Id FROM CM_FACILITY f, CM_FACILITY o
                        WHERE f.Fac_Id = ycableFacId AND f.NE_ID = o.NE_ID AND f.fac_id<>o.fac_id AND o.fac_aid_type LIKE 'ODU%'
                        AND circuit_util.trimAidType(f.fac_aid) = circuit_util.trimAidType(o.fac_aid) ;
                        FETCH v_ref_cursor INTO ycableoduId;
                        CLOSE v_ref_cursor;
                        IF ycableoduId > 0 THEN
                           findXCFromODU1(ycableoduId, nextOduPosInNextXC, 0, circuitType);
                        END IF;
                     END IF;
                 ELSE
                    /*facId := circuit_util.getMappingOdu2FromOdu1(neIdList(i), ccOduIdList(i), odu0_tribslot, odu1_tribslot, odu2_tribslot, middleOduList);
                     IF (odu0_tribslot IS NOT NULL AND odu0_tribslot<>'0') THEN
                         g_odu_tribslots(1) := odu0_tribslot;
                     END IF;
                     IF (odu1_tribslot IS NOT NULL AND odu1_tribslot<>'0') THEN
                         g_odu_tribslots(2) := odu1_tribslot;
                     END IF;
                     IF (odu2_tribslot IS NOT NULL AND odu2_tribslot<>'0') THEN
                         g_odu_tribslots(3) := odu2_tribslot;
                     END IF;
                    IF middleOduList IS NOT NULL THEN
                       FOR j IN 1..middleOduList.COUNT LOOP
                          addFacilityToList(neIdList(i), middleOduList(j));
                       END LOOP;
                    END IF;*/
                    facId := circuit_util.getTopMappingOduFromLower(neIdList(i), ccOduIdList(i), odu_mapping_list, odu_mapping_type_list, odu_mapping_tribslot_list);
                    IF facId<>0 THEN
                      IF odu_mapping_list.count>1 THEN
                         FOR i IN 1..odu_mapping_list.COUNT LOOP
                             addFacilityToList(neId, odu_mapping_list(i));
                             if odu_mapping_tribslot_list(i) is not null then
                                idx := circuit_util.getOduLayer(odu_mapping_type_list(i));
                                g_odu_tribslots(idx+1) := odu_mapping_tribslot_list(i);
                             end if;
                          END LOOP;
                          OPEN v_ref_cursor FOR SELECT FAC_AID FROM CM_FACILITY WHERE NE_ID = neIdList(i) AND FAC_ID = ccOduIdList(i);
                          FETCH v_ref_cursor INTO otherOdu1Aid;
                          CLOSE v_ref_cursor;
                          -- to make composite link
                           g_odu_table(circuit_util.getOduLayer(otherOdu1Aid)).ne_id := neIdList(i);
                           g_odu_table(circuit_util.getOduLayer(otherOdu1Aid)).odu_id := ccOduIdList(i);
                           g_odu_table(circuit_util.getOduLayer(otherOdu1Aid)).odu_aid := otherOdu1Aid;
                           IF g_sts_aid IS NULL OR
                             circuit_util.getFacAidType(g_sts_aid)=circuit_util.getFacAidType(otherOdu1Aid)
                           THEN
                             g_ne_idx:=neIdList(i);
                             g_sts_aid:=otherOdu1Aid;
                           END IF;
                       END IF;

                       IF circuit_util.getFacCardType(ccOduIdList(i)) in ('HGTMM','HGTMMS','OSM2C') THEN
                          ochpId := circuit_util.getMappingOchPFromOdu(neIdList(i),facId);
                          if ochpId <> 0 then
                             addFacilityToList(neIdList(i), ochpId);
                             ochpId := findXCFromOCHX(ochpId, 'BOTH', 0, circuitType);
                          end if;
                        ELSE
                           OPEN v_ref_cursor FOR select FAC_AID from CM_FACILITY where FAC_ID = ccOduIdList(i);
                           FETCH v_ref_cursor INTO odu1Aid;
                           CLOSE v_ref_cursor;
                           addFacilityToList(neIdList(i), facId);
                           findOCHCircuitAndOtherSideSTS(odu1Aid, otherCardId, neIdList(i));
                        END IF;
                    END IF;
                 END IF;
               END IF;

            END LOOP;
         END IF;
        circuit_util.print_end('findXCFromODU1');
     END findXCFromODU1;

    PROCEDURE findXCFromODU2(oduId IN NUMBER, thisOduPosInNextXC IN VARCHAR2, dontFindMeId IN NUMBER, circuitType IN VARCHAR) AS
        v_ref_cursor            EMS_REF_CURSOR;
        oduCount                NUMBER;
        duplicateOdu2           NUMBER;
        fromEqptId              NUMBER;
        toEqptId                NUMBER;
        nextOduPosInNextXC      VARCHAR2(20);
        duplicateCheckKey       VARCHAR2(50);
        crsFromFacilityKey      VARCHAR2(100);
        crsToFacilityKey        VARCHAR2(100);
        crsFromCPKey            VARCHAR2(100);
        crsToCPKey              VARCHAR2(100);
        neIdList                IntTable;
        oduFromEqptIdList       IntTable;
        oduToEqptIdList         IntTable;
        otherOduIdList          IntTable;
        otherOduLocationList    StringTable70;
        xcTypeList              StringTable70;
        ccOduIdList             IntTable;
        crsIdList               StringTable70;
        dontFindMeAgainId       NUMBER;
        otherOchPId             NUMBER;
        facId                   NUMBER;
        neId                    NUMBER;
        odu2Id                  NUMBER;
        odu1Id                  NUMBER;
        otherOdu1Id             NUMBER;
        ochpId                  NUMBER;
        compFlag                BOOLEAN;
        dwdmSideFrom            VARCHAR2(50);
        dwdmSideTo              VARCHAR2(50);
        otherodu1Aid            VARCHAR2(20);
        ycableFacId             NUMBER;
        ycableoduId             NUMBER;
        ycableWorkingId         NUMBER;
        ycableProtectionId      NUMBER;
        middleOduList           V_B_STRING;
        otherMiddleOduList      V_B_STRING;
        tribslotList            V_B_STRING;
        matchedOduAid           VARCHAR2(20);
        oduLayer                PLS_INTEGER;
        odu_mapping_list        V_B_STRING;
        odu_mapping_type_list   V_B_STRING;
        odu_mapping_tribslot_list V_B_STRING;
        ochOduId                  NUMBER;
        idx                       NUMBER;

        v_sql VARCHAR2(32767);
        v_last_hop_och_id       NUMBER;
        v_fiberlink             FIBERLINK_RECORD;
     BEGIN
         circuit_util.print_start('findXCFromODU2');
         circuit_util.print_line('Finding connections from ODU:' || oduId);
         duplicateCheckKey := oduId ||'-'|| thisOduPosInNextXC;
         checkForDuplicateProcessing(duplicateCheckKey, duplicateOdu2);

         IF duplicateOdu2 = 0 AND oduId <> 0 THEN
            v_sql :=
               'SELECT crs.NE_ID, crs.CRS_ODU_TO_ID, circuit_util.getFacilityCardId(fromFac.FAC_PARENT_ID,fromFac.fac_i_parent_type), circuit_util.getFacilityCardId(toFac.FAC_PARENT_ID,toFac.fac_i_parent_type),crs.CRS_ODU_CCTYPE, crs.CRS_ODU_FROM_ID,''TO'',crs.CRS_ODU_CKTID '||
               'FROM CM_CRS_ODU crs, CM_FACILITY fromFac, CM_FACILITY toFac '||
               'WHERE '''||thisOduPosInNextXC||'''<>''TO'' AND crs.CRS_ODU_FROM_ID ='||oduId||' AND crs.CRS_ODU_TO_ID<> '||dontFindMeId||' AND crs.CRS_ODU_CCTYPE LIKE ''1WAY%'' AND crs.CRS_ODU_FROM_ID=fromFac.FAC_ID AND crs.CRS_ODU_TO_ID=toFac.FAC_ID '||
               /*Above SQL gets all XCs in which supplied OCH can be at 'FROM' location in 1WAY FROM 1 to 1 XC*/
               'UNION '||
               /*Following SQL gets all XCs in which supplied OCH can be at 'TO' location in 1WAY TO 1 to 1 XC*/
               'SELECT crs.NE_ID, crs.CRS_ODU_FROM_ID, circuit_util.getFacilityCardId(fromFac.FAC_PARENT_ID,fromFac.fac_i_parent_type), circuit_util.getFacilityCardId(toFac.FAC_PARENT_ID,toFac.fac_i_parent_type), crs.CRS_ODU_CCTYPE, crs.CRS_ODU_TO_ID,''FROM'',crs.CRS_ODU_CKTID '||
               'FROM CM_CRS_ODU crs, CM_FACILITY fromFac, CM_FACILITY toFac '||
               'WHERE '''||thisOduPosInNextXC||'''<>''FROM'' AND crs.CRS_ODU_TO_ID ='||oduId||' AND crs.CRS_ODU_FROM_ID<> '||dontFindMeId||' AND crs.CRS_ODU_CCTYPE LIKE ''1WAY%'' AND crs.CRS_ODU_FROM_ID=fromFac.FAC_ID AND crs.CRS_ODU_TO_ID=toFac.FAC_ID '||
               'UNION '||
               'SELECT crs.NE_ID, crs.CRS_ODU_TO_ID, circuit_util.getFacilityCardId(fromFac.FAC_PARENT_ID,fromFac.fac_i_parent_type), circuit_util.getFacilityCardId(toFac.FAC_PARENT_ID,toFac.fac_i_parent_type),crs.CRS_ODU_CCTYPE, CRS_ODU_FROM_ID,''TO'',crs.CRS_ODU_CKTID '||
               'FROM CM_CRS_ODU crs, CM_FACILITY fromFac, CM_FACILITY toFac '||
               'WHERE crs.CRS_ODU_FROM_ID ='||oduId||' AND crs.CRS_ODU_TO_ID<> '||dontFindMeId||' AND crs.CRS_ODU_CCTYPE LIKE ''2WAY%'' AND crs.CRS_ODU_FROM_ID=fromFac.FAC_ID AND crs.CRS_ODU_TO_ID=toFac.FAC_ID '||
               /*Above SQL gets all XCs in which supplied OCH can be at 'FROM' location in 1WAY FROM 1 to 1 XC*/
               'UNION '||
               /*Following SQL gets all XCs in which supplied OCH can be at 'TO' location in 1WAY TO 1 to 1 XC*/
               'SELECT crs.NE_ID, crs.CRS_ODU_FROM_ID, circuit_util.getFacilityCardId(fromFac.FAC_PARENT_ID,fromFac.fac_i_parent_type), circuit_util.getFacilityCardId(toFac.FAC_PARENT_ID,toFac.fac_i_parent_type), crs.CRS_ODU_CCTYPE, crs.CRS_ODU_TO_ID,''FROM'',crs.CRS_ODU_CKTID '||
               'FROM CM_CRS_ODU crs, CM_FACILITY fromFac, CM_FACILITY toFac '||
               'WHERE crs.CRS_ODU_TO_ID ='||oduId||' AND crs.CRS_ODU_FROM_ID<> '||dontFindMeId||' AND crs.CRS_ODU_CCTYPE LIKE ''2WAY%'' AND crs.CRS_ODU_FROM_ID=fromFac.FAC_ID AND crs.CRS_ODU_TO_ID=toFac.FAC_ID '||
               'UNION '||
               'SELECT crs.NE_ID, crs.CRS_ODU_TO_ID, circuit_util.getFacilityCardId(fromProt.FAC_PARENT_ID,fromProt.fac_i_parent_type), circuit_util.getFacilityCardId(toFac.FAC_PARENT_ID,toFac.fac_i_parent_type),crs.CRS_ODU_CCTYPE, crs.crs_odu_src_prot_id,''TO'',crs.CRS_ODU_CKTID '||
               'FROM CM_CRS_ODU crs, CM_FACILITY fromProt, CM_FACILITY toFac '||
               'WHERE crs.CRS_ODU_FROM_ID ='||oduId||' AND crs.crs_odu_src_prot_id is not null AND crs.crs_odu_dest_prot_id is null AND crs.CRS_ODU_TO_ID<> '||dontFindMeId||' AND (crs.CRS_ODU_CCTYPE = ''2WAYPR'' OR (crs.CRS_ODU_CCTYPE = ''1WAYPR'' AND '''||thisOduPosInNextXC||'''<>''TO'')) AND crs.Crs_Odu_Src_Prot_Id=fromProt.FAC_ID AND crs.CRS_ODU_TO_ID=toFac.FAC_ID '||
               'UNION '||
               'SELECT crs.NE_ID, crs.crs_odu_dest_prot_id, circuit_util.getFacilityCardId(fromFac.FAC_PARENT_ID,fromFac.fac_i_parent_type), circuit_util.getFacilityCardId(protFac.FAC_PARENT_ID,protFac.fac_i_parent_type),crs.CRS_ODU_CCTYPE, crs.CRS_ODU_FROM_ID,''TO'',crs.CRS_ODU_CKTID '||
               'FROM CM_CRS_ODU crs, CM_FACILITY fromFac, CM_FACILITY protFac '||
               'WHERE crs.CRS_ODU_FROM_ID ='||oduId||' AND crs.crs_odu_src_prot_id is null AND crs.crs_odu_dest_prot_id is not null AND crs.crs_odu_dest_prot_id<> '||dontFindMeId||' AND (crs.CRS_ODU_CCTYPE = ''2WAYPR'' OR (crs.CRS_ODU_CCTYPE = ''1WAYPR'' AND '''||thisOduPosInNextXC||'''<>''TO'')) AND crs.crs_odu_from_id=fromFac.FAC_ID AND crs.crs_odu_dest_prot_id=protFac.FAC_ID '||
               'UNION '||
               'SELECT crs.NE_ID, crs.crs_odu_dest_prot_id, circuit_util.getFacilityCardId(fromProt.FAC_PARENT_ID,fromProt.fac_i_parent_type), circuit_util.getFacilityCardId(toProt.FAC_PARENT_ID,toProt.fac_i_parent_type),crs.CRS_ODU_CCTYPE, crs.crs_odu_src_prot_id,''TO'',crs.CRS_ODU_CKTID '||
               'FROM CM_CRS_ODU crs, CM_FACILITY fromProt, CM_FACILITY toProt '||
               'WHERE crs.CRS_ODU_FROM_ID ='||oduId||' AND crs.crs_odu_src_prot_id is not null AND crs.crs_odu_dest_prot_id is not null AND crs.crs_odu_dest_prot_id<> '||dontFindMeId||' AND (crs.CRS_ODU_CCTYPE = ''2WAYPR'' OR (crs.CRS_ODU_CCTYPE = ''1WAYPR'' AND '''||thisOduPosInNextXC||'''<>''TO'')) AND crs.crs_odu_src_prot_id=fromProt.FAC_ID AND crs.crs_odu_dest_prot_id=toProt.FAC_ID '||
               'UNION '||
               'SELECT crs.NE_ID, crs.Crs_Odu_Src_Prot_Id, circuit_util.getFacilityCardId(protFac.FAC_PARENT_ID,protFac.fac_i_parent_type), circuit_util.getFacilityCardId(toFac.FAC_PARENT_ID,toFac.fac_i_parent_type), crs.CRS_ODU_CCTYPE, crs.CRS_ODU_TO_ID,''FROM'',crs.CRS_ODU_CKTID '||
               'FROM CM_CRS_ODU crs, CM_FACILITY protFac, CM_FACILITY toFac '||
               'WHERE crs.CRS_ODU_TO_ID ='||oduId||' AND crs.crs_odu_src_prot_id is not null AND crs.crs_odu_dest_prot_id is null AND crs.Crs_Odu_Src_Prot_Id<> '||dontFindMeId||' AND (crs.CRS_ODU_CCTYPE = ''2WAYPR'' OR (crs.CRS_ODU_CCTYPE = ''1WAYPR'' AND '''||thisOduPosInNextXC||'''<>''FROM'')) AND crs.Crs_Odu_Src_Prot_Id=protFac.FAC_ID AND crs.CRS_ODU_TO_ID=toFac.FAC_ID '||
               'UNION '||
               'SELECT crs.NE_ID, crs.CRS_ODU_FROM_ID, circuit_util.getFacilityCardId(fromFac.FAC_PARENT_ID,fromFac.fac_i_parent_type), circuit_util.getFacilityCardId(toProt.FAC_PARENT_ID,toProt.fac_i_parent_type),crs.CRS_ODU_CCTYPE, crs.crs_odu_dest_prot_ID,''FROM'',crs.CRS_ODU_CKTID '||
               'FROM CM_CRS_ODU crs, CM_FACILITY fromFac, CM_FACILITY toProt '||
               'WHERE crs.CRS_ODU_TO_ID ='||oduId||' AND crs.crs_odu_src_prot_id is null AND crs.crs_odu_dest_prot_id is not null AND crs.CRS_ODU_FROM_ID<> '||dontFindMeId||' AND (crs.CRS_ODU_CCTYPE = ''2WAYPR'' OR (crs.CRS_ODU_CCTYPE = ''1WAYPR'' AND '''||thisOduPosInNextXC||'''<>''FROM'')) AND crs.CRS_ODU_FROM_ID=fromFac.FAC_ID AND crs.crs_odu_dest_prot_ID=toProt.FAC_ID '||
               'UNION '||
               'SELECT crs.NE_ID, crs.Crs_Odu_Src_Prot_Id, circuit_util.getFacilityCardId(fromProt.FAC_PARENT_ID,fromProt.fac_i_parent_type), circuit_util.getFacilityCardId(toProt.FAC_PARENT_ID,toProt.fac_i_parent_type),crs.CRS_ODU_CCTYPE, crs.crs_odu_dest_prot_ID,''FROM'',crs.CRS_ODU_CKTID '||
               'FROM CM_CRS_ODU crs, CM_FACILITY fromProt, CM_FACILITY toProt '||
               'WHERE crs.CRS_ODU_TO_ID ='||oduId||' AND crs.crs_odu_src_prot_id is not null AND crs.crs_odu_dest_prot_id is not null AND crs.Crs_Odu_Src_Prot_Id<> '||dontFindMeId||' AND (crs.CRS_ODU_CCTYPE = ''2WAYPR'' OR (crs.CRS_ODU_CCTYPE = ''1WAYPR'' AND '''||thisOduPosInNextXC||'''<>''FROM'')) AND crs.Crs_Odu_Src_Prot_Id=fromProt.FAC_ID AND crs.crs_odu_dest_prot_id=toProt.FAC_ID '||
               'UNION '||
               'SELECT crs.NE_ID, crs.CRS_ODU_TO_ID, circuit_util.getFacilityCardId(protFac.FAC_PARENT_ID,protFac.fac_i_parent_type), circuit_util.getFacilityCardId(toFac.FAC_PARENT_ID,toFac.fac_i_parent_type), crs.CRS_ODU_CCTYPE, crs.Crs_Odu_Src_Prot_Id,''TO'',crs.CRS_ODU_CKTID '||
               'FROM CM_CRS_ODU crs, CM_FACILITY protFac, CM_FACILITY toFac '||
               'WHERE crs.Crs_Odu_Src_Prot_Id ='||oduId||' AND crs.crs_odu_dest_prot_id is null AND crs.CRS_ODU_TO_ID<> '||dontFindMeId||' AND (crs.CRS_ODU_CCTYPE = ''2WAYPR'' OR (crs.CRS_ODU_CCTYPE = ''1WAYPR'' AND '''||thisOduPosInNextXC||'''<>''TO'')) AND crs.Crs_Odu_Src_Prot_Id=protFac.FAC_ID AND crs.CRS_ODU_TO_ID=toFac.FAC_ID '||
               'UNION '||
               'SELECT crs.NE_ID, crs.crs_odu_dest_prot_id, circuit_util.getFacilityCardId(fromProt.FAC_PARENT_ID,fromProt.fac_i_parent_type), circuit_util.getFacilityCardId(toProt.FAC_PARENT_ID,toProt.fac_i_parent_type),crs.CRS_ODU_CCTYPE, crs.crs_odu_src_prot_id,''TO'',crs.CRS_ODU_CKTID '||
               'FROM CM_CRS_ODU crs, CM_FACILITY fromProt, CM_FACILITY toProt '||
               'WHERE crs.crs_odu_src_prot_id ='||oduId||' AND crs.crs_odu_dest_prot_id is not null AND crs.crs_odu_dest_prot_id<> '||dontFindMeId||' AND (crs.CRS_ODU_CCTYPE = ''2WAYPR'' OR (crs.CRS_ODU_CCTYPE = ''1WAYPR'' AND '''||thisOduPosInNextXC||'''<>''TO'')) AND crs.Crs_Odu_Src_Prot_Id=fromProt.FAC_ID AND crs.crs_odu_dest_prot_id=toProt.FAC_ID '||
               'UNION '||
               'SELECT crs.NE_ID, crs.CRS_ODU_TO_ID, circuit_util.getFacilityCardId(fromFac.FAC_PARENT_ID,fromFac.fac_i_parent_type), circuit_util.getFacilityCardId(toFac.FAC_PARENT_ID,toFac.fac_i_parent_type),crs.CRS_ODU_CCTYPE, crs.CRS_ODU_FROM_ID,''TO'',crs.CRS_ODU_CKTID '||
               'FROM CM_CRS_ODU crs, CM_FACILITY fromFac, CM_FACILITY toFac '||
               'WHERE crs.crs_odu_src_prot_id ='||oduId||' AND crs.CRS_ODU_TO_ID<> '||dontFindMeId||' AND (crs.CRS_ODU_CCTYPE = ''2WAYPR'' OR (crs.CRS_ODU_CCTYPE = ''1WAYPR'' AND '''||thisOduPosInNextXC||'''<>''TO'')) AND crs.CRS_ODU_FROM_ID=fromFac.FAC_ID AND crs.CRS_ODU_TO_ID=toFac.FAC_ID '||
               'UNION '||
               'SELECT crs.NE_ID, crs.crs_odu_from_id, circuit_util.getFacilityCardId(fromFac.FAC_PARENT_ID,fromFac.fac_i_parent_type), circuit_util.getFacilityCardId(protFac.FAC_PARENT_ID,protFac.fac_i_parent_type),crs.CRS_ODU_CCTYPE, crs.crs_odu_dest_prot_ID,''FROM'',crs.CRS_ODU_CKTID '||
               'FROM CM_CRS_ODU crs, CM_FACILITY fromFac, CM_FACILITY protFac '||
               'WHERE crs.crs_odu_dest_prot_id ='||oduId||' AND crs.crs_odu_src_prot_id is null AND crs.crs_odu_from_id<> '||dontFindMeId||' AND (crs.CRS_ODU_CCTYPE = ''2WAYPR'' OR (crs.CRS_ODU_CCTYPE = ''1WAYPR'' AND '''||thisOduPosInNextXC||'''<>''FROM'')) AND crs.crs_odu_from_id=fromFac.FAC_ID AND crs.crs_odu_dest_prot_id=protFac.FAC_ID '||
               'UNION '||
               'SELECT crs.NE_ID, crs.crs_odu_src_prot_id, circuit_util.getFacilityCardId(fromProt.FAC_PARENT_ID,fromProt.fac_i_parent_type), circuit_util.getFacilityCardId(toProt.FAC_PARENT_ID,toProt.fac_i_parent_type), crs.CRS_ODU_CCTYPE, crs_odu_dest_prot_ID,''FROM'',crs.CRS_ODU_CKTID '||
               'FROM CM_CRS_ODU crs, CM_FACILITY fromProt, CM_FACILITY toProt '||
               'WHERE crs.crs_odu_dest_prot_id ='||oduId||' AND crs.crs_odu_src_prot_id is not null AND crs.crs_odu_src_prot_id<> '||dontFindMeId||' AND (crs.CRS_ODU_CCTYPE = ''2WAYPR'' OR (crs.CRS_ODU_CCTYPE = ''1WAYPR'' AND '''||thisOduPosInNextXC||'''<>''FROM'')) AND crs.Crs_Odu_Src_Prot_Id=fromProt.FAC_ID AND crs.crs_odu_dest_prot_id=toProt.FAC_ID '||
               'UNION '||
               'SELECT crs.NE_ID, crs.CRS_ODU_FROM_ID, circuit_util.getFacilityCardId(fromFac.FAC_PARENT_ID,fromFac.fac_i_parent_type), circuit_util.getFacilityCardId(toFac.FAC_PARENT_ID,toFac.fac_i_parent_type),crs.CRS_ODU_CCTYPE, crs.CRS_ODU_TO_ID,''FROM'',crs.CRS_ODU_CKTID '||
               'FROM CM_CRS_ODU crs, CM_FACILITY fromFac, CM_FACILITY toFac '||
               'WHERE crs.crs_odu_dest_prot_id ='||oduId||' AND crs.CRS_ODU_FROM_ID<> '||dontFindMeId||' AND (crs.CRS_ODU_CCTYPE = ''2WAYPR'' OR (crs.CRS_ODU_CCTYPE = ''1WAYPR'' AND '''||thisOduPosInNextXC||'''<>''FROM'')) AND crs.CRS_ODU_FROM_ID=fromFac.FAC_ID AND crs.CRS_ODU_TO_ID=toFac.FAC_ID ';

            EXECUTE IMMEDIATE v_sql BULK COLLECT INTO neIdList,otherOduIdList,oduFromEqptIdList,oduToEqptIdList,xcTypeList,ccOduIdList,otherOduLocationList,crsIdList;

            IF oduFromEqptIdList IS NOT NULL THEN
               oduCount:=oduFromEqptIdList.COUNT;
               circuit_util.print_line('Total ODU connections found2: '||oduCount);
            END IF;

            IF oduCount >= 1 THEN
               addFacilityToList(neIdList(1), oduId); -- just one from facility
            ELSE
               circuit_util.print_line('OCH Circuit Terminated at line side ODU2');
               OPEN v_ref_cursor FOR SELECT ne_id FROM CM_FACILITY WHERE FAC_ID = oduId;
               FETCH v_ref_cursor INTO neId;
               CLOSE v_ref_cursor;
               addFacilityToList(neId, oduId);
               IF circuitType = 'STS' or circuit_util.getFacCardType(oduId) in ('HGTMM','HGTMMS','OSM2C') THEN
                  -- try to find the ODU1 mapped to ODU2-timeslot
                  --otherOdu1Id := circuit_util.getMappingOdu1FromOdu2(neId, oduId, g_odu_tribslots(1), g_odu_tribslots(2), middleOduList);
                  tribslotList := V_B_STRING();
                  tribslotList.extend(3);
                  /*tribslotList(1):=g_odu_tribslots(3);
                  tribslotList(2):=g_odu_tribslots(2);
                  tribslotList(3):=g_odu_tribslots(1);*/
                  -- don't know why previous code is reversed...
                  tribslotList(1):=g_odu_tribslots(1);
                  tribslotList(2):=g_odu_tribslots(2);
                  tribslotList(3):=g_odu_tribslots(3);
                  otherOdu1Id := circuit_util.getBottomMappingOduFromHigher(neId, oduId, tribslotList, middleOduList);
                  circuit_util.print_line('found bottom mapping odu:'||otherOdu1Id||' from '||oduId||' g_odu_tribslots(3): '||g_odu_tribslots(3)||' g_odu_tribslots(2): '||g_odu_tribslots(2)||' g_odu_tribslots(1): '||g_odu_tribslots(1));
                  IF otherOdu1Id <> 0 THEN
                     IF middleOduList IS NOT NULL THEN
                          FOR i IN 1..middleOduList.COUNT LOOP
                             addFacilityToList(neId, middleOduList(i));
                          END LOOP;
                     END IF;
                     addFacilityToList(neId, otherOdu1Id);
                     -- line ODU1 found
                     OPEN v_ref_cursor FOR SELECT FAC_AID FROM CM_FACILITY WHERE FAC_ID = otherOdu1Id;
                     FETCH v_ref_cursor INTO otherodu1Aid;
                     CLOSE v_ref_cursor;

                     OPEN v_ref_cursor FOR SELECT FAC_ID FROM CM_FACILITY WHERE NE_ID = g_ne_idx AND FAC_AID = g_sts_aid;
                     FETCH v_ref_cursor INTO g_sts_id;
                     CLOSE v_ref_cursor;

                     --ochpId := circuit_util.getMappingOchPFromOdu(g_ne_idx, circuit_util.getMappingOdu2FromOdu1(g_ne_idx, g_sts_id, odu0_tribslot, odu1_tribslot, odu2_tribslot, middleOduList));
                     odu2Id := circuit_util.getTopMappingOduFromLower(g_ne_idx, g_sts_id, odu_mapping_list, odu_mapping_type_list, odu_mapping_tribslot_list);
                     ochpId := circuit_util.getMappingOchPFromOdu(g_ne_idx, odu2Id);

                     OPEN v_ref_cursor FOR SELECT och_dwdmside FROM cm_channel_och WHERE och_id = ochpId;
                     FETCH v_ref_cursor INTO dwdmSideFrom;
                     CLOSE v_ref_cursor;

                     --otherOCHPId := circuit_util.getMappingOchPFromOdu(neId, circuit_util.getMappingOdu2FromOdu1(neId, otherOdu1Id, odu0_tribslot, odu1_tribslot, odu2_tribslot, otherMiddleOduList));
                     odu2Id := circuit_util.getTopMappingOduFromLower(neId, otherOdu1Id, odu_mapping_list, odu_mapping_type_list, odu_mapping_tribslot_list);
                     otherOCHPId := circuit_util.getMappingOchPFromOdu(neId, odu2Id);

                     OPEN v_ref_cursor FOR SELECT och_dwdmside FROM cm_channel_och WHERE och_id = otherOCHPId;
                     FETCH v_ref_cursor INTO dwdmSideTo;
                     CLOSE v_ref_cursor;

                     compFlag:=FALSE;
                     IF g_ne_idx=neId THEN
                        /*IF dwdmSideFrom<>dwdmSideTo THEN
                           compFlag := TRUE;
                        END IF;*/
                        compFlag:=FALSE;
                     ELSE
                        compFlag := TRUE;
                     END IF;
                     IF compFlag = TRUE THEN
                        IF(circuit_util.getOduLayer(g_sts_aid)=circuit_util.getOduLayer(otherodu1Aid)) THEN
                          addODUCompositeLinkToList(g_ne_idx,neId,g_sts_aid,otherodu1Aid,dwdmSideFrom,dwdmSideTo,0);
                          g_sts_aid:='';
                        ELSIF (circuit_util.getOduLayer(g_sts_aid)<circuit_util.getOduLayer(otherodu1Aid)) THEN
                           IF middleOduList IS NOT NULL THEN
                                FOR i IN 1..middleOduList.COUNT LOOP
                                   matchedOduAid := circuit_util.getFacAidById(middleOduList(i));
                                   IF(circuit_util.getOduLayer(matchedOduAid)=circuit_util.getOduLayer(otherodu1Aid)) THEN
                                      addODUCompositeLinkToList(g_ne_idx,neId,matchedOduAid,otherodu1Aid,dwdmSideFrom,dwdmSideTo,0);
                                      EXIT;
                                   END IF;
                                END LOOP;
                           END IF;
                        ELSE--circuit_util.getOduLayer(g_sts_aid)>circuit_util.getOduLayer(otherodu1Aid)
                           IF otherMiddleOduList IS NOT NULL THEN
                                FOR i IN 1..otherMiddleOduList.COUNT LOOP
                                   matchedOduAid := circuit_util.getFacAidById(otherMiddleOduList(i));
                                   IF(circuit_util.getOduLayer(g_sts_aid)=circuit_util.getOduLayer(matchedOduAid)) THEN
                                      addODUCompositeLinkToList(g_ne_idx,neId,g_sts_aid,matchedOduAid,dwdmSideFrom,dwdmSideTo,0);
                                      g_sts_aid:='';
                                      EXIT;
                                   END IF;
                                END LOOP;
                           END IF;
                           oduLayer := circuit_util.getOduLayer(otherodu1Aid);
                           WHILE oduLayer>-1 LOOP
                               IF g_odu_table.EXISTS(oduLayer) THEN
                                   --ochpId := circuit_util.getMappingOchPFromOdu(g_odu_table(oduLayer).ne_id, circuit_util.getMappingOdu2FromOdu1(g_odu_table(oduLayer).ne_id, g_odu_table(oduLayer).odu_id, odu0_tribslot, odu1_tribslot, odu2_tribslot, middleOduList));
                                   odu2Id := circuit_util.getTopMappingOduFromLower(g_odu_table(oduLayer).ne_id,g_odu_table(oduLayer).odu_id, odu_mapping_list, odu_mapping_type_list, odu_mapping_tribslot_list);
                                   ochpId := circuit_util.getMappingOchPFromOdu(g_odu_table(oduLayer).ne_id, odu2Id);

                                   OPEN v_ref_cursor FOR SELECT och_dwdmside FROM cm_channel_och WHERE och_id = ochpId;
                                   FETCH v_ref_cursor INTO dwdmSideFrom;
                                   CLOSE v_ref_cursor;
                                   IF (oduLayer=circuit_util.getOduLayer(otherodu1Aid)) THEN
                                       addODUCompositeLinkToList(g_odu_table(oduLayer).ne_id,neId,g_odu_table(oduLayer).odu_aid,otherodu1Aid,dwdmSideFrom,dwdmSideTo,0);
                                   ELSE
                                       IF middleOduList IS NOT NULL THEN
                                            FOR i IN 1..middleOduList.COUNT LOOP
                                               matchedOduAid := circuit_util.getFacAidById(middleOduList(i));
                                               IF(circuit_util.getOduLayer(matchedOduAid)=circuit_util.getOduLayer(otherodu1Aid)) THEN
                                                  addODUCompositeLinkToList(g_odu_table(oduLayer).ne_id,neId,matchedOduAid,otherodu1Aid,dwdmSideFrom,dwdmSideTo,0);
                                                  EXIT;
                                               END IF;
                                            END LOOP;
                                       END IF;
                                   END IF;
                                   EXIT;
                               ELSE
                                   oduLayer := oduLayer-1;
                               END IF;
                           END LOOP;

                        END IF;
                     END IF;
                     -- to find ODU1-ODU1 XC
                     findXCFromODU1(otherOdu1Id, thisOduPosInNextXC, oduId, circuitType);
                  ELSIF g_sts_aid LIKE 'ODU1-%' THEN
                     -- try to fake a line ODU1
                     circuit_util.print_line('try to fake a line ODU1');

                     OPEN v_ref_cursor FOR SELECT 'ODU1-'||FAC_AID_SHELF||'-'||FAC_AID_SLOT||'-'||FAC_AID_PORT||'-'||FAC_AID_STS FROM CM_FACILITY WHERE FAC_ID = oduId;
                     FETCH v_ref_cursor INTO otherodu1Aid;
                     CLOSE v_ref_cursor;

                     OPEN v_ref_cursor FOR SELECT FAC_ID FROM CM_FACILITY WHERE NE_ID = g_ne_idx AND FAC_AID = g_sts_aid;
                     FETCH v_ref_cursor INTO g_sts_id;
                     CLOSE v_ref_cursor;

                     --ochpId := circuit_util.getMappingOchPFromOdu(g_ne_idx, circuit_util.getMappingOdu2FromOdu1(g_ne_idx, g_sts_id, odu0_tribslot, odu1_tribslot, odu2_tribslot, middleOduList));
                     odu2Id := circuit_util.getTopMappingOduFromLower(g_ne_idx, g_sts_id, odu_mapping_list, odu_mapping_type_list, odu_mapping_tribslot_list);
                     ochpId := circuit_util.getMappingOchPFromOdu(g_ne_idx, odu2Id);

                     OPEN v_ref_cursor FOR SELECT och_dwdmside FROM cm_channel_och WHERE och_id = ochpId;
                     FETCH v_ref_cursor INTO dwdmSideFrom;
                     CLOSE v_ref_cursor;

                     otherOCHPId := circuit_util.getMappingOchPFromOdu(neId, oduId);

                     OPEN v_ref_cursor FOR SELECT och_dwdmside FROM cm_channel_och WHERE och_id = otherOCHPId;
                     FETCH v_ref_cursor INTO dwdmSideTo;
                     CLOSE v_ref_cursor;

                     compFlag:=FALSE;
                     IF g_ne_idx=neId THEN
                        IF dwdmSideFrom<>dwdmSideTo THEN
                           compFlag := TRUE;
                        END IF;
                     ELSE
                        compFlag := TRUE;
                     END IF;
                     IF compFlag = TRUE THEN
                        addODUCompositeLinkToList(g_ne_idx,neId,g_sts_aid,otherodu1Aid,dwdmSideFrom,dwdmSideTo,0);
                        g_sts_aid:='';
                     END IF;
                  END IF;

               END IF;
            END IF;

            dontFindMeAgainId:=oduId;
            FOR i IN 1..oduCount LOOP
               fromEqptId := oduFromEqptIdList(i);
               toEqptId := oduToEqptIdList(i);

               -- get crossconnect facility data
               IF otherOduLocationList(i)='TO' THEN
                  crsFromFacilityKey := ccOduIdList(i);
                  crsToFacilityKey := otherOduIdList(i);
               ELSIF otherOduLocationList(i)='FROM' THEN
                  crsFromFacilityKey := otherOduIdList(i);
                  crsToFacilityKey := ccOduIdList(i);
               END IF;

               addFacilityToList(neIdList(i), otherOduIdList(i)); -- crs_to_id
               addFacilityToList(neIdList(i), ccOduIdList(i));

               -- get crossconnect fromcp/tocp equipment/fiber data
               crsFromCPKey := fromEqptId;
               addEquipmentToList(neIdList(i),fromEqptId);
               crsToCPKey := toEqptId;
               addEquipmentToList(neIdList(i),toEqptId);

               addSTSConnectionToList(neIdList(i), crsFromFacilityKey, crsToFacilityKey, NULL, NULL);

               addOSMSNCFFP(neIdList(i),crsFromFacilityKey);
               addOSMSNCFFP(neIdList(i),crsToFacilityKey);

               --Find next XCs orientation
               IF xcTypeList(i) LIKE '%2WAY%' THEN
                  IF thisOduPosInNextXC='BOTH' THEN
                     nextOduPosInNextXC:='BOTH';
                  ELSE
                     nextOduPosInNextXC:=thisOduPosInNextXC;
                  END IF;
               ELSIF xcTypeList(i) LIKE '%1WAY%' THEN
                  IF otherOduLocationList(i)='TO' THEN
                     nextOduPosInNextXC:='FROM';
                  ELSIF otherOduLocationList(i)='FROM' THEN
                     nextOduPosInNextXC:='TO';
                  END IF;
               END IF;

               ochOduId := 0;
               IF circuit_util.getFacCardType(otherOduIdList(i)) in ('HGTMM','HGTMMS','OSM2C') THEN
                  /*ochOduId := circuit_util.getMappingOdu2FromOdu1(neIdList(i), otherOduIdList(i), odu0_tribslot, odu1_tribslot, odu2_tribslot, middleOduList);
                  IF (odu2_tribslot IS NOT NULL AND odu2_tribslot<>'0') THEN
                     g_odu_tribslots(3) := odu2_tribslot;
                  END IF;*/

                  ochOduId := circuit_util.getTopMappingOduFromLower(neIdList(i), otherOduIdList(i), odu_mapping_list, odu_mapping_type_list, odu_mapping_tribslot_list);
                  IF ochOduId<>0 and odu_mapping_list.count>1 THEN
                    FOR i IN 1..odu_mapping_list.COUNT LOOP
                       addFacilityToList(neId, odu_mapping_list(i));
                       if odu_mapping_tribslot_list(i) is not null then
                          idx := circuit_util.getOduLayer(odu_mapping_type_list(i));
                          g_odu_tribslots(idx+1) := odu_mapping_tribslot_list(i);
                       end if;
                    END LOOP;
                  END IF;

                  IF ochOduId<>0 THEN
                     addFacilityToList(neId, ochOduId);
                     otherOCHPId := circuit_util.getMappingOchPFromOdu(neIdList(i),ochOduId);
                     OPEN v_ref_cursor FOR SELECT FAC_AID FROM CM_FACILITY WHERE NE_ID = neIdList(i) AND FAC_ID = otherOduIdList(i);
                     FETCH v_ref_cursor INTO otherOdu1Aid;
                     CLOSE v_ref_cursor;
                     -- to make composite link
                     g_odu_table(circuit_util.getOduLayer(otherOdu1Aid)).ne_id := neIdList(i);
                     g_odu_table(circuit_util.getOduLayer(otherOdu1Aid)).odu_id := otherOduIdList(i);
                     g_odu_table(circuit_util.getOduLayer(otherOdu1Aid)).odu_aid := otherOdu1Aid;
                     IF g_sts_aid IS NULL OR
                       circuit_util.getFacAidType(g_sts_aid)=circuit_util.getFacAidType(otherOdu1Aid)
                     THEN
                       g_ne_idx:=neIdList(i);
                       g_sts_aid:=otherOdu1Aid;
                     END IF;
                  END IF;
               ELSE
                  otherOCHPId := circuit_util.getMappingOchPFromOdu(neIdList(i), otherOduIdList(i));
               END IF;

               IF otherOCHPId <> 0 THEN
                  v_last_hop_och_id := findXCFromOCHX(otherOCHPId, nextOduPosInNextXC, oduId, circuitType);
               ELSE
                   --facId := circuit_util.getMappingFacFromOdu(neIdList(i), otherOduIdList(i));
                   IF NVL(ochOduId,0)=0 THEN 
                     ochOduId:=otherOduIdList(i);
                   END IF;
                   facId := circuit_util.getMappingFacFromOdu(neIdList(i), ochOduId);
                   IF facId <> 0 THEN -- add find fiber link here
                      addFacilityToList(neIdList(i), facId);
                      v_last_hop_och_id := findFiberLinkFromOCH(facId, nextOduPosInNextXC, 0, circuitType, v_fiberlink);
                   END IF;

                   IF facId<>0 and v_last_hop_och_id<0 THEN
                      circuit_util.print_line('OCH Circuit terminated at client facility');
                      --find YCABLE
                      OPEN v_ref_cursor FOR SELECT FAC_WORKINGID,FAC_PROTECTIONID,CASE WHEN FAC_WORKINGID = facId THEN FAC_PROTECTIONID WHEN FAC_PROTECTIONID = facId THEN FAC_WORKINGID END
                           FROM CM_FACILITY WHERE FAC_ID = facId AND FAC_SCHEME = 'YCABLE';
                      FETCH v_ref_cursor INTO ycableWorkingId,ycableProtectionId,ycableFacId;
                      CLOSE v_ref_cursor;
                      IF ycableFacId > 0 THEN
                         addFFPToList(neIdList(i),ycableWorkingId,ycableProtectionId);
                         OPEN v_ref_cursor FOR SELECT o.Fac_Id FROM CM_FACILITY f, CM_FACILITY o
                         WHERE f.Fac_Id = ycableFacId AND f.NE_ID = o.NE_ID AND f.fac_id<>o.fac_id AND o.fac_aid_type LIKE 'ODU%'
                         AND circuit_util.trimAidType(f.fac_aid) = circuit_util.trimAidType(o.fac_aid) ;
                         FETCH v_ref_cursor INTO ycableoduId;
                         CLOSE v_ref_cursor;
                         IF ycableoduId > 0 THEN
                            findXCFromODU2(ycableoduId, nextOduPosInNextXC, 0, circuitType);
                         END IF;
                      END IF;
                   END IF;
               END IF;

               IF xcTypeList(i) LIKE '%WAYPR%' AND dontFindMeAgainId <> ccOduIdList(i) THEN
                   otherOCHPId := circuit_util.getMappingOchPFromOdu(neIdList(i), ccOduIdList(i));
                   IF otherOCHPId <> 0 THEN
                       IF nextOduPosInNextXC = 'FROM' THEN
                          nextOduPosInNextXC := 'TO';
                       ELSIF nextOduPosInNextXC = 'TO' THEN
                          nextOduPosInNextXC := 'FROM';
                       END IF;
                       v_last_hop_och_id := findXCFromOCHX(otherOCHPId, nextOduPosInNextXC, oduId, circuitType);
                   ELSE
                       facId := circuit_util.getMappingFacFromOdu(neIdList(i), ccOduIdList(i));
                       IF facId <> 0 THEN
                          circuit_util.print_line('OCH Circuit terminated at client facility');
                          addFacilityToList(neIdList(i), facId);
                          --find YCABLE
                          OPEN v_ref_cursor FOR SELECT FAC_WORKINGID,FAC_PROTECTIONID,CASE WHEN FAC_WORKINGID = facId THEN FAC_PROTECTIONID WHEN FAC_PROTECTIONID = facId THEN FAC_WORKINGID END
                           FROM CM_FACILITY WHERE FAC_ID = facId AND FAC_SCHEME = 'YCABLE';
                          FETCH v_ref_cursor INTO ycableWorkingId,ycableProtectionId,ycableFacId;
                          CLOSE v_ref_cursor;
                          IF ycableFacId > 0 THEN
                             addFFPToList(neIdList(i),ycableWorkingId,ycableProtectionId);
                             OPEN v_ref_cursor FOR SELECT o.Fac_Id FROM CM_FACILITY f, CM_FACILITY o
                             WHERE f.Fac_Id = ycableFacId AND f.NE_ID = o.NE_ID AND f.fac_id<>o.fac_id AND o.fac_aid_type LIKE 'ODU%'
                             AND circuit_util.trimAidType(f.fac_aid) = circuit_util.trimAidType(o.fac_aid) ;
                             FETCH v_ref_cursor INTO ycableoduId;
                             CLOSE v_ref_cursor;
                             IF ycableoduId > 0 THEN
                                findXCFromODU2(ycableoduId, nextOduPosInNextXC, 0, circuitType);
                             END IF;
                          END IF;
                       END IF;
                   END IF;
               END IF;

            END LOOP;
         END IF;
        circuit_util.print_end('findXCFromODU2');
    END findXCFromODU2;
    PROCEDURE processRptOchDrop(
        p_end_id NUMBER, thisOchPosInNextXC VARCHAR2, dontFindMeId NUMBER,
        p_circuitType VARCHAR2, p_store_point NUMBER
    )AS
    BEGIN
    circuit_util.print_start('processRptOchDrop');
        IF g_cache_och_circuit THEN
            g_rpt_end_id := p_end_id;
            g_cache_och_circuit := FALSE;
            g_rpt_dontFindMeId := dontFindMeId;
            g_rpt_direction := thisOchPosInNextXC;
            addRptCircuitCache(p_circuitType, p_store_point);
        END IF;
    circuit_util.print_end('processRptOchDrop');
    END processRptOchDrop;

    FUNCTION findFiberLinkFromOCH(
        ochId IN NUMBER, thisOchPosInNextXC IN VARCHAR2, dontFindMeId IN NUMBER,
        circuitType IN VARCHAR2, fiberLink OUT FIBERLINK_RECORD, processRptDrop BOOLEAN DEFAULT FALSE
    ) RETURN VARCHAR2 AS
      v_ref_cursor      EMS_REF_CURSOR;
      otutrc            VARCHAR2(30);
      incotutrc         VARCHAR2(30);
      connectedto       VARCHAR2(50);
      connectedTid      VARCHAR2(50);
      connectedOch      VARCHAR2(50);
      extchan           NUMBER;
      neIdList          IntTable;
      ochIdList         IntTable;
      ochAidList        StringTable70;
      ochAidTypeList    StringTable70;
      exceptionText     VARCHAR2(5000);
      otherOchId        NUMBER;
    begin
      fiberLink.other_och_id := -1;
      fiberLink.och_id := ochId;
      circuit_util.print_line('Finding fiber link from : '||ochId);
      OPEN v_ref_cursor FOR
      select NE_ID, OCH_AID, OCH_OTUTRC, OCH_INCOTUTRC, CASE OCH_TYPE WHEN 'P' THEN OCH_EXTCHAN ELSE OCH_CHANNUM END, OCH_CONNECTEDTO
      from CM_CHANNEL_OCH where OCH_ID=ochId
      union
      select NE_ID, FAC_AID, FAC_TXOPER, FAC_RXOPER, 0, ''
      from CM_FACILITY where FAC_ID=ochId and fac_aid_type like 'OTU%';

      FETCH v_ref_cursor INTO fiberLink.ne_id, fiberLink.och_aid, otutrc, incotutrc, extchan, connectedto;
      IF v_ref_cursor%FOUND AND (otutrc IS NOT NULL OR incotutrc IS NOT NULL OR (extchan IS NOT NULL AND connectedto IS NOT NULL) ) THEN
         CLOSE v_ref_cursor;
         IF otutrc IS NOT NULL OR incotutrc IS NOT NULL THEN
           OPEN v_ref_cursor FOR
           select ne_id, OCH_ID,OCH_AID, 'OCH-P' from CM_CHANNEL_OCH
           where  OCH_TYPE='P'AND ((OCH_OTUTRC=incotutrc AND  OCH_INCOTUTRC=otutrc) OR
                                   (OCH_OTUTRC IS NULL AND incotutrc IS NULL AND OCH_INCOTUTRC=otutrc) OR
                                   (OCH_OTUTRC=incotutrc AND OCH_INCOTUTRC IS NULL AND otutrc IS NULL))
           union
           select ne_id, FAC_ID, FAC_AID, FAC_AID_TYPE from CM_FACILITY
           where FAC_AID_TYPE LIKE 'OTU%' AND ((FAC_TXOPER=incotutrc AND FAC_RXOPER=otutrc) OR
                                               (FAC_TXOPER IS NULL AND incotutrc IS NULL AND FAC_RXOPER=otutrc) OR
                                               (FAC_TXOPER=incotutrc AND FAC_RXOPER IS NULL AND otutrc IS NULL));
           FETCH v_ref_cursor BULK COLLECT INTO neIdList, ochIdList, ochAidList, ochAidTypeList; 
         END IF;
         IF neIdList.COUNT=0 AND extchan IS NOT NULL AND connectedto IS NOT NULL THEN
           connectedTid := SUBSTR(connectedto, 1, INSTR(connectedto, ' ') - 1);
           connectedOch := SUBSTR(connectedto, INSTR(connectedto, ' ') + 1, LENGTH(connectedto));
           OPEN v_ref_cursor FOR
           select n.ne_id, o.OCH_ID,o.OCH_AID, 'OCH-'||o.OCH_TYPE from CM_CHANNEL_OCH o, EMS_NE n
           where n.ne_tid=connectedTid AND o.ne_id=n.ne_id AND o.och_aid=connectedOch
           AND ((o.och_channum=extchan AND o.och_type='1') OR (o.och_extchan=extchan AND o.och_type='P'));
           FETCH v_ref_cursor BULK COLLECT INTO neIdList, ochIdList, ochAidList, ochAidTypeList; 
         END IF;         
         IF neIdList.COUNT=0 THEN
           return -1;
         END IF;
         
         IF neIdList.COUNT>0 THEN
            IF neIdList.COUNT >1 THEN
               exceptionText := 'OTU trace is not uniquely matched: '||circuit_util.getNeTidById(fiberLink.ne_id)||' '||fiberLink.och_aid
                                ||' with ';
               
               FOR i IN 1..neIdList.COUNT LOOP
                  exceptionText := exceptionText ||circuit_util.getNeTidById(neIdList(i))||' '||ochAidList(i);
                  if i <> neIdList.COUNT then
                     exceptionText := exceptionText || ', ';
                  else
                     exceptionText := exceptionText || '.';
                  end if;
               END LOOP;
               circuit_util.print_line('EXCEPTION: '||exceptionText);              
               raise_application_error(-20000,exceptionText);
               --g_error:=exceptionText;
               --return -1;
            END IF;
            
            fiberLink.other_ne_id := neIdList(1);
            fiberLink.other_och_id := ochIdList(1);
            fiberLink.other_och_aid :=ochAidList(1);
            fiberLink.other_och_type := ochAidTypeList(1);
            
            IF circuitType = 'TRY_TO_FIND' THEN
              return fiberLink.other_och_id;
            END IF;

            if fiberLink.och_aid like 'OCH-P-%' then
               fiberLink.fac_id := circuit_util.getMappingOduFromOchP(fiberLink.ne_id, fiberLink.och_id);
            elsif fiberLink.och_aid like 'OTU%' then
               fiberLink.fac_id := circuit_util.getMappingOduFromFac(fiberLink.ne_id, fiberLink.och_id);
            end if;

            if fiberLink.fac_id <> 0 then
                 fiberLink.fac_aid := circuit_util.getFacAidById(fiberLink.fac_id);
                 addFacilityToList(fiberLink.ne_id, fiberLink.fac_id);
            else
                 fiberLink.fac_id := fiberLink.och_id;
                 fiberLink.fac_aid := fiberLink.och_aid;
            end if;
            if fiberLink.och_aid like 'OCH-%' then
               fiberLink.card_id := circuit_util.getFacilityCardId(fiberLink.och_id, 'OCH');
            elsif fiberLink.och_aid like 'OTU%' then
               fiberLink.card_id := circuit_util.getFacilityCardId(fiberLink.och_id, 'FACILITY');
            end if;
            addEquipmentToList(fiberLink.ne_id,fiberLink.card_id);
            addFacilityToList(fiberLink.ne_id, fiberLink.och_id);

            if fiberLink.other_och_aid like 'OCH-P-%' then
               fiberLink.other_fac_id := circuit_util.getMappingOduFromOchP(fiberLink.other_ne_id, fiberLink.other_och_id);
            elsif fiberLink.other_och_aid like 'OTU%' then
               fiberLink.other_fac_id := circuit_util.getMappingOduFromFac(fiberLink.other_ne_id, fiberLink.other_och_id);
            end if;
            addFacilityToList(fiberLink.other_ne_id, fiberLink.other_och_id);

            if fiberLink.other_fac_id<>0 then
               fiberLink.other_fac_aid := circuit_util.getFacAidById(fiberLink.other_fac_id);
               fiberLink.other_card_id := circuit_util.getFacCardId(fiberLink.other_fac_id);
               addFacilityToList(fiberLink.other_ne_id, fiberLink.other_fac_id);
               addEquipmentToList(fiberLink.other_ne_id,fiberLink.other_card_id);

               addFiberLinkToList(fiberLink.ne_id, fiberLink.other_ne_id,
                               fiberLink.card_id, fiberLink.other_card_id,
                               fiberLink.och_aid, fiberLink.other_och_aid,
                               fiberLink.fac_aid, fiberLink.other_fac_aid,
                               fiberLink.och_id, fiberLink.other_och_id,
                               fiberLink.fac_id, fiberLink.other_fac_id);
            else
               fiberLink.other_fac_id := fiberLink.other_och_id;
               fiberLink.other_fac_aid := fiberLink.other_och_aid;               
               if fiberLink.other_och_aid like 'OCH-%' then
                  fiberLink.other_card_id := circuit_util.getFacilityCardId(fiberLink.other_och_id, 'OCH');
               else -- otu
                  fiberLink.other_card_id := circuit_util.getFacilityCardId(fiberLink.other_och_id, 'FACILITY');
               end if;
               addEquipmentToList(fiberLink.other_ne_id,fiberLink.other_card_id);
            end if;
            if fiberLink.other_fac_aid like 'ODU%' then
                  if g_circuit_type = 'OCH' OR g_circuit_type IS NULL then
                     circuit_util.print_line('overwrite circuitType from OCH to ODU2');
                     g_circuit_type := 'ODU2';
                  end if;
                  findXCFromODU2(fiberLink.other_fac_id, thisOchPosInNextXC, 0, circuitType);
                  return 0; -- will not process other OCHX in outer caller function.
            elsif fiberLink.other_fac_aid like 'OCH-P%' then -- FOR och-p, och-p OEO regen
                 addFiberLinkToList(fiberLink.ne_id, fiberLink.other_ne_id,
                               fiberLink.card_id, fiberLink.other_card_id,
                               fiberLink.och_aid, fiberLink.other_och_aid,
                               fiberLink.fac_aid, fiberLink.other_fac_aid,
                               fiberLink.och_id, fiberLink.other_och_id,
                               fiberLink.fac_id, fiberLink.other_fac_id);
                               
                 FOR l_och1 IN (SELECT ne_tid, ne_type, ne_stype, shelf_subtype, card1.card_aid_type, och1.och_dwdmside, och1.och_aid_shelf, och1.och_aid_slot, och1.och_aid_port
                            FROM cm_card card1, cm_shelf sh, ems_ne ne, cm_channel_och och1
                            WHERE instr(ne.ne_stype,'OLA')=0 AND card1.card_id=och1.och_parent_id AND sh.ne_id=och1.ne_id AND sh.shelf_aid_shelf=och1.och_aid_shelf AND ne.ne_id=och1.ne_id 
                            AND och1.och_id=fiberLink.other_och_id
                        )
                 LOOP
                    otherOchId := findNonTrmCrsOeo(
                        fiberLink.other_ne_id, l_och1.ne_tid, l_och1.ne_type,
                        l_och1.ne_stype, l_och1.shelf_subtype, 'ADD/DROP',
                        '2WAY', l_och1.card_aid_type,  l_och1.och_aid_shelf,
                        l_och1.och_aid_slot, l_och1.och_aid_port,  fiberLink.other_och_id,
                        fiberLink.other_och_id, fiberLink.other_och_aid, circuitType
                    );
                    IF nvl(otherOchId, 0) != 0 THEN
                        findDWDMLinkAndOtherSideOCHL(otherOchId, otherOchId);
                        otherOchId := findXCFromOCHX(otherOchId, thisOchPosInNextXC, 0, circuitType); 
                    END IF;
                END LOOP;
                return 0;
            elsif fiberLink.other_fac_aid like 'OCH-1-%' then -- FOR och-p, och-1 foreign wavelength
              addFiberLinkToList(fiberLink.ne_id, fiberLink.other_ne_id,
                               fiberLink.card_id, fiberLink.other_card_id,
                               fiberLink.och_aid, fiberLink.other_och_aid,
                               fiberLink.fac_aid, fiberLink.other_fac_aid,
                               fiberLink.och_id, fiberLink.other_och_id,
                               fiberLink.fac_id, fiberLink.other_fac_id);
              otherOchId := findXCFromOCHX(fiberLink.other_och_id, thisOchPosInNextXC, 0, circuitType);  
              return 0;
            end if;
         END IF;
      END IF;
      CLOSE v_ref_cursor;
      return fiberLink.other_och_id;
    end findFiberLinkFromOCH;

    FUNCTION findXCFromOCHX(
        ochId IN NUMBER, thisOchPosInNextXC IN VARCHAR2, dontFindMeId IN NUMBER,
        circuitType IN VARCHAR2, processRptDrop BOOLEAN DEFAULT FALSE
    ) RETURN VARCHAR2 AS
        v_ref_cursor            EMS_REF_CURSOR;
        ochCount                INTEGER;
        i                       INTEGER;
        j                       INTEGER;
        otherOchId              NUMBER;
        nextOchId               NUMBER;
        dontFindMeAgainId       NUMBER;
        fromEqptId              NUMBER;
        toEqptId                NUMBER;
        duplicateOchL           NUMBER;
        doesExists              NUMBER;
        neId                    NUMBER;
        eqptOPSMProtId          NUMBER;
        eqptSMTMProtId          NUMBER;
        eqptYCABLEProtId        NUMBER;
        otherRouteOchId         NUMBER;
        nextOchPosInNextXC      VARCHAR2(20);
        otherSideOCHP           VARCHAR2(20);
        duplicateCheckKey       VARCHAR2(50);
        crsFromFacilityKey      VARCHAR2(100);
        crsToFacilityKey        VARCHAR2(100);
        crsFromCPKey            VARCHAR2(100);
        crsToCPKey              VARCHAR2(100);
        ochFromSide             VARCHAR2(2);
        ochToSide               VARCHAR2(2);
        ochType                 VARCHAR2(20);
        isPassThroughNE         BOOLEAN;
        crsExists               BOOLEAN DEFAULT FALSE;

        neIdList                IntTable;
        ochFromEqptIdList       IntTable;
        ochToEqptIdList         IntTable;
        ochFromCpIdList         IntTable;
        ochToCpIdList           IntTable;
        otherOchIdList          IntTable;
        fromSideList            StringTable70;
        toSideList              StringTable70;
        xcTypeList              StringTable70;
        ccPathList              StringTable70;
        otherOchTypeList        StringTable70;
        otherOchLocationList    StringTable70;
        crsIdList               StringTable70;
        linePort                VARCHAR2(4);
        otherlinePort           VARCHAR2(4);
        timeSlot                VARCHAR2(3);
        tmptimeSlot             VARCHAR2(3);
        dwdmSideFrom            VARCHAR2(4);
        dwdmSideTo              VARCHAR2(4);
        prevHopStsAid           VARCHAR2(70);
        prevHopNeId             NUMBER;
        prevHopCardId           NUMBER;
        sts1map                 VARCHAR2(800);
        exprate                 VARCHAR2(26);
        tempSts1map             VARCHAR2(800);
        tempStr                 VARCHAR2(800);
        tempStr1                VARCHAR2(800);
        submap                  VARCHAR2(192);
        tpUsage                 VARCHAR2(192);
        nextStsTimeSlot         VARCHAR2(5);
        fromCompositetMap       VARCHAR2(800);
        toCompositeMap          VARCHAR2(800);
        token                   NUMBER;
        cnvCount                NUMBER;
        othercardShelf          NUMBER;
        othercardSlot           NUMBER;
        farStsId                NUMBER;
        nextStsId               NUMBER;
        compFlag                BOOLEAN;
        errFlag                 BOOLEAN DEFAULT FALSE;
        stsIdList               V_B_STRING;
        gotherochId             NUMBER;
        gotheroduId             NUMBER;
        odu2Id                  NUMBER;
        portSts1map             VARCHAR2(800);
        nextPortORLine          VARCHAR2(10);
        portFacId               NUMBER;
        portOduId1              NUMBER;
        portOduId2              NUMBER;
        ycableFacId             NUMBER;
        ycableOduId             NUMBER;
        ycableWorkingId         NUMBER;
        ycableProtectionId      NUMBER;
        ycableNeId              NUMBER;
        ycableEqptId            NUMBER;
        ycableFacAid            VARCHAR2(20);
        ycableCcpath            VARCHAR2(20);

        v_other_sts1map         VARCHAR2(800);
        v_trn_eqpt_id           NUMBER;
        v_ignore_duplicate      BOOLEAN := FALSE;
        v_last_hop_och_id       NUMBER;
        v_valid_second_och_xc   BOOLEAN := FALSE;
        v_ochp_oeo              BOOLEAN := FALSE;
        v_fiberlink             FIBERLINK_RECORD;
    BEGIN circuit_util.print_start('findXCFromOCHX');
        v_last_hop_och_id := ochId;
        circuit_util.print_line('Finding connections from OCH:' ||ochId||','||thisOchPosInNextXC||','||dontFindMeId);
        IF processRptDrop THEN
            v_ignore_duplicate := TRUE;
        ELSE
            duplicateCheckKey := ochId ||'-'|| thisOchPosInNextXC;
            --circuit_util.print_line('Checking for duplicate key: '||duplicateCheckKey);
            checkForDuplicateProcessing(duplicateCheckKey, duplicateOchL);
            v_ignore_duplicate := (duplicateOchL = 0);
        END IF;


        OPEN v_ref_cursor FOR select SUBSTR(OCH_AID,1,INSTR(OCH_AID,'-',2,2)-1) from CM_CHANNEL_OCH where OCH_ID=ochId;
        FETCH v_ref_cursor INTO ochType;
        CLOSE v_ref_cursor;

        -- IF MAY BE A OTUx because of Fiber Link
        if ochType is null then
           OPEN v_ref_cursor FOR select FAC_AID_TYPE from CM_FACILITY where FAC_ID=ochId;
           FETCH v_ref_cursor INTO ochType;
           CLOSE v_ref_cursor;
        end if;

        -- handle case OLA/OLU, find the other side OCH-L
        -- NOTE: Below sql may not work for multi-degree, though no support available for OLA/OLU
        isPassThroughNE:=FALSE;
        IF v_ignore_duplicate AND processRptDrop=FALSE AND ochType LIKE 'OCH%' THEN
            OPEN v_ref_cursor FOR SELECT och2.OCH_ID, ne.NE_ID, och1.OCH_DWDMSIDE, och2.OCH_DWDMSIDE FROM CM_CHANNEL_OCH och1, CM_CHANNEL_OCH och2, EMS_NE ne
                WHERE ne.NE_ID=och1.NE_ID AND och2.NE_ID=och1.NE_ID AND och2.OCH_CHANNUM=SUBSTR(och1.OCH_AID,INSTR(och1.OCH_AID,'-',-1,1)+1,LENGTH(och1.OCH_AID)) AND och2.OCH_ID<>och1.OCH_ID AND (ne.NE_TYPE LIKE '%OLA%' OR ne.NE_TYPE LIKE '%OLU%') AND och1.OCH_ID=ochId;
            FETCH v_ref_cursor INTO otherOchId, neId, ochFromSide, ochToSide;
            IF v_ref_cursor%FOUND THEN
                isPassThroughNE:=TRUE;
                addFacilityToList(neId, ochId);
                addFacilityToList(neId, otherOchId);

                -- this code does not work for a multi-degree OLA/OLU
                IF ochFromSide='A' AND ochToSide='B' THEN
                    addConnectionToList(neId, ochId, otherOchId);
                ELSIF ochFromSide='B' AND ochToSide='A' THEN
                    addConnectionToList(neId, otherOchId, ochId);
                END IF;
                IF thisOchPosInNextXC<>'BOTH' THEN
                    nextOchPosInNextXC:=thisOchPosInNextXC;
                ELSE
                    nextOchPosInNextXC:='BOTH'; -- this needs to change when OLA is not modelled as 2WAY?
                END IF;
                findDWDMLinkAndOtherSideOCHL(NVL(otherOchId,0), nextOchId);
                v_last_hop_och_id := findXCFromOCHX(NVL(nextOchId,0), nextOchPosInNextXC, 0, circuitType);
            END IF;
            CLOSE v_ref_cursor;
        END IF;

        IF v_ignore_duplicate  AND (ochId <> 0 AND isPassThroughNE=FALSE) THEN
            IF ochType like 'OCH%' then
            SELECT neId,otherOchId,ochFromEqptId,ochToEqptId,ochFromCpId,ochToCpId,fromSide,toSide,xcType,ccPath,otherOchType,otherOchLocation,crsId
                BULK COLLECT INTO neIdList,otherOchIdList,ochFromEqptIdList,ochToEqptIdList,ochFromCpIdList,ochToCpIdList,fromSideList,toSideList,xcTypeList,ccPathList,otherOchTypeList,otherOchLocationList,crsIdList
            FROM (
                SELECT crs.NE_ID neId,crs.CRS_TO_ID otherOchId,ochfrom.OCH_PARENT_ID ochFromEqptId,ochto.OCH_PARENT_ID ochToEqptId,nvl(fromCp.CARD_ID,0) ochFromCpId,nvl(toCp.CARD_ID,0) ochToCpId,ochfrom.OCH_DWDMSIDE fromSide,ochto.OCH_DWDMSIDE toSide,crs.CRS_CCTYPE xcType,crs.CRS_CCPATH ccPath,crs.CRS_TO_AID_TYPE otherOchType,'TO' otherOchLocation,crs.CRS_CKTID crsId
                FROM CM_CRS crs, CM_CHANNEL_OCH ochfrom, CM_CHANNEL_OCH ochto, CM_CARD fromCp, CM_CARD toCp
                WHERE thisOchPosInNextXC<>'TO' AND crs.CRS_FROM_ID =ochId AND crs.CRS_TO_ID<> dontFindMeId AND crs.CRS_FROM_ID=ochfrom.OCH_ID AND crs.CRS_TO_ID=ochto.OCH_ID
                 AND crs.NE_ID=fromCp.NE_ID(+) AND nvl(crs.CRS_FROM_CP_AID, '0')=fromCp.CARD_AID(+) AND crs.NE_ID=toCp.NE_ID(+) AND nvl(crs.CRS_TO_CP_AID, '0')=toCp.CARD_AID(+)
                --Above SQL gets all XCs in which supplied OCH can be either at 'FROM' or 'BOTH' location in 1 to 1 XC
                 UNION
                --Following SQL gets all XCs in which supplied OCH can be either at 'TO' or 'BOTH' location in 1 to 1 XC
                SELECT crs.NE_ID neId,crs.CRS_FROM_ID otherOchId,ochto.OCH_PARENT_ID ochFromEqptId,ochfrom.OCH_PARENT_ID ochToEqptId,nvl(fromCp.CARD_ID,0) ochFromCpId,nvl(toCp.CARD_ID,0) ochToCpId,ochfrom.OCH_DWDMSIDE fromSide,ochto.OCH_DWDMSIDE toSide,crs.CRS_CCTYPE xcType,crs.CRS_CCPATH ccPath,crs.CRS_FROM_AID_TYPE otherOchType,'FROM' otherOchLocation,crs.CRS_CKTID crsId
                FROM CM_CRS crs, CM_CHANNEL_OCH ochfrom, CM_CHANNEL_OCH ochto, CM_CARD fromCp, CM_CARD toCp
                WHERE thisOchPosInNextXC<>'FROM' AND crs.CRS_TO_ID =ochId AND crs.CRS_FROM_ID<> dontFindMeId AND crs.CRS_FROM_ID=ochfrom.OCH_ID AND crs.CRS_TO_ID=ochto.OCH_ID
                 AND crs.NE_ID=fromCp.NE_ID(+) AND nvl(crs.CRS_FROM_CP_AID, '0')=fromCp.CARD_AID(+) AND crs.NE_ID=toCp.NE_ID(+) AND nvl(crs.CRS_TO_CP_AID, '0')=toCp.CARD_AID(+)
                 UNION
                --Following SQL gets all XCs in which supplied OCH can be either at 'FROM' or 'TO' location. This sql is needed for 2WAY XC coming from 1 WAY, in a flipped situation
                SELECT crs.NE_ID neId,circuit_util.getOtherOCH(crs.CRS_FROM_ID,crs.CRS_TO_ID,ochId) otherOchId,circuit_util.getOtherOCHNumber(crs.CRS_TO_ID,crs.CRS_FROM_ID,ochId,ochfrom.OCH_PARENT_ID,ochto.OCH_PARENT_ID) ochFromEqptId,circuit_util.getOtherOCHNumber(crs.CRS_FROM_ID,crs.CRS_TO_ID,ochId,ochfrom.OCH_PARENT_ID,ochto.OCH_PARENT_ID) ochToEqptId,circuit_util.getOtherOCHNumber(crs.CRS_FROM_ID,crs.CRS_TO_ID,ochId,nvl(fromCp.CARD_ID,0),nvl(toCp.CARD_ID,0)) ochFromCpId,circuit_util.getOtherOCHNumber(crs.CRS_TO_ID,crs.CRS_FROM_ID,ochId,nvl(fromCp.CARD_ID,0),nvl(toCp.CARD_ID,0)) ochToCpId,circuit_util.getOtherOCHString(crs.CRS_FROM_ID,crs.CRS_TO_ID,ochId,ochfrom.OCH_DWDMSIDE,ochto.OCH_DWDMSIDE) fromSide,circuit_util.getOtherOCHString(crs.CRS_TO_ID,crs.CRS_FROM_ID,ochId,ochfrom.OCH_DWDMSIDE,ochto.OCH_DWDMSIDE) toSide,crs.CRS_CCTYPE xcType,crs.CRS_CCPATH ccPath,circuit_util.getOtherOCHString(crs.CRS_FROM_ID,crs.CRS_TO_ID,ochId,crs.CRS_FROM_AID_TYPE,crs.CRS_TO_AID_TYPE) otherOchType,circuit_util.getOtherOCHDirection(crs.CRS_FROM_ID,crs.CRS_TO_ID,ochId) otherOchLocation,crs.CRS_CKTID crsId
                FROM CM_CRS crs, CM_CHANNEL_OCH ochfrom, CM_CHANNEL_OCH ochto, CM_CARD fromCp, CM_CARD toCp
                WHERE (thisOchPosInNextXC='FROM' OR thisOchPosInNextXC='TO') AND (crs.CRS_FROM_ID =ochId OR crs.CRS_TO_ID =ochId) AND (crs.CRS_FROM_ID<> dontFindMeId AND crs.CRS_TO_ID<> dontFindMeId) AND crs.CRS_FROM_ID=ochfrom.OCH_ID AND crs.CRS_TO_ID=ochto.OCH_ID
                 AND crs.NE_ID=fromCp.NE_ID(+) AND nvl(crs.CRS_FROM_CP_AID, '0')=fromCp.CARD_AID(+) AND crs.NE_ID=toCp.NE_ID(+) AND nvl(crs.CRS_TO_CP_AID, '0')=toCp.CARD_AID(+) AND crs.CRS_CCTYPE like '%2WAY%'
                 UNION
                --Following SQL gets all protecting connections from supplied OCH-P/OCH-CP in which supplied OCH can be either at 'FROM' or 'BOTH' location in 2WAYPR(Add/Drop) or 1WAYBR(Add) connection
                SELECT crs.NE_ID neId,ochProt.OCH_ID otherOchId,ochfrom.OCH_PARENT_ID ochFromEqptId,ochProt.OCH_PARENT_ID ochToEqptId,0 ochFromCpId,0 ochToCpId,ochfrom.OCH_DWDMSIDE fromSide,ochProt.OCH_DWDMSIDE toSide,crs.CRS_CCTYPE xcType,crs.CRS_CCPATH ccPath,'OCH-L' otherOchType,'TO' otherOchLocation,crs.CRS_CKTID  crsId
                FROM CM_CRS crs, CM_CHANNEL_OCH ochfrom, CM_CHANNEL_OCH ochProt
                WHERE (ochfrom.OCH_TYPE = 'P' OR ochfrom.OCH_TYPE = 'CP' OR ochfrom.OCH_TYPE = '1') AND thisOchPosInNextXC<>'TO' AND crs.NE_ID = ochProt.NE_ID AND crs.CRS_PROTECTION=ochProt.OCH_AID AND ochfrom.OCH_ID=ochId AND crs.CRS_FROM_ID=ochfrom.OCH_ID
                 UNION
                --Following SQL gets all protecting connections from supplied OCH-P/OCH-CP in which supplied OCH can be either at 'TO' or 'BOTH' location in 2WAYPR(Add/Drop) or 1WAYPR(Drop)
                SELECT crs.NE_ID neId,ochProt.OCH_ID otherOchId,ochProt.OCH_PARENT_ID ochFromEqptId,ochto.OCH_PARENT_ID ochToEqptId,0 ochFromCpId,0 ochToCpId,ochProt.OCH_DWDMSIDE fromSide,ochto.OCH_DWDMSIDE toSide,crs.CRS_CCTYPE xcType,crs.CRS_CCPATH ccPath,'OCH-L' otherOchType,'FROM' otherOchLocation,crs.CRS_CKTID crsId
                FROM CM_CRS crs, CM_CHANNEL_OCH ochto, CM_CHANNEL_OCH ochProt
                WHERE (ochto.OCH_TYPE = 'P' OR ochto.OCH_TYPE = 'CP' OR ochto.OCH_TYPE = '1') AND thisOchPosInNextXC<>'FROM' AND crs.NE_ID = ochProt.NE_ID AND crs.CRS_PROTECTION=ochProt.OCH_AID AND ochto.OCH_ID=ochId AND crs.CRS_TO_ID=ochto.OCH_ID
                 UNION
                --Following SQL gets all connections to OCH-P/OCH-CP from supplied protecting OCH-L in which connected OCH-P/OCH-CP can be either at 'FROM' or 'BOTH' location in 2WAYPR(Add/Drop) or 1WAYBR(Add)
                SELECT crs.NE_ID neId,ochfrom.OCH_ID otherOchId,ochfrom.OCH_PARENT_ID ochFromEqptId,ochProt.OCH_PARENT_ID ochToEqptId,0 ochFromCpId,0 ochToCpId,ochfrom.OCH_DWDMSIDE fromSide,ochProt.OCH_DWDMSIDE toSide,crs.CRS_CCTYPE xcType,crs.CRS_CCPATH ccPath,SUBSTR(ochfrom.OCH_AID,1,INSTR(ochfrom.OCH_AID,'-',2,2)-1) otherOchType,'FROM' otherOchLocation,crs.CRS_CKTID  crsId
                FROM CM_CRS crs, CM_CHANNEL_OCH ochfrom, CM_CHANNEL_OCH ochProt
                WHERE (ochfrom.OCH_TYPE = 'P' OR ochfrom.OCH_TYPE = 'CP' OR ochfrom.OCH_TYPE = '1') AND thisOchPosInNextXC<>'FROM' AND crs.CRS_FROM_ID<> dontFindMeId AND crs.NE_ID = ochProt.NE_ID AND crs.CRS_PROTECTION=ochProt.OCH_AID AND ochProt.OCH_ID=ochId AND crs.CRS_FROM_ID=ochfrom.OCH_ID
                 UNION
                --Following SQL gets all connections to OCH-P/OCH-CP from supplied protecting OCH-L in which connected OCH-P/OCH-CP can be either at 'TO' or 'BOTH' location in 2WAYPR(Add/Drop) or 1WAYPR(Drop)
                SELECT crs.NE_ID neId,ochto.OCH_ID otherOchId,ochProt.OCH_PARENT_ID ochFromEqptId,ochto.OCH_PARENT_ID ochToEqptId,0 ochFromCpId,0 ochToCpId,ochProt.OCH_DWDMSIDE fromSide,ochto.OCH_DWDMSIDE toSide,crs.CRS_CCTYPE xcType,crs.CRS_CCPATH ccPath,SUBSTR(ochto.OCH_AID,1,INSTR(ochto.OCH_AID,'-',2,2)-1) otherOchType,'TO' otherOchLocation,crs.CRS_CKTID crsId
                FROM CM_CRS crs, CM_CHANNEL_OCH ochto, CM_CHANNEL_OCH ochProt
                WHERE (ochto.OCH_TYPE = 'P' OR ochto.OCH_TYPE = 'CP' OR ochto.OCH_TYPE = '1') AND thisOchPosInNextXC<>'TO' AND crs.CRS_TO_ID<> dontFindMeId AND crs.NE_ID = ochProt.NE_ID AND crs.CRS_PROTECTION=ochProt.OCH_AID AND ochProt.OCH_ID=ochId AND crs.CRS_TO_ID=ochto.OCH_ID
            );
            END IF;

            IF ochFromEqptIdList IS NOT NULL THEN
                ochCount:=ochFromEqptIdList.COUNT;
                circuit_util.print_line('Total OCH connections found2: '||ochCount);
            END IF;

            IF ochCount=0 THEN
                otherOchId := 0;
                if ochType = 'OCH-P' OR ochType LIKE 'OTU%' then
                   otherOchId := findFiberLinkFromOCH(ochId, thisOchPosInNextXC, 0, circuitType, v_fiberlink);
                end if;
                if otherOchId > 0 then
                   -- construct a fake och-p FIBER connection.
                   neIdList(1) := v_fiberlink.other_ne_id;
                   otherOchIdList(1) := v_fiberlink.other_och_id;
                   ochFromEqptIdList(1) := v_fiberlink.card_id;
                   ochToEqptIdList(1) := v_fiberlink.other_card_id;
                   ochFromCpIdList(1) := 0;
                   ochToCpIdList(1) := 0;
                   fromSideList(1) := '';
                   toSideList(1) := '';
                   xcTypeList(1) := 'FIBERLINK';
                   ccPathList(1) := '';
                   otherOchTypeList(1) := v_fiberlink.other_och_type;
                   otherOchLocationList(1) := 'TO';
                   crsIdList(1) := '';
                   ochCount := 1;
                elsif otherOchId < 0 then -- if otherOchId=0, means it's ODU CC
                   g_error:='Error(SP): OCH circuit is incomplete or far-end cross-connect missing in NE: '||ochId;
                   circuit_util.print_line('g_error='||g_error);
                   return v_last_hop_och_id;
                end if;
            END IF;
            circuit_util.print_line('Number of OCHs Connecting to '||ochId||' ='||ochCount);

              -- get crossconnect facility data
              -- crossconnect exist in same NE, so use NE id from first element (1 based index)
            IF ochCount>=1 THEN
                addFacilityToList(neIdList(1), ochId); -- just one from facility
            END IF;

            dontFindMeAgainId:=ochId;
            FOR i IN 1..ochCount LOOP
                IF ochFromCpIdList(i) > 0 AND ochToCpIdList(i) > 0 THEN
                    fromEqptId := ochFromCpIdList(i);
                    toEqptId := ochToCpIdList(i);
                ELSE
                    fromEqptId := ochFromEqptIdList(i);
                    toEqptId := ochToEqptIdList(i);
                END IF;

                IF otherOchTypeList(i) != 'OCH-L' THEN
                    v_trn_eqpt_id := ochToEqptIdList(i);
                ELSE
                    v_trn_eqpt_id := ochFromEqptIdList(i);
                END IF;

                IF i = 1 AND NOT g_rpt_start_cache.exists(ochId) THEN
                    g_rpt_start_cache(ochId) := g_rpt_start_id;
                ELSE
                    IF g_rpt_start_cache(ochId) != -1 AND g_rpt_start_id = -1 THEN
                        v_valid_second_och_xc := TRUE;
                        initRptGlobalVariable(g_rpt_start_cache(ochId));
                    END IF;
                END IF;

                IF circuit_util.g_log_enable THEN
                    circuit_util.PRINT_LINE('Find drop resource(i='||i||'): neId='||neIdList(i)||',ochId='||ochId||',otherOchId='||otherOchIdList(i)||',fromEqptId='||fromEqptId||',toEqptId='||toEqptId);
                    circuit_util.PRINT_LINE('Find drop resource(i='||i||'): g_circuit_type='||g_circuit_type||',otherOchTypeList(i)='||otherOchTypeList(i)||',otherOchId='||otherOchIdList(i)||',circuitType='||circuitType);
                END IF;
                -- get crossconnect facility data
                IF otherOchLocationList(i)='TO' THEN
                    crsFromFacilityKey := ochId;
                    crsToFacilityKey := otherOchIdList(i);
                ELSIF otherOchLocationList(i)='FROM' THEN
                    crsFromFacilityKey := otherOchIdList(i);
                    crsToFacilityKey := ochId;
                END IF;

                addFacilityToList(neIdList(i), otherOchIdList(i)); -- crs_to_id

                -- get supporting equipment in case of OPSM DP protection
                eqptOPSMProtId:=getOPSMDPProtectionEquipmentId(neIdList(i), ochId, otherOchIdList(i), otherRouteOchId);
                addEquipmentToList(neIdList(i),eqptOPSMProtId);

                -- get supporting equipment in case of OPSM 1+1 protection
                IF eqptOPSMProtId=0 THEN
                    eqptOPSMProtId:=getOPSM1Plus1ProtectionEqptId(neIdList(i), ochId, otherOchIdList(i), otherRouteOchId);
                    addEquipmentToList(neIdList(i),eqptOPSMProtId);
                END IF;

                -- get supporting equipment in case of SMTM protection
                IF eqptOPSMProtId=0 THEN
                    eqptSMTMProtId:=getSMTMProtectionEquipmentId(neIdList(i), fromEqptId, toEqptId, otherOchIdList(i));
                    addEquipmentToList(neIdList(i),eqptSMTMProtId);
                END IF;

                -- get supporting equipment in case of YCABLE protection
                IF eqptSMTMProtId=0 THEN
                    eqptYCABLEProtId:=getYCABLEProtectionEquipmentId(neIdList(i), fromEqptId, toEqptId, otherOchIdList(i));
                    addEquipmentToList(neIdList(i),eqptYCABLEProtId);
                END IF;

                  -- get crossconnect fromcp/tocp equipment/fiber data
                crsFromCPKey := fromEqptId;
                addEquipmentToList(neIdList(i),fromEqptId);
                crsToCPKey := toEqptId;
                addEquipmentToList(neIdList(i),toEqptId);
                if xcTypeList(i) <> 'FIBERLINK' then
                   addConnectionToList(neIdList(i), crsFromFacilityKey, crsToFacilityKey);
                end if;

                --Find next XCs orientation
                IF xcTypeList(i) LIKE '%2WAY%' THEN
                    IF thisOchPosInNextXC='BOTH' THEN
                        nextOchPosInNextXC:='BOTH';
                    ELSE
                        nextOchPosInNextXC:=thisOchPosInNextXC;
                    END IF;
                ELSIF xcTypeList(i) LIKE '%1WAY%' THEN
                    IF otherOchLocationList(i)='TO' THEN
                       nextOchPosInNextXC:='FROM';
                    ELSIF otherOchLocationList(i)='FROM' THEN
                       nextOchPosInNextXC:='TO';
                    END IF;
                END IF;

                  --Find other composite link/xc end based circuit_type
                IF g_circuit_type = 'ODU2' AND otherOchTypeList(i) = 'OCH-P' AND circuit_util.isOSMModule(NVL(otherOchIdList(i), 0)) THEN
                    IF processRptDrop=FALSE  THEN
                        processRptOchDrop(ochId, thisOchPosInNextXC, dontFindMeId, circuitType, C_findXCFromOCH);
                    END IF;
                    circuit_util.print_line('cross-connect other endpoint is OCH-P. circuitType is ODU2');
                    gotherochId := otherOchIdList(i);
                    gotheroduId := circuit_util.getMappingOduFromOchP(neIdList(i), NVL(gotherochId, 0));
                    IF gotheroduId = 0 THEN
                        circuit_util.print_line('******* (OCH) One End of Circuit Found, Terminated at OCH-P *******');
                        addFacilityToList(neIdList(i), gotherochId);
                    ELSE
                        findXCFromODU2(gotheroduId, nextOchPosInNextXC, 0, circuitType);
                    END IF;

                    IF eqptOPSMProtId<>0 THEN --t71mr00189332
                       IF processRptDrop=FALSE  OR v_valid_second_och_xc THEN
                          processRptOchDrop(ochId, thisOchPosInNextXC, dontFindMeId, circuitType, C_findXCFromOCH);
                       END IF;
                       circuit_util.print_line('OPSM protection found.');
                       findXCFromOCH(NVL(otherRouteOchId,0), nextOchPosInNextXC, 0, circuitType);
                       findDWDMLinkAndOtherSideOCHL(otherRouteOchId, otherOchId);
                       IF nextOchPosInNextXC='TO' THEN
                          v_last_hop_och_id := findXCFromOCHX(NVL(otherOchId,0), 'FROM', 0, circuitType);
                       ELSIF nextOchPosInNextXC='FROM' THEN
                          v_last_hop_och_id := findXCFromOCHX(NVL(otherOchId,0), 'TO', 0, circuitType);
                       ELSE
                          v_last_hop_och_id := findXCFromOCHX(NVL(otherOchId,0), 'BOTH', 0, circuitType);
                       END IF;
                    END IF;
                ELSIF circuitType = 'STS' AND otherOchTypeList(i) = 'OCH-P' AND circuit_util.isOSMModule(NVL(otherOchIdList(i), 0)) = FALSE THEN
                    circuit_util.print_line('cross-connect other endpoint is OCH-P. circuitType is STS');
                    IF processRptDrop=FALSE THEN
                        processRptOchDrop(ochId, thisOchPosInNextXC, dontFindMeId, circuitType, C_findXCFromOCH);
                    END IF;
                    OPEN v_ref_cursor FOR SELECT CARD_ID, CARD_AID, card.NE_ID, CARD_AID_SHELF, CARD_AID_SLOT FROM CM_CARD card, CM_CHANNEL_OCH och
                        WHERE card.NE_ID=neIdList(i) AND och.NE_ID=neIdList(i) AND OCH_ID=otherOchIdList(i) AND CARD_ID=OCH_PARENT_ID;
                    FETCH v_ref_cursor INTO g_other_card_id, g_other_card_aid, g_other_ne_id, othercardShelf, othercardSlot;
                    CLOSE v_ref_cursor;

                    IF g_other_card_id<>0 AND (g_other_card_aid LIKE 'SMTM%' OR g_other_card_aid LIKE 'SSM%') THEN
                        --circuit_util.print_line('Other CardId:'||g_other_card_id);
                        g_error:='';
                        stsIdList := V_B_STRING();
                        linePort:='';
                        timeSlot:='';
                        g_other_sts_id:=0;
                        g_other_sts_id:='';
                        g_other_sts_aid:='';

                        -- endpoint of composite link
                        OPEN v_ref_cursor FOR SELECT CARD_AID FROM CM_CARD WHERE CARD_ID=g_card_id;
                        FETCH v_ref_cursor INTO g_card_aid;
                        close v_ref_cursor;
                        linePort := SUBSTR(g_sts_aid, INSTR(g_sts_aid,'-',1,3)+1, 2);
                        -- cannot check for lineOrPort here sinec the other STS id may not exist during provisioning
                        IF (linePort='11' AND g_card_aid LIKE 'SMTM%') OR (linePort='1-' AND g_card_aid LIKE 'SSM%') THEN
                            timeSlot := SUBSTR(g_sts_aid, INSTR(g_sts_aid,'-',1,4)+1, 3);
                            -- convert timeslot for facility like: VC4, VC44C, VC416C, VC464C, VC4NV
                            IF g_sts_aid LIKE '%VC4%' THEN
                                timeSlot := circuit_util.convertTimeslotToVC4(g_ne_id, g_other_ne_id, timeSlot);
                            END IF;
                            -- map is required for STSnCNV only but no harm in comparing all STS types (btw nvalue comparison is implicit hence not required)

                            OPEN v_ref_cursor FOR SELECT nvl(STS_STS1MAP,'x') FROM CM_STS WHERE NE_ID=g_ne_id AND STS_AID=g_sts_aid;
                            FETCH v_ref_cursor INTO sts1map;
                            IF v_ref_cursor%NOTFOUND THEN
                                sts1map:=g_sts1map;
                            ELSE
                                IF sts1map='x' AND g_sts1map<>'x' THEN
                                   sts1map:=g_sts1map;
                                END IF;
                            END IF;
                            CLOSE v_ref_cursor;

                            -- convert timeslot for facility like: VC4, VC44C, VC416C, VC464C, VC4NV
                            IF g_sts_aid LIKE '%VC4%' AND sts1map <> 'x' THEN
                                sts1map := circuit_util.convertTimeslotToVC4(g_ne_id, g_other_ne_id, sts1map);
                            END IF;

                            -- find far-end line STS under this SMTM (g_other_card_id), use local map
                            circuit_util.print_line('find far-end line STS under this SMTM:g_other_ne_id='||g_other_ne_id||',g_other_card_id='||g_other_card_id||',g_sts_aid='||g_sts_aid);
                            g_other_sts_id:=0;
                            tempStr1 := SUBSTR(sts1map, 1, INSTR(sts1map,'&')-1); -- get the first time slot of the map which is good enough for VCG/CNV best-effort discovery
                            tempStr1 := nvl(tempStr1,sts1map); -- in case no '&' in sts1map
                            tmptimeSlot := timeSlot;
                            FOR l_sts IN ( SELECT sts_parent_id, sts_i_parent_type FROM cm_sts sts LEFT JOIN cm_card crd ON sts_aid_shelf=card_aid_shelf AND sts_aid_slot=card_aid_slot AND  sts.ne_id=crd.ne_id
                                    WHERE crd.ne_id=g_other_ne_id AND sts_aid_shelf=othercardShelf AND sts_aid_slot=othercardSlot AND sts_aid_sts=timeSlot AND sts_i_parent_type='STS' AND sts_port_or_line='Line'
                            ) LOOP --Process the STS passthrough. this side sts slot is not the first slot other side CNV
                                SELECT sts_aid_sts INTO tmptimeSlot FROM cm_sts WHERE sts_id=l_sts.sts_parent_id;
                            END LOOP;

                            OPEN v_ref_cursor FOR SELECT fac.STS_ID, fac.STS_AID, fac.sts_sts1map FROM CM_STS fac, CM_FACILITY pf, CM_CARD card WHERE
                                fac.NE_ID=g_other_ne_id AND pf.NE_ID=g_other_ne_id AND card.NE_ID=g_other_ne_id AND CARD_ID=g_other_card_id
                                AND pf.FAC_PARENT_ID=CARD_ID AND fac.STS_PARENT_ID=pf.FAC_ID
                                AND nvl(fac.STS_STS1MAP,'x') LIKE tempStr1||'%' AND fac.STS_PORT_OR_LINE='Line'
                                AND fac.sts_aid_sts = tmptimeSlot  ----AND SUBSTR(fac.STS_AID, INSTR(fac.STS_AID,'-',1,4)+1, 3)=timeSlot
                                AND fac.STS_AID like SUBSTR(g_sts_aid, 1, INSTR(g_sts_aid,'-')-1)||'%';
                            FETCH v_ref_cursor INTO g_other_sts_id, g_other_sts_aid, v_other_sts1map;
                            CLOSE v_ref_cursor;
                            tempStr1:='';

                            findPPGFromSts(g_other_ne_id, g_other_sts_id);
                            IF circuit_util.g_log_enable THEN
                                circuit_util.print_line('sts1map:'||sts1map||',g_sts1map:'||g_sts1map||',g_other_sts_id:'||g_other_sts_id||',g_other_sts_aid:'||g_other_sts_aid);
                            END IF;

                            IF g_other_sts_id<>0 THEN -- STS found
                                -- even though the far-end STS id is found this could be a composite CRS
                                IF sts1map='x' AND g_sts1map<>'x' THEN
                                    sts1map:=g_sts1map;
                                    fromCompositetMap:=g_sts1map;
                                    errFlag:=TRUE;
                                    tempStr1 := SUBSTR(g_sts_aid, 1, INSTR(g_sts_aid,'-')-1);
                                    SELECT decode(tempStr1,'STS1CNV','STS1','STS3CNV','STS3C','VC3NV','VC3','VC4NV','VC4',tempStr1) INTO tempStr1 FROM DUAL;
                                END IF;
                            ELSE -- STS not found
                                -- get the otherside line fac TP usage map: N=N/A and Y=A
                                OPEN v_ref_cursor FOR SELECT nvl(FAC_TPUSAGE,'') FROM CM_FACILITY pf, CM_CARD card WHERE CARD_ID=g_other_card_id AND pf.NE_ID=g_other_ne_id AND card.NE_ID=g_other_ne_id AND pf.FAC_PARENT_ID=CARD_ID AND  pf.FAC_PORT_OR_LINE='Line';
                                FETCH v_ref_cursor INTO tpUsage;
                                IF v_ref_cursor%FOUND THEN
                                    CLOSE v_ref_cursor;
                                    circuit_util.print_line('tpUsage='||tpUsage);
                                    OPEN v_ref_cursor FOR SELECT NE_TID from EMS_NE ne WHERE NE_ID=neIdList(i);
                                    FETCH v_ref_cursor INTO tempStr;
                                    CLOSE v_ref_cursor;

                                    g_error:='Error(SP): STS circuit far-end facility or cross-connect mismatch in NE: '||tempStr;
                                    circuit_util.print_line('g_error='||g_error);
                                    tempStr := SUBSTR(g_sts_aid, 1, INSTR(g_sts_aid,'-')-1);

                                    -- if near-end has no map
                                    IF sts1map='x' THEN
                                        tmptimeSlot := timeSlot;
                                        IF circuit_util.getVcNumberingBase(g_other_ne_id) = 16 AND tempStr != 'VC3' THEN
                                            tmptimeSlot := circuit_util.convertTimeslotVC4ToNonVC4(tmptimeSlot);
                                        END IF;

                                        IF (tempStr='STS1' OR tempStr='VC3') AND SUBSTR(tpUsage, to_number(tmptimeSlot), 1)='Y' THEN
                                            g_error:='';
                                        ELSIF (tempStr='STS3C' OR tempStr='VC4' OR tempStr='STS3T' OR tempStr='STM1T' ) AND SUBSTR(tpUsage, to_number(tmptimeSlot), 3)='YYY' THEN
                                            g_error:='';
                                        ELSIF (tempStr='STS12C' OR tempStr='VC44C' OR tempStr='STS12T' OR tempStr='STM4T') AND SUBSTR(tpUsage, to_number(tmptimeSlot), 12)='YYYYYYYYYYYY' THEN
                                            g_error:='';
                                        ELSIF (tempStr='STS48C' OR tempStr='VC416C' OR tempStr='STS48T' OR tempStr='STM16T') AND SUBSTR(tpUsage, to_number(tmptimeSlot), 48)='YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY' THEN
                                            g_error:='';
                                        ELSIF (tempStr='STS192C' OR tempStr='VC464C') AND SUBSTR(tpUsage, to_number(timeSlot), 192)='YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY' THEN
                                            g_error:='';
                                        END IF;
                                        circuit_util.print_line('g_error='||g_error);
                                    ELSE -- case CNV or composite CRS
                                        IF tempStr='STS1CNV' OR tempStr='STS1' THEN
                                            cnvCount:=1;
                                            subMap:='Y';
                                            tempStr1:='STS1';
                                        ELSIF tempStr='VC3NV' OR tempStr='VC3' THEN
                                            cnvCount:=1;
                                            subMap:='Y';
                                            tempStr1:='VC3';
                                        ELSIF tempStr='STS3CNV' OR tempStr='STS3C' THEN
                                            cnvCount:=3;
                                            subMap:='YYY';
                                            tempStr1:='STS3C';
                                        ELSIF tempStr='VC4NV' OR tempStr='VC4' THEN
                                            cnvCount:=3;
                                            subMap:='YYY';
                                            tempStr1:='VC4';
                                        END IF;

                                      -- verify if every far-end submap (n=?) is available
                                        errFlag:=TRUE;
                                        tempSts1map:=sts1map||'&' ;
                                        fromCompositetMap:=sts1map;
                                        IF (g_card_aid LIKE 'SMTM%' OR g_card_aid LIKE 'SSM%') AND (g_other_card_aid LIKE 'SMTM%' OR g_other_card_aid LIKE 'SSM%')
                                        THEN
                                            token := to_number(SUBSTR(tempSts1map, 1, INSTR(tempSts1map,'&',1,1)-1));
                                            IF token IS NOT NULL THEN
                                                LOOP
                                                    --circuit_util.print_line('TOKEN: '||token);
                                                    IF token IS NULL THEN
                                                        g_error:='';
                                                        circuit_util.print_line('g_error='||g_error);
                                                        errFlag:=FALSE;
                                                        circuit_util.print_line('All the far-end sub-map timeslots are available.');
                                                        EXIT;
                                                    END IF;

                                                    IF SUBSTR(tpUsage, token, cnvCount)=subMap THEN
                                                        tempSts1map:=SUBSTR(tempSts1map, INSTR(tempSts1map,'&',1,1)+1, length(tempSts1map));
                                                        IF tempSts1map IS NULL THEN
                                                            g_error:='';
                                                            circuit_util.print_line('g_error='||g_error);
                                                            errFlag:=FALSE;
                                                            circuit_util.print_line('All the far-end sub-map timeslots are available.');
                                                            EXIT;
                                                        END IF;
                                                    ELSE
                                                        EXIT;
                                                    END IF;
                                                    token := to_number(SUBSTR(tempSts1map, 1, INSTR(tempSts1map,'&',1,1)-1));
                                                END LOOP;
                                            END IF; --token IS NOT NULL
                                        END IF;
                                        circuit_util.print_line('Exit sub-map loop: ');
                                    END IF;--if near-end has no map
                                ELSE
                                    CLOSE v_ref_cursor;
                                END IF;
                            END IF; -- end of STS found or not found

                              -- handle case that far-end has some timeslots taken (could be composite split CRS)
                            IF errFlag=TRUE THEN
                                j:=1;
                                tempSts1map:=sts1map;
                                IF g_other_card_aid LIKE 'SMTM%' THEN
                                    otherlinePort:='11';
                                ELSIF g_other_card_aid LIKE 'SSM%' THEN
                                    otherlinePort:='1';
                                END IF;

                                -- get all far-end STS ids
                                portSts1map:='0';
                                LOOP
                                    IF tempSts1map<>'x' AND SUBSTR(tempSts1map, 1, INSTR(tempSts1map,'&',1,1)-1) IS NULL THEN
                                        token:=to_number(tempSts1map);
                                        errFlag:=FALSE;
                                    ELSE
                                        token := to_number(SUBSTR(tempSts1map, 1, INSTR(tempSts1map,'&',1,1)-1));
                                    END IF;
                                    IF circuit_util.g_log_enable THEN
                                        circuit_util.print_line('g_other_ne_id='||g_other_ne_id||' aid='||tempStr1||'-'||othercardShelf||'-'||othercardSlot||'-'||otherlinePort||'-'||token||'; g_sts_type='||g_sts_type);
                                    END IF;

                                    farStsId:=0;
                                    OPEN v_ref_cursor FOR SELECT STS_ID FROM CM_STS WHERE NE_ID=g_other_ne_id AND STS_AID=tempStr1||'-'||to_char(othercardShelf)||'-'||to_char(othercardSlot)||'-'||otherlinePort||'-'||to_char(token);
                                    FETCH v_ref_cursor INTO farStsId;
                                    CLOSE v_ref_cursor;

                                    IF farStsId<>0 THEN
                                        -- since we dont support diverse routing yet we only need to push the first STS
                                        -- But later the criteria should, if we have a different NE Id
                                        IF j=1 THEN
                                            stsIdList := V_B_STRING();
                                            stsIdList.extend;
                                            stsIdList(j):=to_char(farStsId);
                                            j:=j+1;
                                            crsExists:=findXCFromSTS(farStsId, g_other_ne_id, 0, TRUE/*dont process*/, TRUE/*dont add*/, '', '', nextStsId, nextStsTimeSlot, nextPortORLine);

                                            -- best effort VCG/CNV discovery changes
                                            IF crsExists=FALSE THEN
                                               errFlag:=TRUE;
                                               EXIT;
                                            END IF;

                                            IF nextPortORLine='Line' THEN--IF nextStsTimeSlot IS NOT NULL THEN
                                               g_sts1map:=nextStsTimeSlot; -- reset map and use it for the next hop
                                            ELSIF nextPortORLine='Port' THEN
                                               portSts1map:=nextStsTimeSlot;
                                            END if;
                                        ELSE
                                            crsExists:=findXCFromSTS(farStsId, g_other_ne_id, 0, TRUE/*dont process*/, FALSE, '', '',nextStsId, nextStsTimeSlot, nextPortORLine);

                                            -- best effort VCG/CNV discovery changes
                                            IF crsExists=FALSE THEN
                                               errFlag:=TRUE;
                                               EXIT;
                                            END IF;

                                            IF nextPortORLine='Line' THEN--IF nextStsTimeSlot IS NOT NULL THEN
                                               g_sts1map:=g_sts1map||'&'||nextStsTimeSlot;
                                            ELSIF nextPortORLine='Port' THEN
                                               portSts1map:=portSts1map||'&'||nextStsTimeSlot;
                                            END IF;
                                            j:=j+1;
                                        END IF;
                                    ELSE
                                        errFlag:=TRUE;
                                        EXIT;
                                    END IF;--farStsId<>0

                                    tempSts1map:=SUBSTR(tempSts1map, INSTR(tempSts1map,'&',1,1)+1, length(tempSts1map));
                                    IF errFlag=FALSE THEN
                                        EXIT;
                                    END IF;
                                END LOOP; --get all far-end STS ids

                                IF errFlag=FALSE THEN
                                    g_error:='';
                                    circuit_util.print_line('g_error='||g_error);
                                    circuit_util.print_line('far-end has individual STSnC: we got all the far-end STS ids');
                                    IF portSts1map <> '0' THEN
                                       toCompositeMap:=portSts1map;
                                    ELSE
                                       toCompositeMap:=g_sts1map;
                                    END IF;
                                ELSE
                                    circuit_util.print_line('far-end has individual STSnC: we fail to get all the far-end STS ids');
                                    -- best effort VCG/CNV discovery changes
                                    g_error:='';
                                    circuit_util.print_line('g_error='||g_error);
                                    toCompositeMap:=g_sts1map;
                                    errFlag:=FALSE;

                                    -- recalculate the fromCompositetMap to match the n-value of toCompositeMap
                                    FOR i IN 1..j-1 LOOP
                                        IF SUBSTR(fromCompositetMap, 1, INSTR(fromCompositetMap,'&',1,1)-1) IS NULL THEN
                                           token:=to_number(fromCompositetMap);
                                           tempSts1map:=tempSts1map||'&'||token;
                                        ELSE
                                           token := to_number(SUBSTR(fromCompositetMap, 1, INSTR(fromCompositetMap,'&',1,1)-1));
                                           IF i=1 THEN
                                              tempSts1map:=token;
                                           ELSE
                                              tempSts1map:=tempSts1map||'&'||token;
                                           END IF;
                                        END IF;
                                        fromCompositetMap:=SUBSTR(fromCompositetMap, INSTR(fromCompositetMap,'&',1,1)+1, length(fromCompositetMap));
                                    END LOOP;
                                    fromCompositetMap:=tempSts1map;
                                END IF;--errFlag
                            END IF; --handle case that far-end has some timeslots taken (could be composite split CRS)
                            IF circuit_util.g_log_enable THEN
                                circuit_util.print_line('g_other_ne_id:'||g_other_ne_id||',g_other_card_id:'||g_other_card_id||',g_other_card_aid:'||g_other_card_aid||'otherlinePort:'||otherlinePort||',timeSlot:'||timeSlot||',g_other_sts_id:'||g_other_sts_id||',stsIdList.COUNT:'||stsIdList.COUNT||',g_sts1map:'||g_sts1map);
                            END IF;

                            -- get the DWDM sides
                            OPEN v_ref_cursor FOR SELECT fibr1.CONN_DWDMSIDE, fibr2.CONN_DWDMSIDE FROM CM_FIBR_CONN fibr1, CM_FIBR_CONN fibr2
                                 WHERE fibr1.NE_ID=g_ne_id AND fibr2.NE_ID=g_other_ne_id AND fibr1.CONN_TO_ID=g_card_id AND fibr2.CONN_TO_ID=g_other_card_id;
                            FETCH v_ref_cursor INTO dwdmSideFrom, dwdmSideTo;
                            CLOSE v_ref_cursor;

                            IF dwdmSideFrom IS NULL AND dwdmSideTo IS NULL THEN -- required for OPSM only
                                OPEN v_ref_cursor FOR SELECT card1.CARD_DWDMSIDE, card2.CARD_DWDMSIDE FROM CM_CARD card1, CM_CARD card2 WHERE card1.CARD_ID=g_card_id AND card2.CARD_ID=g_other_card_id;
                                FETCH v_ref_cursor INTO dwdmSideFrom, dwdmSideTo;
                                CLOSE v_ref_cursor;
                            END IF;

                            --circuit_util.print_line('dwdmSideFrom:'||dwdmSideFrom||' dwdmSideTo:'||dwdmSideTo);
                            compFlag:=FALSE;
                            IF g_ne_id=g_other_ne_id THEN
                                IF dwdmSideFrom<>dwdmSideTo THEN
                                    compFlag:=TRUE;
                                END IF;
                            ELSE
                                compFlag:=TRUE;
                            END IF;
                        END IF; ----(linePort='11' AND g_card_aid LIKE 'SMTM%') OR (linePort='1-' AND g_card_aid LIKE 'SSM%')

                        circuit_util.print_line('~~~~~~~~~~~~~~~~~~~~ Finding OCH Circuit from cardId4:' ||g_card_id||',g_other_sts_id='||g_other_sts_id||' END');
                        -- in case of no individual STS (Composite split CRS) found, prepare for default processing
                        j:=1;
                        IF stsIdList.COUNT=0 THEN
                            stsIdList.extend;
                            stsIdList(j):=g_other_sts_id;
                        END IF;
                          --LOOP: process next hop for each STS CRS (only 1 for now)
                        LOOP
                            IF stsIdList.COUNT>=j THEN
                                g_other_sts_id:=stsIdList(j);
                                OPEN v_ref_cursor FOR SELECT NE_ID, STS_AID FROM CM_STS WHERE STS_ID=g_other_sts_id;
                                FETCH v_ref_cursor INTO g_other_ne_id, g_other_sts_aid;
                                CLOSE v_ref_cursor;
                                j:=j+1;
                            ELSE
                                EXIT;
                            END IF;

                            IF compFlag=TRUE THEN
                                IF g_other_sts_id<>0 THEN
                                    IF g_other_Sts_Aid LIKE '%NV%' AND g_sts_Aid NOT LIKE '%NV%' THEN
                                        g_sts_passthrough_circuit := TRUE;
                                        processStsPassthroughXc(g_ne_Id, g_sts_Aid, v_other_sts1map);
                                    END IF;
                                    addFacilityToList(g_ne_Id, g_other_Sts_Id); -- this is needed for partial routes
                                    IF g_sts_passthrough_circuit THEN
                                        v_other_sts1map:=substr(g_sts_Aid, 1, instr(g_sts_Aid,'-',-1)) || substr(g_other_Sts_Aid, instr(g_other_Sts_Aid,'-',-1)+1);
                                        addCompositeLinkToList(g_ne_Id,g_other_Ne_Id,v_other_sts1map,g_other_Sts_Aid,dwdmSideFrom,dwdmSideTo,0);
                                    ELSE
                                        addCompositeLinkToList(g_ne_Id,g_other_Ne_Id,g_sts_Aid,g_other_Sts_Aid,dwdmSideFrom,dwdmSideTo,0);
                                    END IF;
                                ELSE -- construct the g_other_sts_aid since it is asymmetric and we still need a composite link
                                      circuit_util.print_line('g_sts1map='||g_sts1map||', g_sts_aid='||g_sts_aid||', g_other_card_aid='||g_other_card_aid);
                                    IF g_other_card_aid LIKE 'SMTM%' THEN
                                        otherLinePort:='11';
                                    ELSE
                                        otherLinePort:='1';
                                    END IF;

                                    OPEN v_ref_cursor FOR SELECT STS_AID FROM CM_STS WHERE NE_ID=g_other_ne_id AND STS_AID LIKE '%'||SUBSTR(g_other_card_aid, INSTR(g_other_card_aid,'-')+1, LENGTH(g_other_card_aid))||'-'||otherLinePort||'-'||timeSlot; -- check for mismatch fac type
                                    FETCH v_ref_cursor INTO tempStr;

                                    IF v_ref_cursor%NOTFOUND THEN
                                        IF g_sts1map<>'x' AND g_other_card_aid LIKE 'SMTM%'THEN
                                            IF g_sts_aid LIKE 'STS1%' THEN
                                                tempStr1:='STS1CNV-';
                                            ELSIF g_sts_aid LIKE 'VC3%' THEN
                                                tempStr1:='VC3NV-';
                                            ELSIF g_sts_aid LIKE 'STS3%' THEN
                                                tempStr1:='STS3CNV-';
                                            ELSIF g_sts_aid LIKE 'VC4%' THEN
                                                tempStr1:='VC4NV-';
                                            END IF;
                                        ELSE -- case SSM and also default, pls dont change this order
                                            --get the fac_aid_type from fac_aid
                                            IF g_sts_aid LIKE 'STS%' OR
                                               g_sts_aid LIKE 'VC%' OR
                                               g_sts_aid LIKE 'STM%'
                                            THEN
                                                SELECT substr(g_sts_aid, 1, instr(g_sts_aid,'-')) INTO tempStr1 FROM dual;
                                            END IF;
                                        END IF;

                                        IF g_other_card_aid LIKE 'SMTM%' THEN
                                            g_other_sts_aid := tempStr1||SUBSTR(g_other_card_aid, INSTR(g_other_card_aid,'-')+1, LENGTH(g_other_card_aid))||'-11-'||timeSlot;
                                        ELSE
                                            g_other_sts_aid := tempStr1||SUBSTR(g_other_card_aid, INSTR(g_other_card_aid,'-')+1, LENGTH(g_other_card_aid))||'-1-'||timeSlot;
                                        END IF;

                                        addCompositeLinkToList(g_ne_id,g_other_ne_id,g_sts_aid,g_other_sts_aid,dwdmSideFrom,dwdmSideTo,0);
                                    END IF;
                                    CLOSE v_ref_cursor;
                                END IF;
                            END IF; --compFlag=TRUE

                            IF g_other_sts_id<>0 AND errFlag=FALSE THEN
                                prevHopStsAid:=g_sts_aid;
                                prevHopNeId:=g_ne_id;
                                prevHopCardId:=g_card_id;

                                crsExists:=findXCFromSTS(g_other_sts_id, g_other_ne_id, 0, FALSE/*default*/, FALSE, fromCompositetMap, toCompositeMap, nextStsId, nextStsTimeSlot, nextPortORLine);

                                g_sts_aid:=prevHopStsAid;
                                g_ne_id:=prevHopNeId;
                                g_card_id:=prevHopCardId;
                            END IF;
                        END LOOP; --END LOOP: process next hop for each STS CRS (only 1 for now)
                    ELSIF g_other_card_id<>0 AND g_other_card_aid LIKE 'OTNM%' THEN

                        -- Added for OTNM
                        g_error:='';
                        linePort:='';
                        timeSlot:='';
                        g_other_sts_id:=0;
                        g_other_sts1map:='';
                        exprate:='NA';

                        IF (g_sts_aid LIKE 'ODU1-C%') THEN
                            timeSlot := SUBSTR(g_sts_aid, INSTR(g_sts_aid,'-',1,4)+1, 1);
                        ELSE
                            timeSlot := SUBSTR(g_sts_aid, INSTR(g_sts_aid,'-',1,3)+1, 2);
                        END IF;

                          -- Get the exprate and aid type
                        OPEN v_ref_cursor FOR SELECT Nvl(FAC_EXPRATE,FAC_SIGTYPE), FAC_AID_TYPE FROM CM_FACILITY
                            WHERE NE_ID=g_ne_id AND nvl(FAC_STS1MAP,'x')=g_sts1map
                            AND FAC_PARENT_ID=g_card_id AND INSTR(FAC_AID,'ODU1-C') = 0;
                        FETCH v_ref_cursor INTO exprate, g_sts_type;
                        CLOSE v_ref_cursor;

                        g_other_sts_id:=0;
                        sts1map := circuit_util.convertTimeslotToVC4(g_ne_id, g_other_ne_id, g_sts1map);

                        -- retrieve the other facility of the same type that is occupying all of the near-end timeslots
                        IF(g_sts_type = 'GOPT') THEN
                        -- query for gopt facilities and matching exprate
                            OPEN v_ref_cursor FOR SELECT fac.FAC_ID, fac.FAC_AID, Nvl(fac.FAC_STS1MAP,null) FROM CM_FACILITY fac, CM_CARD card
                                WHERE fac.NE_ID = g_other_ne_id AND CARD.NE_ID=fac.NE_ID AND nvl(fac.FAC_STS1MAP,'x')=sts1map
                                   AND INSTR(fac.FAC_AID,'ODU1-C') = 0 AND fac.FAC_AID_TYPE = g_sts_type
                                   AND fac.FAC_PARENT_ID=g_other_card_id
                                   AND Nvl(fac.FAC_EXPRATE,FAC_SIGTYPE) = exprate;
                            FETCH v_ref_cursor INTO g_other_sts_id, g_other_sts_aid, g_other_sts1map;
                            CLOSE v_ref_cursor;
                        ELSE
                              -- query for non-gopt facilities, no exprate
                            OPEN v_ref_cursor FOR SELECT fac.FAC_ID, fac.FAC_AID, Nvl(fac.FAC_STS1MAP,null) FROM CM_FACILITY fac, CM_CARD card
                                WHERE fac.NE_ID = g_other_ne_id AND CARD.NE_ID=fac.NE_ID AND nvl(fac.FAC_STS1MAP,'x')=sts1map
                                 AND INSTR(fac.FAC_AID,'ODU1-C') = 0 AND fac.FAC_AID_TYPE = g_sts_type
                                 AND fac.FAC_PARENT_ID=g_other_card_id;
                              FETCH v_ref_cursor INTO g_other_sts_id, g_other_sts_aid, g_other_sts1map;
                            close v_ref_cursor;
                        END IF;

                        IF g_other_sts_id=0 THEN
                            -- when no g_other_sts_id match g_sts_type and all of the near-end timeslots
                            -- then try retrieve any facility that is occupying some or all of the near-end timeslots
                            OPEN v_ref_cursor FOR SELECT fac.FAC_ID, fac.FAC_AID, Nvl(fac.FAC_STS1MAP,null) FROM CM_FACILITY fac, CM_CARD card
                                WHERE fac.NE_ID = g_other_ne_id AND CARD.NE_ID=fac.NE_ID AND (0=findTimeslot(sts1map, nvl(fac.FAC_STS1MAP,'x')))
                                  AND INSTR(fac.FAC_AID,'ODU1-C') = 0 AND fac.FAC_PARENT_ID=g_other_card_id;
                            FETCH v_ref_cursor INTO g_other_sts_id, g_other_sts_aid, g_other_sts1map;
                            close v_ref_cursor;
                            -- if facility found, then it is a mistched facility that is occupying some or all the timeslot(s)
                            IF g_other_sts_id<>0 THEN
                                OPEN v_ref_cursor FOR SELECT NE_TID from EMS_NE ne WHERE NE_ID=neIdList(i);
                                FETCH v_ref_cursor INTO tempStr;
                                CLOSE v_ref_cursor;
                                g_error:='Error(SP): Subrate circuit far-end facility mismatch in NE: ' || tempStr;
                            END IF;
                        END IF;

                        circuit_util.print_line('g_other_ne_id:'||g_other_ne_id||',g_other_card_id:'||g_other_card_id||',linePort:'||linePort||',timeSlot:'||timeSlot||',nextStsId:'||g_other_sts_id);
                        circuit_util.print_line('dwdmSideFrom:'||dwdmSideFrom||' dwdmSideTo:'||dwdmSideTo);
                        IF dwdmSideFrom IS NULL AND dwdmSideTo IS NULL THEN -- required for OPSM only
                            OPEN v_ref_cursor FOR SELECT card1.CARD_DWDMSIDE, card2.CARD_DWDMSIDE FROM CM_CARD card1, CM_CARD card2 WHERE card1.CARD_ID=g_card_id AND card2.CARD_ID=g_other_card_id;
                            FETCH v_ref_cursor INTO dwdmSideFrom, dwdmSideTo;
                            CLOSE v_ref_cursor;
                        END IF;

                        circuit_util.print_line('dwdmSideFrom:'||dwdmSideFrom||' dwdmSideTo:'||dwdmSideTo);
                        compFlag:=FALSE;

                        IF g_ne_id=g_other_ne_id THEN
                            IF dwdmSideFrom<>dwdmSideTo THEN
                                compFlag:=TRUE;
                            END IF;
                        ELSE
                            compFlag:=TRUE;
                        END IF;

                        IF compFlag=TRUE THEN
                            IF g_other_sts_id<>0 THEN
                                addFacilityToList(g_ne_id, g_other_sts_id); -- this is needed for partial routes
                                addCompositeLinkToList(g_ne_id,g_other_ne_id,circuit_util.getOTNMXCedLineFacility(Nvl(g_other_sts1map,Nvl(g_sts1map,'')), g_ne_id, Nvl(g_sts_aid,'')), circuit_util.getOTNMXCedLineFacility(Nvl(g_other_sts1map,Nvl(sts1map,'')), g_other_ne_id, Nvl(g_other_sts_aid,'')),dwdmSideFrom,dwdmSideTo,0);

                                OPEN v_ref_cursor FOR SELECT f.fac_id, x.crs_ccpath FROM cm_facility f, cm_crs x, cm_channel_och o, cm_card c
                                WHERE f.ne_id=g_other_ne_id AND f.fac_parent_id=c.card_id
                                AND f.fac_aid=circuit_util.getOTNMXCedLineFacility(Nvl(g_sts1map,Nvl(g_sts1map,'')), neId, Nvl(g_other_sts_aid,''))
                                AND ((x.crs_from_aid_type='OCH-P' AND x.crs_from_id=o.och_id ) OR (x.crs_to_aid_type='OCH-P' AND x.crs_to_id=o.och_id))
                                AND o.och_parent_id = c.card_id;
                                FETCH v_ref_cursor INTO ycableWorkingId,ycableCcpath;
                                CLOSE v_ref_cursor;
                                IF ycableWorkingId IS NOT NULL THEN
                                    addFacilityToList(g_ne_id, ycableWorkingId);
                                    IF ycableCcpath LIKE 'ADD%' THEN
                                       addSTSConnectionToList(g_other_ne_id, g_other_sts_id,ycableWorkingId,g_sts1map, NULL);
                                    ELSE
                                       addSTSConnectionToList(g_other_ne_id, ycableWorkingId,g_other_sts_id, NULL, g_sts1map);
                                    END IF;
                                END IF;
                                --add for port fac YCABLE protection
                                OPEN v_ref_cursor FOR SELECT FAC_WORKINGID,FAC_PROTECTIONID,decode(g_other_sts_id, FAC_WORKINGID,FAC_PROTECTIONID, FAC_WORKINGID)
                                  FROM CM_FACILITY WHERE FAC_ID = g_other_sts_id AND FAC_SCHEME = 'YCABLE';
                                FETCH v_ref_cursor INTO ycableWorkingId,ycableProtectionId,ycableFacId;
                                CLOSE v_ref_cursor;
                                IF ycableFacId > 0 THEN
                                    addFFPToList(neIdList(i),ycableWorkingId,ycableProtectionId);
                                    OPEN v_ref_cursor FOR SELECT FAC_AID,FAC_PARENT_ID,NE_ID FROM CM_FACILITY WHERE FAC_ID = ycableFacId;
                                    FETCH v_ref_cursor INTO ycableFacAid,ycableEqptId,ycableNeId;
                                    CLOSE v_ref_cursor;
                                    findOCHCircuitAndOtherSideSTS(ycableFacAid, ycableEqptId, ycableNeId);
                                END IF;
                            ELSE -- construct the g_other_sts_aid since it is asymmetric and we still need a composite link
                                OPEN v_ref_cursor FOR SELECT FAC_AID FROM CM_FACILITY WHERE NE_ID=g_other_ne_id AND FAC_AID LIKE '%'||'ODU1-C'||SUBSTR(g_other_card_aid, INSTR(g_other_card_aid,'-')+1, LENGTH(g_other_card_aid))||'-1'||'%';
                                FETCH v_ref_cursor INTO tempStr;
                                IF v_ref_cursor%NOTFOUND THEN
                                    IF (g_sts_aid LIKE 'ODU1-C%') THEN
                                        g_other_sts_aid := SUBSTR(g_sts_aid, 1, INSTR(g_sts_aid,'-',1,2))||SUBSTR(g_other_card_aid, INSTR(g_other_card_aid,'-')+1, LENGTH(g_other_card_aid))||'-'||timeSlot;
                                    ELSE
                                        g_other_sts_aid := SUBSTR(g_sts_aid, 1, INSTR(g_sts_aid,'-'))||SUBSTR(g_other_card_aid, INSTR(g_other_card_aid,'-')+1, LENGTH(g_other_card_aid))||'-'||timeSlot;
                                    END IF;

                                    addFacilityToList(g_ne_id, circuit_util.getFacilityID(g_ne_id, circuit_util.getOTNMXCedLineFacility(Nvl(sts1map,''), g_ne_id, Nvl(g_sts_aid,''))));
                                    addFacilityToList(g_other_ne_id, circuit_util.getFacilityID(g_other_ne_id,circuit_util.getOTNMXCedLineFacility(Nvl(sts1map, ''), g_other_ne_id, Nvl(g_other_sts_aid, ''))));
                                    addCompositeLinkToList(g_ne_id,g_other_ne_id,circuit_util.getOTNMXCedLineFacility(Nvl(sts1map,''), g_ne_id, Nvl(g_sts_aid,'')), circuit_util.getOTNMXCedLineFacility(Nvl(sts1map, ''), g_other_ne_id, Nvl(g_other_sts_aid, '')),dwdmSideFrom,dwdmSideTo,0);
                                END IF;
                                CLOSE v_ref_cursor;
                            END IF;
                        END IF;

                        circuit_util.print_line('~~~~~~~~~~~~~~~~~~~~ Finding OCH Circuit from cardId1:' ||g_card_id||' END');
                        checkForDuplicateProcessing(to_char(g_card_id), doesExists);

                        IF g_other_sts_id<>0 THEN
                            --checkForDuplicateProcessingSTS(to_char(g_other_card_id), doesExists); -- add every OCH endpoint, to avoid re-processing in reverse dir
                            --IF doesExists=0 THEN
                             -- preserve the prev och HOP details before entering next hop
                            prevHopStsAid:=g_sts_aid;
                            prevHopNeId:=g_ne_id;
                            prevHopCardId:=g_card_id;

                            crsExists:=findXCFromSTS(g_other_sts_id, g_other_ne_id, 0, FALSE /*default*/, FALSE, '', '', nextStsId, nextStsTimeSlot, nextPortORLine);

                            g_sts_aid:=prevHopStsAid;
                            g_ne_id:=prevHopNeId;
                            g_card_id:=prevHopCardId;
                        END IF;
                    ELSIF g_other_card_id<>0 AND g_other_card_aid LIKE 'FGTMM%' THEN
                        circuit_util.print_line('Other CardId is FGTMM:'||g_other_card_id||' g_sts_aid='||g_sts_aid);
                        g_error:='';
                        linePort:='';
                        timeSlot:='';
                        g_other_sts_id:=0;
                        g_other_sts_id:='';
                        g_other_sts_aid:='';

                        -- endpoint of composite link
                        OPEN v_ref_cursor FOR SELECT CARD_AID FROM CM_CARD WHERE CARD_ID=g_card_id;
                        FETCH v_ref_cursor INTO g_card_aid;
                        close v_ref_cursor;
                        linePort := SUBSTR(g_sts_aid, INSTR(g_sts_aid,'-',1,3)+1, 1);
                        IF linePort='5' AND g_card_aid LIKE 'FGTMM%' THEN -- cannot check for lineOrPort here sinec the other STS id may not exist during provisioning
                            timeSlot := SUBSTR(g_sts_aid, INSTR(g_sts_aid,'-',1,4)+1, 3);

                            -- find line STS under this SMTM (g_other_card_id)
                            g_other_sts_id:=0;
                            OPEN v_ref_cursor FOR SELECT fac.FAC_ID, fac.FAC_AID FROM CM_FACILITY fac, CM_CHANNEL_OCH pf, CM_CARD card WHERE fac.NE_ID=g_other_ne_id AND pf.NE_ID=g_other_ne_id AND card.NE_ID=g_other_ne_id AND CARD_ID=g_other_card_id AND pf.OCH_PARENT_ID=CARD_ID AND fac.FAC_PARENT_ID=pf.OCH_ID AND fac.FAC_PORT_OR_LINE='Line' AND SUBSTR(fac.FAC_AID, INSTR(fac.FAC_AID,'-',1,4)+1, 3)=timeSlot AND fac.FAC_AID like SUBSTR(g_sts_aid, 1, INSTR(g_sts_aid,'-')-1)||'%';
                            FETCH v_ref_cursor INTO g_other_sts_id, g_other_sts_aid;
                            close v_ref_cursor;

                            circuit_util.print_line('g_other_sts_id:'||g_other_sts_id||',g_other_sts_aid:'||g_other_sts_aid);
                            -- get the DWDM sides
                            OPEN v_ref_cursor FOR SELECT fibr1.CONN_DWDMSIDE, fibr2.CONN_DWDMSIDE FROM CM_FIBR_CONN fibr1, CM_FIBR_CONN fibr2
                              WHERE fibr1.NE_ID=g_ne_id AND fibr2.NE_ID=g_other_ne_id AND fibr1.CONN_TO_ID=g_card_id AND fibr2.CONN_TO_ID=g_other_card_id;
                            FETCH v_ref_cursor INTO dwdmSideFrom, dwdmSideTo;
                            CLOSE v_ref_cursor;

                            IF dwdmSideFrom IS NULL AND dwdmSideTo IS NULL THEN -- required for OPSM only
                                OPEN v_ref_cursor FOR SELECT card1.CARD_DWDMSIDE, card2.CARD_DWDMSIDE FROM CM_CARD card1, CM_CARD card2 WHERE card1.CARD_ID=g_card_id AND card2.CARD_ID=g_other_card_id;
                                FETCH v_ref_cursor INTO dwdmSideFrom, dwdmSideTo;
                                CLOSE v_ref_cursor;
                            END IF;

                            circuit_util.print_line('dwdmSideFrom:'||dwdmSideFrom||' dwdmSideTo:'||dwdmSideTo);
                            compFlag:=FALSE;
                            IF g_ne_id=g_other_ne_id THEN
                                IF dwdmSideFrom<>dwdmSideTo THEN
                                   compFlag:=TRUE;
                                END IF;
                            ELSE
                                compFlag:=TRUE;
                            END IF;
                        END IF;

                        circuit_util.print_line('~~~~~~~~~~~~~~~~~~~~ Finding OCH Circuit from cardId5:' ||g_card_id||' END');
                        IF compFlag=TRUE THEN
                            IF g_other_sts_id<>0 THEN
                                addFacilityToList(g_ne_id, g_other_sts_id); -- this is needed for partial routes
                                addCompositeLinkToList(g_ne_id,g_other_ne_id,g_sts_aid,g_other_sts_aid,dwdmSideFrom,dwdmSideTo,0);
                                -- add for port fac and odu and odu XC
                                OPEN v_ref_cursor FOR SELECT f1.Fac_Id, x.crs_odu_from_id, x.crs_odu_to_id
                                FROM CM_FACILITY f1, CM_FACILITY o1, CM_FACILITY o2, CM_CRS_ODU x
                                WHERE o2.Fac_Id = g_other_sts_id AND f1.NE_ID = o2.ne_id AND o1.ne_id = o2.ne_id AND f1.fac_id = o1.fac_parent_id
                                AND o2.fac_oppside_id = o1.fac_id AND ( x.crs_odu_from_id = g_other_sts_id OR x.crs_odu_to_id = g_other_sts_id );

                                FETCH v_ref_cursor INTO portFacId, portOduId1, portOduId2;
                                CLOSE v_ref_cursor;
                                IF portFacId > 0 THEN
                                   addFacilityToList(neIdList(i), portFacId);
                                   addFacilityToList(neIdList(i), portOduId1);
                                   addFacilityToList(neIdList(i), portOduId2);
                                   addSTSConnectionToList(neIdList(i), portOduId1,portOduId2,g_sts1map, NULL);
                                END IF;
                                --add for port fac YCABLE protection
                                OPEN v_ref_cursor FOR SELECT f.FAC_WORKINGID,f.FAC_PROTECTIONID, decode(f.FAC_ID, f.FAC_WORKINGID, f.FAC_PROTECTIONID, f.FAC_PROTECTIONID, f.FAC_WORKINGID,NULL)
                                    FROM CM_FACILITY f, CM_FACILITY o WHERE o.FAC_OPPSIDE_ID = g_other_sts_id AND f.FAC_ID = o.FAC_PARENT_ID AND f.FAC_SCHEME = 'YCABLE';
                                FETCH v_ref_cursor INTO ycableWorkingId,ycableProtectionId,ycableFacId;
                                CLOSE v_ref_cursor;
                                IF ycableFacId > 0 THEN
                                    addFFPToList(neIdList(i),ycableWorkingId,ycableProtectionId);
                                    OPEN v_ref_cursor FOR SELECT o.Fac_Id FROM CM_FACILITY f, CM_FACILITY o WHERE f.NE_ID = o.NE_ID AND f.fac_id = o.fac_parent_id AND f.Fac_Id = ycableFacId;
                                    FETCH v_ref_cursor INTO ycableoduId;
                                    CLOSE v_ref_cursor;
                                    IF ycableoduId > 0 THEN
                                       crsExists:=findXCFromSTS(ycableoduId, g_other_ne_id, 0, FALSE /*default*/, FALSE, '', '', nextStsId, nextStsTimeSlot, nextPortORLine);
                                    END IF;
                                END IF;
                                g_error:='';
                            ELSE -- construct the g_other_sts_aid since it is asymmetric and we still need a composite link
                                circuit_util.print_line('g_sts_aid='||g_sts_aid||', g_other_card_aid='||g_other_card_aid);
                                OPEN v_ref_cursor FOR SELECT STS_AID FROM CM_STS WHERE NE_ID=g_other_ne_id AND STS_AID LIKE '%'||SUBSTR(g_other_card_aid, INSTR(g_other_card_aid,'-')+1, LENGTH(g_other_card_aid))||'-11-'||timeSlot; -- check for mismatch fac type
                                FETCH v_ref_cursor INTO tempStr;
                                IF v_ref_cursor%NOTFOUND THEN
                                    -- case SSM and also default, pls dont change this order
                                    IF g_sts_aid LIKE 'STS%' OR
                                       g_sts_aid LIKE 'VC%' OR
                                       g_sts_aid LIKE 'STM%'
                                    THEN
                                     --Get g_sts_aid_type and '-', for STS3C-2-2-3 ---> STS3C-
                                        SELECT substr(g_sts_aid, 1, instr(g_sts_aid,'-')) INTO tempStr1 FROM dual;
                                    END IF;
                                    g_other_sts_aid := tempStr1||SUBSTR(g_other_card_aid, INSTR(g_other_card_aid,'-')+1, LENGTH(g_other_card_aid))||'-5-'||timeSlot;
                                    addCompositeLinkToList(g_ne_id,g_other_ne_id,g_sts_aid,g_other_sts_aid,dwdmSideFrom,dwdmSideTo,0);
                                    g_error:='';
                                END IF;
                                CLOSE v_ref_cursor;
                            END IF;
                        END IF;
                        IF g_other_sts_id<>0 AND errFlag=FALSE THEN
                                --checkForDuplicateProcessingSTS(to_char(g_other_card_id), doesExists); -- add every OCH endpoint, to avoid re-processing in reverse dir
                                --IF doesExists=0 THEN
                                -- preserve the prev och HOP details before entering next hop
                                prevHopStsAid:=g_sts_aid;
                                prevHopNeId:=g_ne_id;
                                prevHopCardId:=g_card_id;
                                crsExists:=findXCFromSTS(g_other_sts_id, g_other_ne_id, 0, FALSE/*default*/, FALSE, fromCompositetMap, toCompositeMap, nextStsId, nextStsTimeSlot, nextPortORLine);
                                g_sts_aid:=prevHopStsAid;
                                g_ne_id:=prevHopNeId;
                                g_card_id:=prevHopCardId;
                        END IF;
                    ELSE
                       --check if it is CP Regen OEO, which is OCHP-OCHP connection
                       FOR l_och1 IN (SELECT ne_tid, ne_type, ne_stype, shelf_subtype, card1.card_aid_type, och1.och_dwdmside, och1.och_aid_shelf, och1.och_aid_slot, och1.och_aid_port
                            FROM cm_card card1, cm_shelf sh, ems_ne ne, cm_channel_och och1
                            WHERE instr(ne.ne_stype,'OLA')=0 AND card1.card_id=och1.och_parent_id AND sh.ne_id=och1.ne_id AND sh.shelf_aid_shelf=och1.och_aid_shelf AND ne.ne_id=och1.ne_id AND och1.och_id=otherOchIdList(i)
                        ) LOOP
                            otherOchId := findNonTrmCrsOeo(
                                neIdList(i), l_och1.ne_tid, l_och1.ne_type,
                                l_och1.ne_stype, l_och1.shelf_subtype, ccPathList(i),
                                xcTypeList(i), l_och1.card_aid_type,  l_och1.och_aid_shelf,
                                l_och1.och_aid_slot, l_och1.och_aid_port,  otherOchIdList(i),
                                ochId, l_och1.och_dwdmside, circuitType
                            );
                            IF nvl(otherOchId, 0) != 0 THEN
                                circuit_util.print_line('OCHP-OCHP OEO Regen is found from '|| otherOchIdList(i));
                                findDWDMLinkAndOtherSideOCHL(otherOchId, otherOchId);
                                v_last_hop_och_id := findXCFromOCHX(otherOchId, nextOchPosInNextXC, 0, circuitType); -- '0' because it's just starting point in this NE
                                v_ochp_oeo := TRUE;
                            END IF;
                        END LOOP;
                        -- if it is not a CP regen OEO
                        IF v_ochp_oeo = FALSE and g_odu_tribslots(3) is null THEN
                          OPEN v_ref_cursor FOR SELECT NE_TID from EMS_NE ne WHERE NE_ID=neIdList(i);
                          FETCH v_ref_cursor INTO tempStr;
                          g_error:='Error(SP): OCH circuit far-end equipment is not SMTM or OTNM or FGTMM type in NE: '||tempStr;
                          CLOSE v_ref_cursor;
                        END IF;
                    END IF;

                    circuit_util.print_line('******* (STS) One End of Circuit Found *******');
                ELSIF otherOchTypeList(i) = 'OCH-P' OR otherOchTypeList(i) = 'OCH-CP' OR otherOchTypeList(i) = 'OCH-BP' OR otherOchTypeList(i) = 'OCH' THEN
                    circuit_util.print_line('cross-connect other endpoint is OCH-P/CP/BP/1.');
                    IF circuit_util.isPassthrLink(neIdList(i), NVL(otherOchTypeList(i),''), eqptOPSMProtId, eqptSMTMProtId) THEN
                        findPassthrLinkAndOtherSideOCH(neIdList(i),NVL(otherOchIdList(i),0),NVL(otherOchTypeList(i),''),crsIdList(i),nextOchPosInNextXC,circuitType,otherOchId);
                        v_last_hop_och_id := findXCFromOCHX(NVL(otherOchId,0), nextOchPosInNextXC, 0, circuitType); -- '0' because it's just starting point in this NE
                    ELSIF circuit_util.isOSMModule(NVL(otherOchIdList(i),0)) THEN
                        IF processRptDrop=FALSE THEN
                            processRptOchDrop(ochId, thisOchPosInNextXC, dontFindMeId, circuitType, C_findXCFromOCH);
                        END IF;
                        circuit_util.print_line('OSM Module found.');
                        --IF circuitType = 'OCH' THEN
                        circuit_util.print_line('overwrite circuitType from OCH-P to ODU');
                        g_circuit_type := 'ODU2';

                        odu2Id := circuit_util.getMappingOduFromOchP(neIdList(i), NVL(otherOchIdList(i), 0));
                        IF odu2Id = 0 THEN
                            circuit_util.print_line('******* (OCH) One End of Circuit Found, Terminated at OCH-P *******');
                            addFacilityToList(neIdList(i), otherOchIdList(i));
                        ELSE
                            findXCFromODU2(odu2Id, nextOchPosInNextXC, 0, circuitType);
                        END IF;
                    ELSE
                        IF eqptSMTMProtId<>0 THEN -- check for SMTM pair
                            circuit_util.print_line('SMTM/SSM/HDTG pair found in findXCFromOCH');
                            IF processRptDrop=FALSE OR v_valid_second_och_xc THEN
                                processRptOchDrop(ochId, thisOchPosInNextXC, dontFindMeId, circuitType, C_findXCFromOCH);
                            END IF;
                            checkForDuplicateProcessing(to_char(toEqptId), doesExists);
                            IF doesExists=0 THEN
                                otherSideOCHP := findPairingOCH(neIdList(i), toEqptId, otherOchIdList(i));
                                IF otherSideOCHP<>0 THEN
                                    circuit_util.print_line('-- Duplicate SMTM/SSM/HDTG in findXCFromOCHX '||toEqptId||' not found. Hopping to next SMTM/SSM/HDTG och '||otherSideOCHP||'.');
                                    --Prevent the UPSR Ring
                                    findXCFromOCH(otherSideOCHP, 'BOTH', 0, circuitType);
                                ELSE
                                    circuit_util.print_line('******* (OCH) One End of Circuit Found *******');
                                END IF;
                            ELSE
                                circuit_util.print_line('******* (OCH) One End of Circuit Found *******');
                            END IF;
                        ELSIF eqptOPSMProtId<>0 THEN -- check for OPSM protection (DPRING/1+1)
                            IF processRptDrop=FALSE  OR v_valid_second_och_xc THEN
                                processRptOchDrop(ochId, thisOchPosInNextXC, dontFindMeId, circuitType, C_findXCFromOCH);
                            END IF;
                            circuit_util.print_line('OPSM protection found.');
                            findXCFromOCH(NVL(otherRouteOchId,0), nextOchPosInNextXC, 0, circuitType);
                            findDWDMLinkAndOtherSideOCHL(otherRouteOchId, otherOchId);
                            IF nextOchPosInNextXC='TO' THEN
                                v_last_hop_och_id := findXCFromOCHX(NVL(otherOchId,0), 'FROM', 0, circuitType);
                            ELSIF nextOchPosInNextXC='FROM' THEN
                                v_last_hop_och_id := findXCFromOCHX(NVL(otherOchId,0), 'TO', 0, circuitType);
                            ELSE
                               v_last_hop_och_id := findXCFromOCHX(NVL(otherOchId,0), 'BOTH', 0, circuitType);
                            END IF;
                        ELSIF eqptYCABLEProtId<>0 THEN -- check for YCABLE pair
                            circuit_util.print_line('YCABLE pair found.');
                            checkForDuplicateProcessing(to_char(toEqptId), doesExists);
                            IF doesExists=0 THEN
                                otherSideOCHP := findYCABLEPairingOCH(neIdList(i), v_trn_eqpt_id, otherOchIdList(i), circuitType);
                                IF otherSideOCHP<>0 THEN
                                    circuit_util.print_line('-- Duplicate YCABLE '||toEqptId||' not found. Hopping to next YCABLE och '||otherSideOCHP||'.');
                                    IF processRptDrop=FALSE THEN
                                        processRptOchDrop(ochId, thisOchPosInNextXC, dontFindMeId, circuitType, C_findXCFromOCH);
                                    END IF;
                                    findXCFromOCH(otherSideOCHP, 'BOTH', 0, circuitType);
                                    IF nextOchPosInNextXC='TO' THEN
                                        v_last_hop_och_id := findXCFromOCHX(NVL(otherSideOCHP,0), 'FROM', 0, circuitType);
                                    ELSIF nextOchPosInNextXC='FROM' THEN
                                        v_last_hop_och_id := findXCFromOCHX(NVL(otherSideOCHP,0), 'TO', 0, circuitType);
                                    ELSE
                                        v_last_hop_och_id := findXCFromOCHX(NVL(otherSideOCHP,0), 'BOTH', 0, circuitType);
                                    END IF;
                                ELSE
                                    circuit_util.print_line('******* (OCH) One End of Circuit Found *******');
                                END IF;
                            ELSE
                                circuit_util.print_line('******* (OCH) One End of Circuit Found *******');
                            END IF;
                        ELSE
                            IF otherOchTypeList(i) = 'OCH-P' THEN
                               OPEN v_ref_cursor FOR SELECT FAC_ID FROM CM_CARD card, CM_FACILITY fac, CM_CHANNEL_OCH och
                               WHERE och.och_id=otherOchIdList(i) AND CARD_ID=och.Och_Parent_Id AND fac.fac_parent_id=card.card_id AND (
                                    (CARD_AID NOT LIKE 'SMTM%' AND CARD_AID NOT LIKE 'SSM%') OR (fac_aid_port=11 AND CARD_AID LIKE 'SMTM%') OR (fac_aid_port=1 AND CARD_AID LIKE 'SSM%') );
                               FETCH v_ref_cursor INTO portFacId;
                               IF v_ref_cursor%FOUND THEN
                                  addFacilityToList(neIdList(i), portFacId);
                               END IF;
                               CLOSE v_ref_cursor;

                                -- search for OEO
                                FOR l_och1 IN (SELECT ne_tid, ne_type, ne_stype, shelf_subtype, card1.card_aid_type, och1.och_dwdmside, och1.och_aid_shelf, och1.och_aid_slot, och1.och_aid_port
                                    FROM cm_card card1, cm_shelf sh, ems_ne ne, cm_channel_och och1
                                    WHERE instr(ne.ne_stype,'OLA')=0 AND card1.card_id=och1.och_parent_id AND sh.ne_id=och1.ne_id AND sh.shelf_aid_shelf=och1.och_aid_shelf AND ne.ne_id=och1.ne_id AND och1.och_id=otherOchIdList(i)
                                ) LOOP
                                    otherOchId := findNonTrmCrsOeo(
                                        neIdList(i), l_och1.ne_tid, l_och1.ne_type,
                                        l_och1.ne_stype, l_och1.shelf_subtype, ccPathList(i),
                                        xcTypeList(i), l_och1.card_aid_type,  l_och1.och_aid_shelf,
                                        l_och1.och_aid_slot, l_och1.och_aid_port,  otherOchIdList(i),
                                        ochId, l_och1.och_dwdmside, circuitType
                                    );
                                    IF nvl(otherOchId, 0) != 0 THEN
                                        findDWDMLinkAndOtherSideOCHL(otherOchId, otherOchId);
                                        v_last_hop_och_id := findXCFromOCHX(otherOchId, nextOchPosInNextXC, 0, circuitType); -- '0' because it's just starting point in this NE
                                    ELSE
                                        IF processRptDrop=FALSE THEN
                                            processRptOchDrop(ochId, thisOchPosInNextXC, dontFindMeId, circuitType, C_findXCFromOCH);
                                        END IF;
                                    END IF;
                                END LOOP;
                            END IF;
                        END IF;---check for SMTM pair
                    END IF;
                ELSIF otherOchTypeList(i) = 'OCH-L' THEN
                    circuit_util.print_line('cross-connect other endpoint is OCH-L.');
                    findDWDMLinkAndOtherSideOCHL(NVL(otherOchIdList(i),0), otherOchId);
                    v_last_hop_och_id := findXCFromOCHX(NVL(otherOchId,0), nextOchPosInNextXC, 0, circuitType); -- '0' because it's just starting point in this NE
                ELSIF otherOchTypeList(i) = 'OCH-DP' THEN
                    circuit_util.print_line('cross-connect other endpoint is OCH-DP.');
                    findExprsLinkAndOtherSideOCHDP(NVL(otherOchIdList(i),0), otherOchId);
                    v_last_hop_och_id := findXCFromOCHX(NVL(otherOchId,0), nextOchPosInNextXC, 0, circuitType); -- '0' because it's just starting point in this NE
                END IF;
                IF v_valid_second_och_xc THEN
                    IF processRptDrop=FALSE THEN
                        processRptOchDrop(ochId, thisOchPosInNextXC, dontFindMeId, circuitType, C_findXCFromOCH);
                    END IF;
                END IF;
            END LOOP;
        END IF;
        circuit_util.print_end('findXCFromOCHX');
        RETURN v_last_hop_och_id;
    END findXCFromOCHX;

    FUNCTION loadResourceFromCircuitCache(
        p_start_id NUMBER, p_circuit_type VARCHAR2,  p_store_point NUMBER,
        links OUT NOCOPY V_B_TEXT,    connections OUT NOCOPY V_B_TEXT, stsConnections OUT NOCOPY V_B_EXTEXT, expresses OUT NOCOPY V_B_STRING,      facilities OUT NOCOPY V_B_STRING,
        equipments OUT NOCOPY V_B_STRING,     ffps OUT NOCOPY V_B_STRING,           min_x_left OUT NOCOPY NUMBER,
        max_x_right OUT NOCOPY NUMBER,        min_y_top OUT NOCOPY NUMBER,          max_y_bottom OUT NOCOPY NUMBER,
        wavelength OUT NOCOPY VARCHAR2,       signalRate OUT NOCOPY VARCHAR2
    ) RETURN BOOLEAN AS
        v_find_first_cached_circuit BOOLEAN := FALSE;
        v_end_id NUMBER;
        v_last_hop_och_id NUMBER;
    BEGIN circuit_util.print_start('loadResourceFromCircuitCache');
        circuit_util.print_line('Load Resource: p_start_id='||p_start_id);
        FOR v_circuit_resource IN (
            SELECT circuit.*,rownum FROM NM_CIRCUIT_CACHE circuit WHERE report_id=g_rpt_id AND start_id=p_start_id ORDER BY circuit_id ASC
        )LOOP
            circuit_util.print_line('process the item(i)='||v_circuit_resource.rownum);
            v_find_first_cached_circuit := TRUE;
            g_min_x := v_circuit_resource.min_x_left;
            g_max_x := v_circuit_resource.max_x_right;
            g_min_y := v_circuit_resource.min_y_top;
            g_max_y := v_circuit_resource.max_y_bottom;
            IF v_circuit_resource.links IS NOT NULL AND v_circuit_resource.links.count !=0 THEN
                FOR i IN v_circuit_resource.links.first..v_circuit_resource.links.last
                LOOP
                    IF NOT g_link_array.EXISTS(v_circuit_resource.links(i)) THEN
                        addLinkToListX(v_circuit_resource.links(i));
                        g_link_array(v_circuit_resource.links(i)) := 'X';
                    END IF;
                END LOOP;
            END IF;
            IF v_circuit_resource.connections IS NOT NULL AND v_circuit_resource.connections.count !=0 THEN
                FOR i IN v_circuit_resource.connections.first..v_circuit_resource.connections.last
                LOOP
                    IF NOT g_conn_array.EXISTS(v_circuit_resource.connections(i)) THEN
                        addConnToListX(v_circuit_resource.connections(i));
                        g_conn_array(v_circuit_resource.connections(i)) := 'X';
                    END IF;
                END LOOP;
            END IF;
            IF v_circuit_resource.expresses IS NOT NULL AND v_circuit_resource.expresses.count !=0 THEN
                FOR i IN v_circuit_resource.expresses.first..v_circuit_resource.expresses.last
                LOOP
                    IF NOT g_exp_link_array.EXISTS(v_circuit_resource.expresses(i)) THEN
                        addExpLinkToListX(v_circuit_resource.expresses(i));
                        g_exp_link_array(v_circuit_resource.expresses(i)) := 'X';
                    END IF;
                END LOOP;
            END IF;
            IF v_circuit_resource.facilities IS NOT NULL AND v_circuit_resource.facilities.count !=0 THEN
                FOR i IN v_circuit_resource.facilities.first..v_circuit_resource.facilities.last
                LOOP
                    IF NOT g_fac_array.EXISTS(v_circuit_resource.facilities(i)) THEN
                        addFacToListX(v_circuit_resource.facilities(i));
                        g_fac_array(v_circuit_resource.facilities(i)) := 'X';
                    END IF;
                END LOOP;
            END IF;
            IF v_circuit_resource.equipments IS NOT NULL AND v_circuit_resource.equipments.count !=0 THEN
                FOR i IN v_circuit_resource.equipments.first..v_circuit_resource.equipments.last
                LOOP
                    IF NOT g_eqpt_array.EXISTS(v_circuit_resource.equipments(i)) THEN
                        addEqptToListX(v_circuit_resource.equipments(i));
                        g_eqpt_array(v_circuit_resource.equipments(i)) := 'X';
                    END IF;
                END LOOP;
            END IF;
            IF v_circuit_resource.ffps IS NOT NULL AND v_circuit_resource.ffps.count !=0 THEN
                FOR i IN v_circuit_resource.ffps.first..v_circuit_resource.ffps.last
                LOOP
                    IF NOT g_ffp_array.EXISTS(v_circuit_resource.ffps(i)) THEN
                        addFFPToListX(v_circuit_resource.ffps(i));
                        g_ffp_array(v_circuit_resource.ffps(i)) := 'X';
                    END IF;
                END LOOP;
            END IF;
            v_end_id := v_circuit_resource.end_id;
            clearRptCache();
            IF C_findXCFromOCH = v_circuit_resource.store_point  THEN
                v_last_hop_och_id := findXCFromOCHX(v_end_id, v_circuit_resource.direction,v_circuit_resource.dontFindMeId, p_circuit_type, TRUE);
            ELSIF C_findXCFromOCH = v_circuit_resource.store_point  THEN
                discoverLineOCHXWrap(
                    v_end_id,       links,          connections,
                    stsConnections, expresses,      facilities,
                    equipments,     ffps,           min_x_left,
                    max_x_right,    min_y_top,      max_y_bottom,
                    wavelength,     signalRate,     p_circuit_type
                );
            END IF;
        END LOOP;
        circuit_util.print_end('loadResourceFromCircuitCache');
        RETURN  v_find_first_cached_circuit;
    END loadResourceFromCircuitCache;

    PROCEDURE findXCFromOCH (
        ochId IN NUMBER, thisOchPosInNextXC IN VARCHAR2, dontFindMeId IN NUMBER,
        circuitType IN VARCHAR2
    ) AS
          v_last_hop_och_id NUMBER;
          links V_B_TEXT;    connections V_B_TEXT;
          stsConnections V_B_EXTEXT; expresses V_B_STRING;      facilities V_B_STRING;
          equipments V_B_STRING;     ffps V_B_STRING;           min_x_left NUMBER;
          max_x_right NUMBER;        min_y_top NUMBER;          max_y_bottom NUMBER;
          wavelength VARCHAR2(1);       signalRate VARCHAR2(1);
    BEGIN circuit_util.print_start('findXCFromOCH');
        IF g_rpt_id = -1 THEN
            g_cache_och_circuit := FALSE;
            v_last_hop_och_id := findXCFromOCHX(ochId, thisOchPosInNextXC, dontFindMeId, circuitType);
        ELSE
            IF loadResourceFromCircuitCache(ochId, circuitType, C_findXCFromOCH, links,  connections,
        stsConnections, expresses ,      facilities ,
        equipments ,     ffps ,           min_x_left,
        max_x_right,        min_y_top,          max_y_bottom,
        wavelength,       signalRate) THEN
                RETURN;
            END IF;

            IF g_cache_och_circuit THEN
                v_last_hop_och_id := findXCFromOCHX(ochId, thisOchPosInNextXC, dontFindMeId, circuitType);
            ELSE
                circuit_util.print_line('findXCFromOCH: start the och layer cache');
                initRptGlobalVariable(ochId);
                v_last_hop_och_id := findXCFromOCHX(ochId, thisOchPosInNextXC, dontFindMeId, circuitType);
            END IF;
            IF g_rpt_end_id > 0 THEN
                processRptOchDrop(ochId, thisOchPosInNextXC, dontFindMeId, circuitType, C_findXCFromOCH);
            END IF;
        END IF;
       circuit_util.print_end('findXCFromOCH');
    END findXCFromOCH;

    PROCEDURE discoverLineOCHXWrap(
        id IN VARCHAR2,                       links OUT NOCOPY V_B_TEXT,            connections OUT NOCOPY V_B_TEXT,
        stsConnections OUT NOCOPY V_B_EXTEXT, expresses OUT NOCOPY V_B_STRING,      facilities OUT NOCOPY V_B_STRING,
        equipments OUT NOCOPY V_B_STRING,     ffps OUT NOCOPY V_B_STRING,           min_x_left OUT NOCOPY NUMBER,
        max_x_right OUT NOCOPY NUMBER,        min_y_top OUT NOCOPY NUMBER,          max_y_bottom OUT NOCOPY NUMBER,
        wavelength OUT NOCOPY VARCHAR2,       signalRate OUT NOCOPY VARCHAR2,       circuitType IN VARCHAR2
    ) AS
        v_ref_cursor          EMS_REF_CURSOR;
        crsFromOch     NUMBER;
        crsToOch       NUMBER;
        ochFromId      NUMBER;
        ochToId        NUMBER;
        otherOchId     NUMBER;
        neId           NUMBER;
        ochFromEqptId  NUMBER;
        ochToEqptId    NUMBER;
        doesExists     NUMBER;
        eqptOPSMProtId NUMBER;
        eqptSMTMProtId NUMBER;
        eqptYCABLEProtId NUMBER;
        cardId         NUMBER;
        otherRouteOchId   NUMBER;
        fromSide       VARCHAR2(5);
        toSide         VARCHAR2(5);
        cardAid        VARCHAR2(20);
        xcType         VARCHAR2(20);
        ccPath         VARCHAR2(20);
        otherSideOCHP  VARCHAR2(20);
        nextOchPosInNextXC          VARCHAR2(5);
        reversedNextOchPosInNextXC  VARCHAR2(5);
        crsFromFacilityKey      VARCHAR2(100);
        crsToFacilityKey        VARCHAR2(100);
        crsFromCPKey            VARCHAR2(100);
        crsToCPKey              VARCHAR2(100);
        crsId                   VARCHAR2(60);

        ochFromIdList           IntTable;
        ochToIdList             IntTable;
        ochFromEqptIdList       IntTable;
        ochToEqptIdList         IntTable;
        ochFromCpIdList         IntTable;
        ochToCpIdList           IntTable;
        fromSideList            StringTable70;
        toSideList              StringTable70;
        xcTypeList              StringTable70;
        ochFromTypeList         StringTable70;
        ochToTypeList           StringTable70;
        ccPathList              StringTable70;
        crsIdList               StringTable70;
        ochCount                INTEGER;
        i                       INTEGER;
        fromEqptId              INTEGER;
        toEqptId                INTEGER;
        wavelengthX             VARCHAR2(70);
        xcWavelengthX           VARCHAR2(70);
        odu2Id                  NUMBER;
        v_trn_eqpt_id           NUMBER;
        v_last_hop_och_id       NUMBER;
        v_ochp_port             NUMBER;
        duplicateKey            NUMBER;
        v_fiberlink             FIBERLINK_RECORD;
     BEGIN circuit_util.print_start('discoverLineOCHXWrap');
        IF circuit_util.g_log_enable THEN
            FOR l_och IN (SELECT ne.ne_id,ne.ne_tid, card.card_aid,och.och_id,och.och_aid FROM cm_channel_och och, cm_card card, ems_ne ne
                WHERE och_id=id AND ne.ne_id = och.ne_id AND card.ne_id=och.ne_id AND card.card_aid_shelf=och.och_aid_shelf AND card.card_aid_slot=och.och_aid_slot AND card.card_i_parent_type='SHELF'
            )LOOP
                circuit_util.print_line('discover from och: '||l_och.och_id||','||l_och.ne_id||','||l_och.ne_tid||','||l_och.card_aid||','||l_och.och_aid);
            END LOOP;
        END IF;
        g_circuit_type := '';

        links          := V_B_TEXT();
        connections    := V_B_TEXT();
        stsConnections    := V_B_EXTEXT();
        expresses      := V_B_STRING();
        facilities     := V_B_STRING();
        equipments     := V_B_STRING();
        ffps           := V_B_STRING();

        neId:=0;
        g_min_x := 999;
        g_max_x := -999;
        g_min_y := 999;
        g_max_y := -999;

        OPEN v_ref_cursor FOR SELECT ne_id, CRS_FROM_ID, CRS_TO_ID, CRS_CCTYPE, CRS_CCPATH FROM CM_CRS
            WHERE CRS_FROM_ID=id OR CRS_TO_ID=id OR CRS_PROTECTION_ID=id;
        FETCH v_ref_cursor INTO neId, crsFromOch,crsToOch,xcType,ccPath;
        IF v_ref_cursor%NOTFOUND THEN
            CLOSE v_ref_cursor;
            circuit_util.print_line('Selected OCH-L is not involved in any circuit. RETURNING!!');
            -- discover from card since this may be TRM-TRM (ex: HDTG)

            OPEN v_ref_cursor FOR SELECT card.NE_ID, CARD_AID, CARD_ID, nvl(och_aid_port, -1) FROM CM_CARD card, CM_CHANNEL_OCH och WHERE OCH_ID=id AND CARD_ID=OCH_PARENT_ID;
            FETCH v_ref_cursor INTO neId, cardAid, cardId, v_ochp_port;
            CLOSE v_ref_cursor;

            /*This may be pass through TRN/CPM. Find Out*/
            OPEN v_ref_cursor FOR SELECT crs.CRS_FROM_ID,crs.CRS_TO_ID,cardfrom.CARD_ID,cardto.CARD_ID,cardfrom.CARD_DWDMSIDE,cardto.CARD_DWDMSIDE,crs.CRS_CCTYPE,crs.CRS_CCPATH
               FROM CM_CRS crs, CM_CARD cardfrom, CM_CARD cardto
               WHERE (CRS_FROM_CP_ID=cardId OR CRS_TO_CP_ID=cardId)
               AND (nvl(CRS_FROM_port,-1)=v_ochp_port OR nvl(CRS_TO_PORT,-1)=v_ochp_port)
               AND cardfrom.NE_ID = crs.NE_ID AND cardfrom.CARD_AID=crs.CRS_FROM_CP_AID
               AND cardto.NE_ID = crs.NE_ID AND cardto.CARD_AID=crs.CRS_TO_CP_AID;
            FETCH v_ref_cursor INTO ochFromId,ochToId,ochFromEqptId,ochToEqptId,fromSide,toSide,xcType,ccPath;

            IF v_ref_cursor%NOTFOUND THEN
                CLOSE v_ref_cursor;
                circuit_util.print_line('Selected TRN/CPM is not involved in pass-through.');
                otherOchId := 0;
                nextOchPosInNextXC:='BOTH';
                otherOchId := findFiberLinkFromOCH(id, nextOchPosInNextXC, 0, circuitType, v_fiberlink);
                if otherOchId < 0 then
                   circuit_util.print_line('No fiber link found : '||id);
                else
                   v_last_hop_och_id := otherOchId;
                   -- get signalrate to return
                   OPEN v_ref_cursor FOR SELECT FAC_AID_TYPE FROM CM_FACILITY fac
                   WHERE fac.NE_ID=neId AND fac.fac_id=v_fiberlink.fac_id;
                   FETCH v_ref_cursor INTO signalRate;
                   CLOSE v_ref_cursor;
                   -- get wavelength for return
                   OPEN v_ref_cursor FOR SELECT to_char(nvl(OCH_EXTCHAN,''))  FROM CM_CHANNEL_OCH WHERE OCH_ID=id;
                   FETCH v_ref_cursor INTO wavelength;
                   CLOSE v_ref_cursor;

                   IF circuit_util.isOSMModule(id) THEN
                      if g_circuit_type = 'OCH' then
                        circuit_util.print_line('overwrite circuitType from OCH to ODU2');
                        g_circuit_type := 'ODU2';
                      end if;

                      odu2Id := circuit_util.getMappingOduFromOchP(neId, id);
                      IF odu2Id = 0 THEN
                          circuit_util.print_line('******* (OCH) One End of Circuit Found, Terminated at OCH-P *******');
                      ELSE
                          duplicateKey := 0;
                          checkForDuplicateProcessingODU(odu2Id,duplicateKey);
                          IF duplicateKey<>0 THEN
                            circuit_util.print_line('~~~~~~~~~~~~~~~~~~~~ Finding odu :' ||odu2Id||' END');
                          ELSE
                            findXCFromODU2(odu2Id, nextOchPosInNextXC, 0, circuitType);
                          END IF;
                      END IF;
                   end if;
                   
                   -- for OEO with external fiber link
                   FOR l_och1 IN (SELECT ne_tid, ne_type, ne_stype, shelf_subtype, card1.card_aid_type, och1.och_dwdmside, och1.och_aid_shelf, och1.och_aid_slot, och1.och_aid_port
                            FROM cm_card card1, cm_shelf sh, ems_ne ne, cm_channel_och och1
                            WHERE instr(ne.ne_stype,'OLA')=0 AND card1.card_id=och1.och_parent_id AND sh.ne_id=och1.ne_id AND sh.shelf_aid_shelf=och1.och_aid_shelf AND ne.ne_id=och1.ne_id 
                            AND och1.och_id=v_fiberlink.och_id
                        )
                   LOOP
                      otherOchId := findNonTrmCrsOeo(
                          v_fiberlink.ne_id, l_och1.ne_tid, l_och1.ne_type,
                          l_och1.ne_stype, l_och1.shelf_subtype, 'ADD/DROP',
                          '2WAY', l_och1.card_aid_type,  l_och1.och_aid_shelf,
                          l_och1.och_aid_slot, l_och1.och_aid_port,  v_fiberlink.och_id,
                          v_fiberlink.och_id, v_fiberlink.och_aid, circuitType
                      );
                      IF nvl(otherOchId, 0) != 0 THEN
                          findDWDMLinkAndOtherSideOCHL(otherOchId, otherOchId);
                          v_last_hop_och_id := findXCFromOCHX(otherOchId, nextOchPosInNextXC, 0, circuitType); 
                      END IF;
                  END LOOP;
                end if;

            ELSE
                CLOSE v_ref_cursor;
               -- get crossconnect facility data
               crsFromFacilityKey := ochFromId;
               addFacilityToList(neId, ochFromId);
               crsToFacilityKey := ochToId;

               addFacilityToList(neId, ochToId);

               -- get crossconnect fromcp/tocp equipment/fiber data
               crsFromCPKey := ochFromEqptId;
               addEquipmentToList(neId, ochFromEqptId);
               crsToCPKey := ochToEqptId;
               addEquipmentToList(neId, ochToEqptId);

               addConnectionToList(neId, crsFromFacilityKey, crsToFacilityKey);
               circuit_util.print_line('Selected TRN/CPM is used in pass-through.');
               --circuit_util.print_line('CRS_FROM_ID='||ochFromId||',CRS_TO_ID='||ochToId||',CRS_FROM_CP_AID='||',CRS_CCTYPE='||xcType);

               nextOchPosInNextXC:='BOTH';
               IF xcType LIKE '%1WAY%' THEN
                  nextOchPosInNextXC:='TO';
               END IF;
               findDWDMLinkAndOtherSideOCHL(NVL(ochFromId,0), otherOchId);
               v_last_hop_och_id := findXCFromOCHX(NVL(otherOchId,0), nextOchPosInNextXC, 0, circuitType);
               IF xcType LIKE '%1WAY%' THEN
                  nextOchPosInNextXC:='FROM';
               END IF;
               findDWDMLinkAndOtherSideOCHL(NVL(ochToId,0), otherOchId);
               v_last_hop_och_id := findXCFromOCHX(NVL(otherOchId,0), nextOchPosInNextXC, 0, circuitType);
            END IF;
         ELSE
            -- get signalrate to return (in case of HDTG)
            CLOSE v_ref_cursor;

            OPEN v_ref_cursor FOR SELECT FAC_AID_TYPE FROM CM_FACILITY fac, CM_CHANNEL_OCH och
            WHERE fac.NE_ID=neId AND och.NE_ID=neId AND OCH_ID=id AND OCH_TYPE='P' AND FAC_AID_SHELF=OCH_AID_SHELF AND FAC_AID_SLOT=OCH_AID_SLOT
            AND FAC_AID_PORT=circuit_util.getClientFacilityPort(OCH_ID,OCH_AID_PORT);
            FETCH v_ref_cursor INTO signalRate;
            IF v_ref_cursor%NOTFOUND THEN
               CLOSE v_ref_cursor;
               OPEN v_ref_cursor FOR SELECT 'ODU2' FROM CM_CHANNEL_OCH WHERE OCH_ID=id AND OCH_TYPE='P'; -- default for HDTG
               FETCH v_ref_cursor INTO signalRate;
            END IF;
            IF (circuitType ='OCH' OR circuitType IS NULL) AND (signalRate='ODU1-C' OR signalRate LIKE 'GOPT%') THEN --t71mr00159877, signalRate of OTNM should be ODU2
                 CLOSE v_ref_cursor;
                 OPEN v_ref_cursor FOR SELECT 'ODU2' FROM CM_CHANNEL_OCH och, CM_CARD card
                 WHERE och.OCH_ID=id AND och.OCH_TYPE='P' AND och.och_parent_id = card.card_id AND card.card_aid_type LIKE 'OTNM%';
                 FETCH v_ref_cursor INTO signalRate;
            END IF;
            CLOSE v_ref_cursor;
            -- get wavelength for return
            OPEN v_ref_cursor FOR SELECT to_char(nvl(OCH_CHANNUM,'')), to_char(nvl(OCH_XCCHANNUM,'')) FROM CM_CHANNEL_OCH WHERE OCH_ID=id;
            FETCH v_ref_cursor INTO wavelengthX, xcWavelengthX;
            IF wavelengthX is not null THEN
               wavelength:=wavelengthX;
            ELSE
               wavelength:=xcWavelengthX;
            END IF;
            CLOSE v_ref_cursor;

            circuit_util.print_line('It is OCH-L with following OCH details:');
            circuit_util.print_line('CRS_FROM_ID='||crsFromOch||',CRS_TO_ID='||crsToOch||'CRS_CCTYPE='||xcType||',CRS_CCPATH='||ccPath);
            SELECT  ochFromId,ochToId,ochFromEqptId,ochToEqptId,ochFromCpId,
                    ochToCpId,fromSide,toSide,xcType,ccPath, ochFromType,ochToType,crsId
              BULK COLLECT INTO
                  ochFromIdList,ochToIdList,ochFromEqptIdList,ochToEqptIdList,ochFromCpIdList
                  ,ochToCpIdList,fromSideList,toSideList,xcTypeList,ccPathList,ochFromTypeList,ochToTypeList,crsIdList
              FROM(
                SELECT crs.CRS_FROM_ID ochFromId,crs.CRS_TO_ID ochToId,fromOch.OCH_PARENT_ID ochFromEqptId,toOch.OCH_PARENT_ID ochToEqptId,nvl(fromCp.CARD_ID,0) ochFromCpId,
                        nvl(toCp.CARD_ID,0) ochToCpId,fromOch.och_dwdmside fromSide,toOch.och_dwdmside toSide,crs.crs_cctype xcType, crs.crs_ccpath ccPath, crs.crs_from_aid_type ochFromType,crs.crs_to_aid_type ochToType,crs.crs_cktid crsId
                FROM CM_CRS crs, CM_CHANNEL_OCH fromOch, CM_CHANNEL_OCH toOch, CM_CARD fromCp, CM_CARD toCp
                WHERE crs.NE_ID=neId AND fromOch.NE_ID=neId AND toOch.NE_ID=neId AND fromCp.NE_ID(+)=neId AND toCp.NE_ID(+)=neId
                    AND (crs.CRS_FROM_ID=id OR crs.CRS_TO_ID=id) AND fromOch.OCH_ID=crs.CRS_FROM_ID AND toOch.OCH_ID=crs.CRS_TO_ID AND crs.CRS_FROM_CP_AID=fromCp.CARD_AID(+) AND crs.CRS_TO_CP_AID=toCp.CARD_AID(+)
                UNION
                SELECT och.OCH_ID ochFromId,ochProt.OCH_ID ochToId,och.OCH_PARENT_ID ochFromEqptId,ochProt.OCH_PARENT_ID ochToEqptId,0 ochFromCpId,
                        0 ochToCpId,och.och_dwdmside fromSide,ochProt.och_dwdmside toSide,crs.crs_cctype xcType,crs.crs_ccpath ccPath, crs.crs_from_aid_type ochFromType,crs.crs_to_aid_type ochToType,crs.crs_cktid crsId
                FROM CM_CRS crs, CM_CHANNEL_OCH och, CM_CHANNEL_OCH ochProt
                WHERE crs.NE_ID=neId AND ochProt.NE_ID=neId AND och.NE_ID=neId AND ochProt.OCH_ID=id AND och.OCH_ID=crs.CRS_FROM_ID AND crs.CRS_PROTECTION=ochProt.OCH_AID AND (och.OCH_TYPE = 'P' OR och.OCH_TYPE = 'CP' OR och.OCH_TYPE = '1')
                UNION
                SELECT ochProt.OCH_ID ochFromId,och.OCH_ID ochToId,ochProt.OCH_PARENT_ID ochFromEqptId,och.OCH_PARENT_ID ochToEqptId,0 ochFromCpId,
                       0 ochToCpId,ochProt.och_dwdmside fromSide,och.och_dwdmside toSide,crs.crs_cctype xcType,crs.crs_ccpath ccPath, crs.crs_from_aid_type ochFromType,crs.crs_to_aid_type ochToType,crs.crs_cktid crsId
                FROM CM_CRS crs, CM_CHANNEL_OCH och, CM_CHANNEL_OCH ochProt
                WHERE crs.NE_ID=neId AND ochProt.NE_ID=neId AND och.NE_ID=neId AND ochProt.OCH_ID=id AND och.OCH_ID=crs.CRS_TO_ID AND crs.CRS_PROTECTION=ochProt.OCH_AID AND (och.OCH_TYPE = 'P' OR och.OCH_TYPE = 'CP' OR och.OCH_TYPE = '1')
            );

            IF ochFromIdList IS NOT NULL THEN
               ochCount:=ochFromIdList.COUNT;
               circuit_util.print_line('Total OCH connections found: '||ochCount);
            ELSE
               circuit_util.print_line('Selected OCH-L is not involved in pass-through.');
            END IF;

            FOR i IN 1..ochCount LOOP

                IF circuit_util.g_log_enable THEN
                    circuit_util.PRINT_LINE('discoverLineOCHX: Find drop resource(i='||i||'):id='||id||',fromId='||ochFromIdList(i)||',toId='||ochToIdList(i));
                END IF;

                IF i = 1 AND NOT g_rpt_start_cache.exists(id) THEN
                    g_rpt_start_cache(id) := g_rpt_start_id;
                ELSE
                    IF g_rpt_start_cache(id) != -1 AND g_rpt_start_id = -1 THEN
                        initRptGlobalVariable(g_rpt_start_cache(id));
                    END IF;
                END IF;

                IF ochFromCpIdList(i) > 0 AND ochToCpIdList(i) > 0 THEN
                    fromEqptId := ochFromCpIdList(i);
                    toEqptId := ochToCpIdList(i);
                ELSE
                    fromEqptId := ochFromEqptIdList(i);
                    toEqptId := ochToEqptIdList(i);
                END IF;
                SELECT decode(ochFromTypeList(i),'OCH-L',toEqptId,fromEqptId) INTO v_trn_eqpt_id FROM DUAL;

                -- get supporting equipment in case of OPSM DP protection
                eqptOPSMProtId:=getOPSMDPProtectionEquipmentId(neId, ochFromIdList(i), ochToIdList(i), otherRouteOchId);
                addEquipmentToList(neId,eqptOPSMProtId);

               -- get supporting equipment in case of OPSM 1+1 protection
                IF eqptOPSMProtId=0 THEN
                    eqptOPSMProtId:=getOPSM1Plus1ProtectionEqptId(neId, ochFromIdList(i), ochToIdList(i), otherRouteOchId);
                    addEquipmentToList(neId,eqptOPSMProtId);
                END IF;

                -- get supporting equipment in case of SMTM/SSM protection
                IF eqptOPSMProtId=0 THEN
                    IF ochFromTypeList(i) = 'OCH-P' THEN
                        eqptSMTMProtId:=getSMTMProtectionEquipmentId(neId, fromEqptId, toEqptId, ochFromIdList(i));
                    ELSIF ochToTypeList(i) = 'OCH-P' THEN
                        eqptSMTMProtId:=getSMTMProtectionEquipmentId(neId, fromEqptId, toEqptId, ochToIdList(i));
                    END IF;
                    IF eqptSMTMProtId IS NOT NULL THEN
                        addEquipmentToList(neId,eqptSMTMProtId);
                    END IF;
                END IF;
                    -- get supporting equipment in case of SMTM/SSM protection
                IF eqptSMTMProtId=0 THEN
                    IF ochFromTypeList(i) = 'OCH-P' THEN
                        eqptYCABLEProtId:=getYCABLEProtectionEquipmentId(neId, fromEqptId, toEqptId, ochFromIdList(i));
                    ELSIF ochToTypeList(i) = 'OCH-P' THEN
                        eqptYCABLEProtId:=getYCABLEProtectionEquipmentId(neId, fromEqptId, toEqptId, ochToIdList(i));
                    END IF;
                    IF eqptYCABLEProtId IS NOT NULL THEN
                        addEquipmentToList(neId,eqptYCABLEProtId);
                    END IF;
                END IF;

                -- get crossconnect fromcp/tocp equipment/fiber data
                addEquipmentToList(neId,fromEqptId);
                addEquipmentToList(neId,toEqptId);

                -- get crossconnect facility data
                crsFromFacilityKey := ochFromIdList(i);
                addFacilityToList(neId, ochFromIdList(i));
                crsToFacilityKey := ochToIdList(i);
                addFacilityToList(neId, ochToIdList(i));
                addConnectionToList(neId, crsFromFacilityKey, crsToFacilityKey);

                nextOchPosInNextXC:='BOTH';

                IF xcType LIKE '%1WAY%' THEN
                    nextOchPosInNextXC:='TO';
                END IF;
                IF ochFromTypeList(i) = 'OCH-DP' THEN
                    findExprsLinkAndOtherSideOCHDP(NVL(ochFromIdList(i),0), otherOchId);
                    v_last_hop_och_id := findXCFromOCHX(NVL(otherOchId,0), nextOchPosInNextXC, 0, circuitType);
                ELSIF (circuitType<>'STS' OR eqptOPSMProtId<>0) AND (ochFromTypeList(i) = 'OCH-P' OR ochFromTypeList(i) = 'OCH-CP' OR ochFromTypeList(i) = 'OCH-BP' OR ochFromTypeList(i) = 'OCH') THEN
                    IF circuit_util.isPassthrLink(neId, NVL(ochFromTypeList(i),''), eqptOPSMProtId, eqptSMTMProtId) THEN
                        findPassthrLinkAndOtherSideOCH(neId,NVL(ochFromIdList(i),0),NVL(ochFromTypeList(i),''),crsIdList(i),nextOchPosInNextXC,circuitType,otherOchId);
                        v_last_hop_och_id := findXCFromOCHX(NVL(otherOchId,0), nextOchPosInNextXC, 0, circuitType); -- '0' because it's just starting point in this NE
                    ELSIF circuit_util.isOSMModule(NVL(ochFromIdList(i),0)) THEN
                        circuit_util.print_line('overwrite circuitType from OCH to ODU2');
                        g_circuit_type := 'ODU2';
                        odu2Id := circuit_util.getMappingOduFromOchP(neId, NVL(ochFromIdList(i), 0));
                        IF odu2Id = 0 THEN
                            circuit_util.print_line('******* (OCH) One End of Circuit Found, Terminated at OCH-P *******');
                            addFacilityToList(neId, ochFromIdList(i));
                        ELSE
                            findXCFromODU2(odu2Id, nextOchPosInNextXC, 0, circuitType);
                        END IF;

                        IF eqptOPSMProtId<>0 THEN --t71mr00189332
                           SELECT decode(nextOchPosInNextXC,'BOTH','BOTH','FROM','TO','FROM') INTO reversedNextOchPosInNextXC FROM DUAL;
                           circuit_util.print_line('OPSM protection found.');
                           v_last_hop_och_id := findXCFromOCHX(NVL(otherRouteOchId,0), nextOchPosInNextXC, 0, circuitType);
                           findDWDMLinkAndOtherSideOCHL(otherRouteOchId, otherOchId);
                           v_last_hop_och_id := findXCFromOCHX(NVL(otherOchId,0), reversedNextOchPosInNextXC, 0, circuitType);

                           odu2Id := circuit_util.getMappingOduFromOchP(neId, NVL(v_last_hop_och_id, 0));
                           IF odu2Id = 0 THEN
                              circuit_util.print_line('******* (OCH) One End of Circuit Found, Terminated at OCH-P *******');
                              addFacilityToList(neId, v_last_hop_och_id);
                              ELSE
                           findXCFromODU2(odu2Id, nextOchPosInNextXC, 0, circuitType);
                           END IF;
                        END IF;
                    ELSE
                        SELECT decode(nextOchPosInNextXC,'BOTH','BOTH','FROM','TO','FROM') INTO reversedNextOchPosInNextXC FROM DUAL;
                        IF eqptSMTMProtId<>0 THEN -- check for SMTM pair
                            circuit_util.print_line('SMTM/SSM/HDTG pair found.');
                            checkForDuplicateProcessing(to_char(v_trn_eqpt_id), doesExists);
                            IF doesExists=0 THEN
                                otherSideOCHP := findPairingOCH(neId, v_trn_eqpt_id, ochFromIdList(i));
                                IF otherSideOCHP<>0 THEN
                                    circuit_util.print_line('-- Duplicate SMTM/SSM/HDTG in discoverLineOCHXWrap fromOchType '||v_trn_eqpt_id||' not found. Hopping to next SMTM/SSM/HDTG och '||otherSideOCHP||'.');
                                    --processRptOchDrop(otherSideOCHP, 'BOTH', 0, circuitType);
                                    processRptOchDrop(id, 'BOTH', 0, circuitType, C_discoverLineOCH);
                                    findXCFromOCH(otherSideOCHP, 'BOTH', 0, circuitType);
                                ELSE
                                    circuit_util.print_line('******* (OCH) One End of Circuit Found *******');
                                END IF;
                            ELSE
                               circuit_util.print_line('******* (OCH) One End of Circuit Found *******');
                            END IF;
                        ELSIF eqptOPSMProtId<>0 THEN -- check for OPSM protection (DPRING/1+1)
                            circuit_util.print_line('OPSM protection found.');
                            checkForDuplicateProcessing(to_char(eqptOPSMProtId), doesExists);
                            IF doesExists=0 THEN
                                v_last_hop_och_id := findXCFromOCHX(NVL(otherRouteOchId,0), nextOchPosInNextXC, 0, circuitType);
                                findDWDMLinkAndOtherSideOCHL(otherRouteOchId, otherOchId);
                                v_last_hop_och_id := findXCFromOCHX(NVL(otherOchId,0), reversedNextOchPosInNextXC, 0, circuitType);
                            ELSE
                                circuit_util.print_line('******* (OCH) One End of Circuit Found *******');
                            END IF;
                        ELSIF eqptYCABLEProtId<>0 THEN -- check for YCABLE
                            circuit_util.print_line('YCABLE pair found.');
                            checkForDuplicateProcessing(to_char(v_trn_eqpt_id), doesExists);
                            IF doesExists=0 THEN
                                otherSideOCHP := findYCABLEPairingOCH(neId, v_trn_eqpt_id, ochFromIdList(i), circuitType);
                                IF otherSideOCHP<>0 THEN
                                    circuit_util.print_line('-- Duplicate YCABLE '||v_trn_eqpt_id||' not found. Hopping to next YCABLE och '||otherSideOCHP||'.');
                                    v_last_hop_och_id := findXCFromOCHX(NVL(otherSideOCHP,0), reversedNextOchPosInNextXC, 0, circuitType);
                                ELSE
                                    circuit_util.print_line('******* (OCH) One End of Circuit Found *******');
                                END IF;
                            ELSE
                                circuit_util.print_line('******* (OCH) One End of Circuit Found *******');
                            END IF;
                        ELSE
                            IF ochFromTypeList(i) = 'OCH-P' THEN
                            FOR l_och1 IN (SELECT ne_tid, ne_type, ne_stype, shelf_subtype, card1.card_aid_type, och1.och_dwdmside, och1.och_aid_shelf, och1.och_aid_slot, och1.och_aid_port
                              FROM cm_card card1, cm_shelf sh, ems_ne ne, cm_channel_och och1
                              WHERE instr(ne.ne_stype,'OLA')=0 AND card1.card_id=och1.och_parent_id AND sh.ne_id=och1.ne_id AND sh.shelf_aid_shelf=och1.och_aid_shelf AND ne.ne_id=och1.ne_id AND och1.och_id=ochFromIdList(i)
                            ) LOOP
                                otherOchId := findNonTrmCrsOeo(
                                    neId, l_och1.ne_tid, l_och1.ne_type,
                                    l_och1.ne_stype, l_och1.shelf_subtype, ccPathList(i),
                                    xcTypeList(i), l_och1.card_aid_type, l_och1.och_aid_shelf,
                                    l_och1.och_aid_slot, l_och1.och_aid_port,  ochFromIdList(i),
                                    ochToIdList(i), l_och1.och_dwdmside, circuitType);
                                IF nvl(otherOchId, 0) != 0 THEN
                                    findDWDMLinkAndOtherSideOCHL(otherOchId, otherOchId);
                                    v_last_hop_och_id := findXCFromOCHX(otherOchId, nextOchPosInNextXC, 0, circuitType); -- '0' because it's just starting point in this NE
                                END IF;
                            END LOOP;
                        END IF;
                        END IF;
                    END IF;
                ELSE
                    IF ochFromTypeList(i) = 'OCH-L' THEN
                        findDWDMLinkAndOtherSideOCHL(NVL(ochFromIdList(i),0), otherOchId);
                        v_last_hop_och_id := findXCFromOCHX(NVL(otherOchId,0), nextOchPosInNextXC, 0, circuitType);
                    END IF;
                END IF;


                IF xcType LIKE '%1WAY%' THEN
                    nextOchPosInNextXC:='FROM';
                END IF;
                IF ochToTypeList(i) = 'OCH-DP' THEN
                    findExprsLinkAndOtherSideOCHDP(NVL(ochToIdList(i),0), otherOchId);
                    v_last_hop_och_id := findXCFromOCHX(NVL(otherOchId,0), nextOchPosInNextXC, 0, circuitType);
                ELSIF (circuitType<>'STS' OR eqptOPSMProtId<>0) AND (ochToTypeList(i) = 'OCH-P' OR ochToTypeList(i) = 'OCH-CP' OR ochToTypeList(i) = 'OCH-BP' OR ochToTypeList(i) = 'OCH') THEN
                    IF circuit_util.isPassthrLink(neId, NVL(ochToTypeList(i),''), eqptOPSMProtId, eqptSMTMProtId) THEN
                        findPassthrLinkAndOtherSideOCH(neId,NVL(ochToIdList(i),0),NVL(ochToTypeList(i),''),crsIdList(i),nextOchPosInNextXC,circuitType,otherOchId);
                        v_last_hop_och_id := findXCFromOCHX(NVL(otherOchId,0), nextOchPosInNextXC, 0, circuitType); -- '0' because it's just starting point in this NE
                    ELSIF circuit_util.isOSMModule(NVL(ochToIdList(i),0)) THEN
                        circuit_util.print_line('overwrite circuitType from OCH to ODU2');
                        g_circuit_type := 'ODU2';

                        odu2Id := circuit_util.getMappingOduFromOchP(neId, NVL(ochToIdList(i), 0));
                        IF odu2Id = 0 THEN
                            circuit_util.print_line('******* (OCH) One End of Circuit Found, Terminated at OCH-P *******');
                            addFacilityToList(neId, ochToIdList(i));
                        ELSE
                            findXCFromODU2(odu2Id, nextOchPosInNextXC, 0, circuitType);
                        END IF;

                        IF eqptOPSMProtId<>0 THEN --t71mr00189332
                           SELECT decode(nextOchPosInNextXC,'BOTH','BOTH','FROM','TO','FROM') INTO reversedNextOchPosInNextXC FROM DUAL;
                           circuit_util.print_line('OPSM protection found.');
                           v_last_hop_och_id := findXCFromOCHX(NVL(otherRouteOchId,0), nextOchPosInNextXC, 0, circuitType);
                           findDWDMLinkAndOtherSideOCHL(otherRouteOchId, otherOchId);
                           v_last_hop_och_id := findXCFromOCHX(NVL(otherOchId,0), reversedNextOchPosInNextXC, 0, circuitType);

                           odu2Id := circuit_util.getMappingOduFromOchP(neId, NVL(v_last_hop_och_id, 0));
                           IF odu2Id = 0 THEN
                              circuit_util.print_line('******* (OCH) One End of Circuit Found, Terminated at OCH-P *******');
                              addFacilityToList(neId, v_last_hop_och_id);
                              ELSE
                           findXCFromODU2(odu2Id, nextOchPosInNextXC, 0, circuitType);
                           END IF;
                        END IF;
                    ELSE
                        SELECT decode(nextOchPosInNextXC,'BOTH','BOTH','FROM','TO','FROM') INTO reversedNextOchPosInNextXC FROM DUAL;
                        IF eqptSMTMProtId<>0 THEN -- check for SMTM pair
                            circuit_util.print_line('SMTM/SSM/HDTG pair found.');
                            checkForDuplicateProcessing(to_char(v_trn_eqpt_id), doesExists);
                            IF doesExists=0 THEN
                                otherSideOCHP := findPairingOCH(neId, v_trn_eqpt_id, ochToIdList(i));
                                IF otherSideOCHP<>0 THEN
                                    circuit_util.print_line('-- Duplicate SMTM/SSM/HDTG in discoverLineOCHXWrap toOchType '||v_trn_eqpt_id||' not found. Hopping to next SMTM/SSM/HDTG och '||otherSideOCHP||'.');
--                                    processRptOchDrop(otherSideOCHP, 'BOTH', 0, circuitType);
                                    processRptOchDrop(id, 'BOTH', 0, circuitType, C_discoverLineOCH);
                                    findXCFromOCH(otherSideOCHP, 'BOTH', 0, circuitType);
                                ELSE
                                    circuit_util.print_line('******* (OCH) One End of Circuit Found *******');
                                END IF;
                            ELSE
                                circuit_util.print_line('******* (OCH) One End of Circuit Found *******');
                            END IF;
                        ELSIF eqptOPSMProtId<>0 THEN -- check for OPSM protection (DPRING/1+1)
                            circuit_util.print_line('OPSM protection found.');
                          --   Commented out for MR 102319.  Causing problem for ONTM where the other protected route is not being highlighted
                          --   on the client because that DWDM link is not being returned.  SMTMU uses the SMTMU module plus the protected OPSM
                          --   module when routing and each gets dumped into the dup checking once.  But for ONTM since it's the same module so
                          --   the processing is stopped short because of the dup checking.
                            v_last_hop_och_id := findXCFromOCHX(NVL(otherRouteOchId,0), nextOchPosInNextXC, 0, circuitType);
                            findDWDMLinkAndOtherSideOCHL(otherRouteOchId, otherOchId);
                            v_last_hop_och_id := findXCFromOCHX(NVL(otherOchId,0), reversedNextOchPosInNextXC, 0, circuitType);
                        ELSIF eqptYCABLEProtId<>0 THEN -- check for SMTM pair
                            circuit_util.print_line('YCABLE pair found.');
                            checkForDuplicateProcessing(to_char(v_trn_eqpt_id), doesExists);
                            IF doesExists=0 THEN
                                otherSideOCHP := findYCABLEPairingOCH(neId, v_trn_eqpt_id, ochToIdList(i), circuitType);
                                IF otherSideOCHP<>0 THEN
                                    circuit_util.print_line('-- Duplicate YCABLE '||v_trn_eqpt_id||' not found. Hopping to next YCABLE och '||otherSideOCHP||'.');
                                    v_last_hop_och_id := findXCFromOCHX(NVL(otherSideOCHP,0), reversedNextOchPosInNextXC, 0, circuitType);
                                ELSE
                                    circuit_util.print_line('******* (OCH) One End of Circuit Found *******');
                                END IF;
                            ELSE
                                circuit_util.print_line('******* (OCH) One End of Circuit Found *******');
                            END IF;
                        ELSE
                            IF ochToTypeList(i) = 'OCH-P' THEN
                                FOR l_och1 IN (SELECT ne_tid, ne_type, ne_stype, shelf_subtype, card1.card_aid_type, och1.och_dwdmside, och1.och_aid_shelf, och1.och_aid_slot, och1.och_aid_port
                                    FROM cm_card card1, cm_shelf sh, ems_ne ne, cm_channel_och och1
                                        WHERE instr(ne.ne_stype,'OLA')=0 AND card1.card_id=och1.och_parent_id AND sh.ne_id=och1.ne_id AND sh.shelf_aid_shelf=och1.och_aid_shelf AND ne.ne_id=och1.ne_id AND och1.och_id=ochToIdList(i)
                                ) LOOP
                                    otherOchId := findNonTrmCrsOeo(
                                        neId, l_och1.ne_tid, l_och1.ne_type,
                                        l_och1.ne_stype, l_och1.shelf_subtype, ccPathList(i),
                                        xcTypeList(i), l_och1.card_aid_type, l_och1.och_aid_shelf,
                                        l_och1.och_aid_slot, l_och1.och_aid_port,  ochToIdList(i),
                                        ochFromIdList(i), l_och1.och_dwdmside, circuitType);
                                    IF nvl(otherOchId, 0) != 0 THEN
                                        findDWDMLinkAndOtherSideOCHL(otherOchId, otherOchId);
                                        v_last_hop_och_id := findXCFromOCHX(otherOchId, nextOchPosInNextXC, 0, circuitType); -- '0' because it's just starting point in this NE
                                    END IF;
                                END LOOP;
                            END IF;
                        END IF;
                    END if;
                ELSE
                  IF ochToTypeList(i) = 'OCH-L' /*'OCH-P'*/ THEN
                      findDWDMLinkAndOtherSideOCHL(NVL(ochToIdList(i),0), otherOchId);
                      v_last_hop_och_id := findXCFromOCHX(NVL(otherOchId,0), nextOchPosInNextXC, 0, circuitType);
                  END IF;
               END IF;
            END LOOP;
         END IF;
        IF g_rpt_start_id > 0 AND g_rpt_end_id = -1 THEN
            IF id = v_last_hop_och_id THEN
                processRptOchDrop(v_last_hop_och_id, nextOchPosInNextXC, g_rpt_start_id, circuitType, C_discoverLineOCH);
            ELSE
                processRptOchDrop(v_last_hop_och_id, nextOchPosInNextXC, g_rpt_start_id, circuitType, C_findXCFromOCH);
            END iF;
        END IF;
        IF neId>0 THEN
           updateCircuitBounds(neId);
        END IF;
        IF g_circuit_type = 'ODU2' AND circuitType = 'OCH' THEN
            buildCompositeConnections();
        END IF;

        links:=g_link_list;
        connections:=g_conn_List;
        stsConnections:=g_sts_conn_list;
        expresses:=g_exp_link_list;
        facilities:=g_fac_List;
        equipments:=g_eqpt_List;
        ffps:=g_ffp_List;
        min_x_left := g_min_x;
        max_x_right := g_max_x;
        min_y_top := g_min_y;
        max_y_bottom := g_max_y;
        circuit_util.print_end('discoverLineOCHXWrap');
    END discoverLineOCHXWrap;
    PROCEDURE discoverLineOCHX(
        id IN VARCHAR2,                       links OUT NOCOPY V_B_TEXT,            connections OUT NOCOPY V_B_TEXT,
        stsConnections OUT NOCOPY V_B_EXTEXT, expresses OUT NOCOPY V_B_STRING,      facilities OUT NOCOPY V_B_STRING,
        equipments OUT NOCOPY V_B_STRING,     ffps OUT NOCOPY V_B_STRING,           min_x_left OUT NOCOPY NUMBER,
        max_x_right OUT NOCOPY NUMBER,        min_y_top OUT NOCOPY NUMBER,          max_y_bottom OUT NOCOPY NUMBER,
        wavelength OUT NOCOPY VARCHAR2,       signalRate OUT NOCOPY VARCHAR2,       circuitType IN VARCHAR2
    )AS
          v_end_id NUMBER;
    BEGIN circuit_util.print_start('discoverLineOCHX');
        v_end_id := id;
        IF g_rpt_id = -1 THEN
            g_cache_och_circuit := FALSE;
            discoverLineOCHXWrap(
                v_end_id,       links,          connections,
                stsConnections, expresses,      facilities,
                equipments,     ffps,           min_x_left,
                max_x_right,    min_y_top,      max_y_bottom,
                wavelength,     signalRate,     circuitType
            );
        ELSE
            IF loadResourceFromCircuitCache(id, circuitType, C_discoverLineOCH, links,  connections,
                    stsConnections, expresses,      facilities,
                    equipments,     ffps,           min_x_left,
                    max_x_right,    min_y_top,      max_y_bottom,
                    wavelength,     signalRate) THEN
                goto goto_end;
            END IF;

            IF g_cache_och_circuit THEN
                discoverLineOCHXWrap(
                    v_end_id,       links,          connections,
                    stsConnections, expresses,      facilities,
                    equipments,     ffps,           min_x_left,
                    max_x_right,    min_y_top,      max_y_bottom,
                    wavelength,     signalRate,     circuitType
                );
            ELSE
                circuit_util.print_line('discoverLineOCHX: start the och layer cache');
                initRptGlobalVariable(id);
                discoverLineOCHXWrap(
                    id,             links,          connections,
                    stsConnections, expresses,      facilities,
                    equipments,     ffps,           min_x_left,
                    max_x_right,    min_y_top,      max_y_bottom,
                    wavelength,     signalRate,     circuitType
                );
            END IF;
        END IF;
        <<goto_end>> circuit_util.print_end('discoverLineOCHX');
    END discoverLineOCHX;
    PROCEDURE discoverLineOCH(
        id IN VARCHAR2,                       links OUT NOCOPY V_B_TEXT,            connections OUT NOCOPY V_B_TEXT,
        expresses OUT NOCOPY V_B_STRING,      facilities OUT NOCOPY V_B_STRING,     equipments OUT NOCOPY V_B_STRING,
        ffps OUT NOCOPY V_B_STRING,           min_x_left OUT NOCOPY NUMBER,         max_x_right OUT NOCOPY NUMBER,
        min_y_top OUT NOCOPY NUMBER,          max_y_bottom OUT NOCOPY NUMBER,       wavelength OUT NOCOPY VARCHAR2,
        signalRate OUT NOCOPY VARCHAR2,       circuitType IN VARCHAR2,              stsConnections OUT NOCOPY V_B_EXTEXT,
        error OUT NOCOPY VARCHAR2,            reportId NUMBER DEFAULT -1
    ) AS
    BEGIN circuit_util.print_start('discoverLineOCH');
        initGlobalVariable();
        links          := V_B_TEXT();
        connections    := V_B_TEXT();
        stsConnections    := V_B_EXTEXT();
        expresses      := V_B_STRING();
        facilities     := V_B_STRING();
        equipments     := V_B_STRING();
        ffps           := V_B_STRING();
        g_rpt_init_id  := id;
        FOR x IN (
            SELECT 1 FROM system_config WHERE config_type ='NM' AND config_name = 'CircuitCache' AND config_value='true'
        )LOOP
            g_rpt_id :=  reportId;
        END LOOP;
        discoverLineOCHX(id,        links,        connections,
                stsConnections,     expresses,    facilities,
                equipments,         ffps,         min_x_left,
                max_x_right,        min_y_top,    max_y_bottom,
                wavelength,         signalRate,   circuitType);
        error:=g_error;
        print_discover_result('DISCOVERY FROM OCH RESULT');
        circuit_util.print_end('discoverLineOCH');
    END discoverLineOCH;

    PROCEDURE discoverEquipmentX(
        id IN VARCHAR2,                        links OUT NOCOPY V_B_TEXT,            connections OUT NOCOPY V_B_TEXT,
        stsConnections OUT NOCOPY V_B_EXTEXT, expresses OUT NOCOPY V_B_STRING,      facilities OUT NOCOPY V_B_STRING,
        equipments OUT NOCOPY V_B_STRING,     ffps OUT NOCOPY V_B_STRING,           min_x_left OUT NOCOPY NUMBER,
        max_x_right OUT NOCOPY NUMBER,        min_y_top OUT NOCOPY NUMBER,          max_y_bottom OUT NOCOPY NUMBER,
        wavelength OUT NOCOPY VARCHAR2,        signalRate OUT NOCOPY VARCHAR2,        circuitType IN VARCHAR2
    ) AS
        ochId          NUMBER;
        ochFromId      NUMBER;
        ochToId        NUMBER;
        otherOchId     NUMBER;
        neId           NUMBER;
        facId          NUMBER;
        ochFromEqptId  NUMBER;
        ochToEqptId    NUMBER;
        fromSide       VARCHAR2(5);
        toSide         VARCHAR2(5);
        cardAid        VARCHAR2(20);
        xcType         VARCHAR2(20);
        ccPath         VARCHAR2(20);
        ochType        VARCHAR2(10);
        addDropHint1   VARCHAR2(32);
        addDropHint2   VARCHAR2(32);
        addDropHint3   VARCHAR2(4);
        nextOchPosInNextXC VARCHAR2(20);
        crsFromFacilityKey      VARCHAR2(100);
        crsToFacilityKey        VARCHAR2(100);
        crsFromCPKey            VARCHAR2(100);
        crsToCPKey              VARCHAR2(100);
        transMap                VARCHAR2(30);
        expRate                 VARCHAR2(30);
        clockType               VARCHAR2(10);
        v_ref_cursor            EMS_REF_CURSOR;
        v_fiberlink             FIBERLINK_RECORD;
    BEGIN circuit_util.print_start('discoverEquipmentX');
        links          := V_B_TEXT();
        connections    := V_B_TEXT();
        stsConnections    := V_B_EXTEXT();
        expresses      := V_B_STRING();
        facilities     := V_B_STRING();
        equipments     := V_B_STRING();
        ffps           := V_B_STRING();
        neId:=0;
        transMap:='';
        expRate:='';

        g_min_x := 999;
        g_max_x := -999;
        g_min_y := 999;
        g_max_y := -999;

        --circuit_util.print_line('OCH Circuit discovery started from TRN/CPM:'||id||' ...');

        OPEN v_ref_cursor FOR SELECT NE_ID, CARD_AID FROM CM_CARD WHERE CARD_ID=id;
        FETCH v_ref_cursor INTO neId, cardAid;
        CLOSE v_ref_cursor;

        IF cardAid LIKE 'HGTMM%' THEN --t71mr00189332
           OPEN v_ref_cursor FOR SELECT CARD_AID, OCH_ID, SUBSTR(OCH_AID,1,INSTR(OCH_AID,'-',2,2)-1), to_char(nvl(OCH_CHANNUM,0)), to_char(nvl(CARD_CHAN,0)), OCH_CROSSCONNECTED
           FROM CM_CARD card, CM_CHANNEL_OCH och WHERE card.NE_ID=neId AND och.NE_ID=neId AND CARD_ID=id AND OCH_PARENT_ID=id AND OCH_AID_PORT IN (1,13);
           FETCH v_ref_cursor INTO cardAid, ochId, ochType, addDropHint1, addDropHint2, addDropHint3;
        ELSE
           OPEN v_ref_cursor FOR SELECT CARD_AID, OCH_ID, SUBSTR(OCH_AID,1,INSTR(OCH_AID,'-',2,2)-1), to_char(nvl(OCH_CHANNUM,0)), to_char(nvl(CARD_CHAN,0)), OCH_CROSSCONNECTED
           FROM CM_CARD card, CM_CHANNEL_OCH och WHERE card.NE_ID=neId AND och.NE_ID=neId AND CARD_ID=id AND OCH_PARENT_ID=id;
           FETCH v_ref_cursor INTO cardAid, ochId, ochType, addDropHint1, addDropHint2, addDropHint3;
        END IF;

        IF v_ref_cursor%NOTFOUND THEN
            CLOSE v_ref_cursor;
            circuit_util.print_line('Selected TRN/CPM is not involved in any circuit. RETURNING!!');
        ELSE
            CLOSE v_ref_cursor;
            --circuit_util.print_line('It is TRN/CPM with following OCH details:');
            -- get wavelength and signalrate for return
            OPEN v_ref_cursor FOR SELECT to_char(CARD_CHAN) FROM CM_CARD WHERE CARD_ID=id;
            FETCH v_ref_cursor INTO wavelength;
            CLOSE v_ref_cursor;

            OPEN v_ref_cursor FOR SELECT FAC_ID, FAC_AID_TYPE, nvl(FAC_TRANSMAP,'x'), nvl(FAC_EXPRATE,'x') FROM CM_CARD card, CM_FACILITY fac
                WHERE CARD_ID=id AND FAC_PARENT_ID=CARD_ID AND (
                  (CARD_AID NOT LIKE 'SMTM%' AND CARD_AID NOT LIKE 'SSM%') OR (fac_aid_port=11 AND CARD_AID LIKE 'SMTM%') OR (fac_aid_port=1 AND CARD_AID LIKE 'SSM%') );
                FETCH v_ref_cursor INTO facId, signalRate, transMap, expRate;
            CLOSE v_ref_cursor;

            if signalRate is not null then
               addFacilityToList(neId, facId);
            end if;

            IF signalRate = 'ODU1-C' THEN
                signalRate := 'ODU2';
            END IF;
            IF transMap<>'x' AND transMap is not null THEN
               signalRate:=signalRate||'-'||transMap;
            END IF;
            IF expRate<>'x' AND expRate is not null THEN
               signalRate:=signalRate||'-'||expRate;
            END IF;

            IF cardAid LIKE 'CPM-%' OR cardAid LIKE 'AIM-%' THEN
               signalRate:='FOREIGN WAVELENGTH';
            ELSIF (cardAid LIKE 'SMTMP%' OR cardAid LIKE 'TGIMP%') THEN -- it does not have line/port facilities
               signalRate:='TGLAN-FRAME_STD';
            ELSIF cardAid LIKE 'FGTMM%' THEN
               OPEN v_ref_cursor FOR SELECT to_char(CARD_CHAN), nvl(OCH_CLOCKTYPE,'x') FROM CM_CARD card, CM_CHANNEL_OCH och WHERE card.NE_ID=neId AND och.NE_ID=neId AND CARD_ID=id AND OCH_PARENT_ID=CARD_ID AND OCH_TYPE = 'P';
               FETCH v_ref_cursor INTO wavelength, clockType;
               CLOSE v_ref_cursor;
               signalRate:='OTU3';
               IF clockType<>'G709' AND clockType<>'x' THEN
                  signalRate:='OTU3-'||clockType;
               END IF;
            ELSIF cardAid LIKE 'HGTMM%' OR cardAid LIKE 'OSM2C%' THEN
               signalRate:='OTU4';
            END IF;

            circuit_util.print_line('CARD_AID='||cardAid||',wavelength='||wavelength||', signalRate='||signalRate||', transMap='||transMap||', expRate='||expRate||', clockType'||clockType);
            IF ((addDropHint1<>'0' OR addDropHint2<>'0') AND addDropHint3<>'NO') THEN
               /*This is an Add/Drop with TRN/CPM*/
                circuit_util.print_line('Selected TRN/CPM is at add/drop point.');
                discoverLineOCHX(ochId, links, connections,
                        stsConnections,   expresses,  facilities,
                        equipments,       ffps,       min_x_left,
                        max_x_right,      min_y_top,  max_y_bottom,
                        wavelength,       signalRate, circuitType);
            ELSE
                --circuit_util.print_line('Selected TRN/CPM is not at add/drop point.');
                --circuit_util.print_line('Checking if it is involved in pass-through ...');
                /*This may be pass through TRN/CPM. Find Out*/
                OPEN v_ref_cursor FOR SELECT crs.NE_ID,crs.CRS_FROM_ID,crs.CRS_TO_ID,cardfrom.CARD_ID,cardto.CARD_ID,cardfrom.CARD_DWDMSIDE,cardto.CARD_DWDMSIDE,crs.CRS_CCTYPE,crs.CRS_CCPATH
                    FROM CM_CRS crs, CM_CARD cardfrom, CM_CARD cardto
                    WHERE crs.NE_ID=neId AND (CRS_FROM_CP_AID=cardAid OR CRS_TO_CP_AID=cardAid)
                        AND cardfrom.NE_ID = crs.NE_ID AND cardfrom.CARD_AID=crs.CRS_FROM_CP_AID  AND cardto.NE_ID = crs.NE_ID AND cardto.CARD_AID=crs.CRS_TO_CP_AID;
                FETCH v_ref_cursor INTO neId,ochFromId,ochToId,ochFromEqptId,ochToEqptId,fromSide,toSide,xcType,ccPath;
                IF v_ref_cursor%NOTFOUND THEN
                    CLOSE v_ref_cursor;
                    circuit_util.print_line('Selected TRN/CPM is not involved in pass-through.');
                    nextOchPosInNextXC:='BOTH';
                    otherOchId := findFiberLinkFromOCH(NVL(ochId,0), nextOchPosInNextXC, 0, circuitType, v_fiberlink);
                    if otherOchId < 0 then
                       circuit_util.print_line('No fiber link found!');
                    end if;
                ELSE
                    CLOSE v_ref_cursor;
                    -- get crossconnect facility data
                    crsFromFacilityKey := ochFromId;
                    addFacilityToList(neId, ochFromId);
                    crsToFacilityKey := ochToId;

                    addFacilityToList(neId, ochToId);

                    -- get crossconnect fromcp/tocp equipment/fiber data
                    crsFromCPKey := ochFromEqptId;
                    addEquipmentToList(neId, ochFromEqptId);
                    crsToCPKey := ochToEqptId;
                    addEquipmentToList(neId, ochToEqptId);

                    addConnectionToList(neId, crsFromFacilityKey, crsToFacilityKey);
                    circuit_util.print_line('Selected TRN/CPM is used in pass-through.');
                    --circuit_util.print_line('CRS_FROM_ID='||ochFromId||',CRS_TO_ID='||ochToId||',CRS_FROM_CP_AID='||',CRS_CCTYPE='||xcType);

                    nextOchPosInNextXC:='BOTH';
                    IF xcType LIKE '%1WAY%' THEN
                        nextOchPosInNextXC:='TO';
                    END IF;
                    findDWDMLinkAndOtherSideOCHL(NVL(ochFromId,0), otherOchId);
                    findXCFromOCH(NVL(otherOchId,0), nextOchPosInNextXC, 0, circuitType);
                    IF xcType LIKE '%1WAY%' THEN
                        nextOchPosInNextXC:='FROM';
                    END IF;
                    findDWDMLinkAndOtherSideOCHL(NVL(ochToId,0), otherOchId);
                    findXCFromOCH(NVL(otherOchId,0), nextOchPosInNextXC, 0, circuitType);
                END IF;
                IF neId>0 THEN
                   updateCircuitBounds(neId);
                END IF;

                IF g_circuit_type = 'ODU2' AND circuitType = 'OCH' THEN
                   buildCompositeConnections();
                END IF;

            END IF;
        END IF;

        links:=g_link_list;
        connections:=g_conn_List;
        stsConnections:=g_sts_conn_list;
        expresses:=g_exp_link_list;
        facilities:=g_fac_List;
        equipments:=g_eqpt_List;
        ffps:=g_ffp_List;
        min_x_left := g_min_x;
        max_x_right := g_max_x;
        min_y_top := g_min_y;
        max_y_bottom := g_max_y;
        circuit_util.print_end('discoverEquipmentX');
    END discoverEquipmentX;

    PROCEDURE discoverEquipment(
        id IN VARCHAR2,                       links OUT NOCOPY V_B_TEXT,            connections OUT NOCOPY V_B_TEXT,
        expresses OUT NOCOPY V_B_STRING,      facilities OUT NOCOPY V_B_STRING,     equipments OUT NOCOPY V_B_STRING,
        ffps OUT NOCOPY V_B_STRING,           min_x_left OUT NOCOPY NUMBER,         max_x_right OUT NOCOPY NUMBER,
        min_y_top OUT NOCOPY NUMBER,          max_y_bottom OUT NOCOPY NUMBER,       wavelength OUT NOCOPY VARCHAR2,
        signalRate OUT NOCOPY VARCHAR2,       circuitType IN VARCHAR2,               supportingEntityAid IN VARCHAR2,
        stsConnections OUT NOCOPY V_B_EXTEXT, error OUT NOCOPY VARCHAR2,         sts1map IN VARCHAR2,
        circuitDir IN VARCHAR2,               childSts IN VARCHAR2,                  inSignalRate IN VARCHAR2,
        reportId NUMBER DEFAULT -1
    ) AS
        v_ref_cursor    EMS_REF_CURSOR;
        neId     NUMBER;
     BEGIN circuit_util.print_start('discoverEquipment');

        IF childSts IS NULL OR childSts='NO' THEN
           g_child_sts:=FALSE;
        ELSE
           g_child_sts:=TRUE;
        END IF;
        FOR x IN (
            SELECT 1 FROM system_config WHERE config_type ='NM' AND config_name = 'CircuitCache' AND config_value='true'
        )LOOP
            g_rpt_id :=  reportId;
        END LOOP;

        /* Initialze vectors. */
        initGlobalVariable();
        g_rpt_init_id := id;
        links          := V_B_TEXT();
        connections    := V_B_TEXT();
        expresses      := V_B_STRING();
        facilities     := V_B_STRING();
        equipments     := V_B_STRING();
        ffps           := V_B_STRING();

        g_sts_conn_list:= V_B_EXTEXT();

        IF circuitType='STS' THEN
            OPEN v_ref_cursor FOR SELECT NE_ID FROM CM_CARD WHERE CARD_ID=id;
            FETCH v_ref_cursor INTO neId;
            CLOSE v_ref_cursor;

            -- get ready to invoke OCH discovery
            g_ne_id:=neId;
            g_card_id:=id;
            g_sts_aid:=supportingEntityAid;

            IF circuitDir IS NULL THEN
                g_next_och_pos_in_next_xc:='BOTH';
            ELSE
                g_next_och_pos_in_next_xc:=circuitDir;
            END IF;

            g_sts_type:=substr(g_sts_aid, 1, instr(g_sts_aid,'-')-1);
            IF g_sts_type LIKE '%CNV%' THEN
                g_sts_type:=substr(g_sts_type, 1, instr(g_sts_type,'CNV')-1);
            ELSIF g_sts_type LIKE '%NV%' THEN
                g_sts_type:=substr(g_sts_type, 1, instr(g_sts_type,'NV')-1);
            ELSIF g_sts_aid LIKE 'ODU1-C%' AND LENGTH(inSignalRate) > 0 THEN
                g_sts_type:=inSignalRate;
            END IF;

            IF sts1map IS NULL THEN
                g_sts1map:='x';
            ELSE
                g_sts1map:=sts1map;
                g_discover_vcg:=TRUE; -- as long as there is a map we can assume it is a composite circuit
            END IF;
            circuit_util.print_line('g_ne_id='||g_ne_id||',g_card_id='||g_card_id||',g_sts_aid='||g_sts_aid||',g_next_och_pos_in_next_xc='||g_next_och_pos_in_next_xc||',g_sts_type='||g_sts_type||', g_sts1map='||g_sts1map||', sts1map='''||sts1map||'''');
        END IF;

        discoverEquipmentX(id,   links, connections,
                stsConnections,  expresses, facilities,
                equipments,      ffps,      min_x_left,
                max_x_right,     min_y_top, max_y_bottom,
                wavelength,      signalRate, circuitType);
        error:=g_error;
        print_discover_result('DISCOVERY FROM Equipment RESULT');
        circuit_util.print_end('discoverEquipment');
    END discoverEquipment;

    PROCEDURE discoverSTSX(
        id IN VARCHAR2,                       links OUT NOCOPY V_B_TEXT,            connections OUT NOCOPY V_B_TEXT,
        expresses OUT NOCOPY V_B_STRING,      facilities OUT NOCOPY V_B_STRING,     equipments OUT NOCOPY V_B_STRING,
        ffps OUT NOCOPY V_B_STRING,           min_x_left OUT NOCOPY NUMBER,         max_x_right OUT NOCOPY NUMBER,
        min_y_top OUT NOCOPY NUMBER,          max_y_bottom OUT NOCOPY NUMBER,       wavelength OUT NOCOPY VARCHAR2,
        signalRate OUT NOCOPY VARCHAR2,       stsFacilities OUT NOCOPY V_B_STRING,  stsConnections OUT NOCOPY V_B_EXTEXT,
        vcgttpMap IN VARCHAR2 DEFAULT NULL
    ) AS
        v_ref_cursor          EMS_REF_CURSOR;
        qIdList        IntTable;
        neIdList       IntTable;
        neId           NUMBER;
        stsId          NUMBER;
        ochFromIdList           IntTable;
        ochToIdList             IntTable;
        ochFromPFIdList         IntTable;
        ochToPFIdList           IntTable;
        ochFromEqptIdList       IntTable;
        ochToEqptIdList         IntTable;
        ochFromSTSAidList       StringTable800;
        ochToSTSAidList         StringTable800;
        xcTypeList              StringTable800;
        xcIndicatorList         StringTable800;
        ochFromSideList         StringTable800;
        ochToSideList           StringTable800;
        crsIdList               StringTable800;
        ochFromParentSchemeList StringTable800;
        ochToParentSchemeList   StringTable800;
        ochFromTimeSlotList     StringTable800;
        ochToTimeSlotList       StringTable800;
        ochCount                INTEGER;
        i                       INTEGER;
        aid                     VARCHAR2(70);
        l_idx1                  PLS_INTEGER;
        facility_token          VARCHAR2(1) := '&';
        facilityString          VARCHAR2(200);
        facId                   NUMBER;
        esimId         NUMBER;
        cardType     VARCHAR2(20);
        ycablefac    NUMBER;
        yacbleaid    VARCHAR2(20);
        ycableeqpt   NUMBER;
        ycableeqpttype   VARCHAR2(20);
        crsExists    BOOLEAN DEFAULT FALSE;
        tempNum              NUMBER;
        tempStr              VARCHAR2(50);
        tempStr1              VARCHAR2(50);
        v_fiberlink             FIBERLINK_RECORD;
    BEGIN
        circuit_util.print_start('discoverSTSX');

        OPEN v_ref_cursor FOR SELECT NE_ID, STS_AID, STS_AID_TYPE FROM CM_STS WHERE STS_ID=id;
        FETCH v_ref_cursor INTO neId, aid, g_sts_type;
        CLOSE v_ref_cursor;
        IF aid IS NOT NULL THEN
            IF g_sts_type LIKE '%CNV%' THEN
               g_sts_type:=substr(g_sts_type, 1, instr(g_sts_type,'CNV')-1);
               g_discover_vcg:=TRUE;
               circuit_util.print_line('1 discoverSTSX::g_sts_type='||g_sts_type);
            ELSIF g_sts_type LIKE 'TTP%' THEN
               g_sts_type:=substr(g_sts_type, 4, length(g_sts_type));
               circuit_util.print_line('2 discoverSTSX::g_sts_type='||g_sts_type);
            ELSIF g_sts_type LIKE '%NV%' THEN
               g_sts_type:=substr(g_sts_type, 1, instr(g_sts_type,'NV')-1);
               circuit_util.print_line('3 discoverSTSX::g_sts_type='||g_sts_type);
            END IF;
        ELSE -- could be FGTMM/OSMxx Subrate facility
            OPEN v_ref_cursor FOR SELECT NE_ID, FAC_AID, FAC_AID_TYPE FROM CM_FACILITY WHERE FAC_ID=id;
            FETCH v_ref_cursor INTO neId, aid, g_sts_type;
            CLOSE v_ref_cursor;
        END IF;

        circuit_util.print_line('It is STS with following details: '||id||', '||aid||' ,'||g_sts_type);
        SELECT  qId, neId, ochFromId,ochToId,ochFromTimeSlot,ochToTimeSlot,
                ochFromEqptId,ochToEqptId,ochFromPFId,ochToPFId,ochFromSTSAid,
                ochToSTSAid,xcType,crsId,ochFromParentScheme,ochToParentScheme,
                xcIndicator,ochFromSide,ochToSide
            BULK COLLECT INTO qIdList, neIdList, ochFromIdList,ochToIdList,ochFromTimeSlotList,ochToTimeSlotList,ochFromEqptIdList,ochToEqptIdList,ochFromPFIdList,ochToPFIdList,ochFromSTSAidList,ochToSTSAidList,xcTypeList,crsIdList,ochFromParentSchemeList,ochToParentSchemeList,xcIndicatorList,ochFromSideList,ochToSideList
          FROM (
            SELECT 1 qId, crs.NE_ID neId, CRS_STS_FROM_ID  ochFromId, CRS_STS_TO_ID ochToId,'' ochFromTimeSlot,'' ochToTimeSlot, nvl(card1.CARD_ID,circuit_util.getVCGCardId(fac1.STS_TTP_VCG_ID)) ochFromEqptId, nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochToEqptId, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID)  ochFromPFId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID) ochToPFId, fac1.STS_AID ochFromSTSAid, fac2.STS_AID ochToSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, pfac1.fac_scheme ochFromParentScheme, pfac2.fac_scheme ochToParentScheme,'STS_XC'  xcIndicator,fac1.sts_port_or_line ochFromSide, fac2.sts_port_or_line  ochToSide
            FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
            WHERE pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND
            fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%' AND
            pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND
            crs.NE_ID=fac1.NE_ID AND fac1.NE_ID=fac2.NE_ID AND CRS_STS_FROM_ID=fac1.STS_ID AND CRS_STS_TO_ID=fac2.STS_ID AND (CRS_STS_FROM_ID=id OR CRS_STS_TO_ID=id OR CRS_STS_SRC_PROT_ID=id OR CRS_STS_DEST_PROT_ID=id)
            ----
            UNION  -- Split the BR to get CRS_STS_SRC_PROT_ID -- CRS_STS_DEST_PROT given CRS_STS_DEST_PROT
            SELECT 2 qId, crs.NE_ID neId, fac1.STS_ID  ochFromId, fac2.STS_ID ochToId,'' ochFromTimeSlot,'' ochToTimeSlot, nvl(card1.CARD_ID,circuit_util.getVCGCardId(fac1.STS_TTP_VCG_ID)) ochFromEqptId, nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochToEqptId, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID)  ochFromPFId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID) ochToPFId, fac1.STS_AID ochFromSTSAid, fac2.STS_AID ochToSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, pfac1.fac_scheme ochFromParentScheme, pfac2.fac_scheme ochToParentScheme,'STS_XC'  xcIndicator,fac1.sts_port_or_line ochFromSide, fac2.sts_port_or_line  ochToSide
            FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
            WHERE pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND
            fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%' AND
            pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND
            crs.NE_ID=fac1.NE_ID AND fac1.NE_ID=fac2.NE_ID AND CRS_STS_SRC_PROT_ID=fac1.STS_ID AND CRS_STS_DEST_PROT_ID=fac2.STS_ID AND fac2.STS_ID=id

            UNION  -- Split the BR to get CRS_STS_SRC_PROT -- CRS_STS_DEST_PROT_ID given CRS_STS_SRC_PROT
            SELECT 3 qId, crs.NE_ID neId, fac2.STS_ID  ochFromId, fac1.STS_ID ochToId,'' ochFromTimeSlot,'' ochToTimeSlot, nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochFromEqptId, nvl(card1.CARD_ID,circuit_util.getVCGCardId(fac1.STS_TTP_VCG_ID)) ochToEqptId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID)  ochFromPFId, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochToPFId, fac2.STS_AID ochFromSTSAid, fac1.STS_AID ochToSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, pfac1.fac_scheme ochFromParentScheme, pfac2.fac_scheme ochToParentScheme,'STS_XC'  xcIndicator,fac2.sts_port_or_line ochFromSide, fac1.sts_port_or_line  ochToSide
            FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
            WHERE pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND
            fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%' AND
            pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND
            crs.NE_ID=fac1.NE_ID AND fac1.NE_ID=fac2.NE_ID AND CRS_STS_DEST_PROT_ID=fac1.STS_ID AND CRS_STS_SRC_PROT_ID=fac2.STS_ID AND fac2.STS_ID=id

            UNION  -- Split the BR to get CRS_STS_SRC_PROT -- CRS_STS_DEST_PROT_ID given CRS_STS_SRC_PROT
            SELECT 4 qId, crs.NE_ID neId, fac2.STS_ID  ochFromId, fac1.STS_ID ochToId,'' ochFromTimeSlot,'' ochToTimeSlot, nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochFromEqptId, nvl(card1.CARD_ID,circuit_util.getVCGCardId(fac1.STS_TTP_VCG_ID)) ochToEqptId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID)  ochFromPFId, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochToPFId, fac2.STS_AID ochFromSTSAid, fac1.STS_AID ochToSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, pfac1.fac_scheme ochFromParentScheme, pfac2.fac_scheme ochToParentScheme,'STS_XC'  xcIndicator,fac2.sts_port_or_line ochFromSide, fac1.sts_port_or_line  ochToSide
            FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
            WHERE pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND
            fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%' AND
            pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND
            crs.NE_ID=fac1.NE_ID AND fac1.NE_ID=fac2.NE_ID AND CRS_STS_DEST_PROT_ID=fac1.STS_ID AND CRS_STS_SRC_PROT_ID=fac2.STS_ID AND crs_sts_from_id=id

            UNION  -- Split the BR to get CRS_STS_SRC_PROT -- CRS_STS_DEST_PROT_ID given CRS_STS_SRC_PROT
            SELECT 5 qId, crs.NE_ID neId, fac2.STS_ID  ochFromId, fac1.STS_ID ochToId,'' ochFromTimeSlot,'' ochToTimeSlot, nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochFromEqptId, nvl(card1.CARD_ID,circuit_util.getVCGCardId(fac1.STS_TTP_VCG_ID)) ochToEqptId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID)  ochFromPFId, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochToPFId, fac2.STS_AID ochFromSTSAid, fac1.STS_AID ochToSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, pfac1.fac_scheme ochFromParentScheme, pfac2.fac_scheme ochToParentScheme,'STS_XC'  xcIndicator,fac2.sts_port_or_line ochFromSide, fac1.sts_port_or_line  ochToSide
            FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
            WHERE pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND
            fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%' AND
            pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND
            crs.NE_ID=fac1.NE_ID AND fac1.NE_ID=fac2.NE_ID AND CRS_STS_DEST_PROT_ID=fac1.STS_ID AND CRS_STS_SRC_PROT_ID=fac2.STS_ID AND crs_sts_to_id=id

            ----------
            UNION  -- Split the BR to get CRS_STS_FROM_ID -- CRS_STS_DEST_PROT given CRS_STS_FROM_ID
            SELECT 6 qId, crs.NE_ID neId, fac1.STS_ID  ochFromId, fac2.STS_ID ochToId,'' ochFromTimeSlot,'' ochToTimeSlot, nvl(card1.CARD_ID,circuit_util.getVCGCardId(fac1.STS_TTP_VCG_ID)) ochFromEqptId, nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochToEqptId, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID)  ochFromPFId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID) ochToPFId, fac1.STS_AID ochFromSTSAid, fac2.STS_AID ochToSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, pfac1.fac_scheme ochFromParentScheme, pfac2.fac_scheme ochToParentScheme,'STS_XC'  xcIndicator,fac1.sts_port_or_line ochFromSide, fac2.sts_port_or_line  ochToSide
            FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
            WHERE pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND
            fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%' AND
            pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND
            crs.NE_ID=fac1.NE_ID AND fac1.NE_ID=fac2.NE_ID AND CRS_STS_FROM_ID=fac1.STS_ID AND fac1.STS_PORT_OR_LINE='Port' AND fac2.STS_PORT_OR_LINE='Line' AND crs_sts_src_prot IS NULL AND CRS_STS_DEST_PROT_ID=fac2.STS_ID AND fac1.STS_ID=id

            UNION  -- Split the BR to get CRS_STS_FROM_ID -- CRS_STS_DEST_PROT given CRS_STS_TO_ID
            SELECT 7 qId, crs.NE_ID neId, fac1.STS_ID  ochFromId, fac2.STS_ID ochToId,'' ochFromTimeSlot,'' ochToTimeSlot, nvl(card1.CARD_ID,circuit_util.getVCGCardId(fac1.STS_TTP_VCG_ID)) ochFromEqptId, nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochToEqptId, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID)  ochFromPFId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID) ochToPFId, fac1.STS_AID ochFromSTSAid, fac2.STS_AID ochToSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, pfac1.fac_scheme ochFromParentScheme, pfac2.fac_scheme ochToParentScheme,'STS_XC'  xcIndicator,fac1.sts_port_or_line ochFromSide, fac2.sts_port_or_line  ochToSide
            FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
            WHERE pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND
            fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%' AND
            pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND
            crs.NE_ID=fac1.NE_ID AND fac1.NE_ID=fac2.NE_ID AND CRS_STS_FROM_ID=fac1.STS_ID AND fac1.STS_PORT_OR_LINE='Port' AND fac2.STS_PORT_OR_LINE='Line' AND crs_sts_src_prot IS NULL AND CRS_STS_DEST_PROT_ID=fac2.STS_ID AND CRS_STS_TO_ID=id

            UNION  -- Split the BR to get CRS_STS_FROM_ID -- CRS_STS_DEST_PROT given CRS_STS_DEST_PROT
            SELECT 8 qId, crs.NE_ID neId, fac1.STS_ID  ochFromId, fac2.STS_ID ochToId,'' ochFromTimeSlot,'' ochToTimeSlot, nvl(card1.CARD_ID,circuit_util.getVCGCardId(fac1.STS_TTP_VCG_ID)) ochFromEqptId, nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochToEqptId, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID)  ochFromPFId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID) ochToPFId, fac1.STS_AID ochFromSTSAid, fac2.STS_AID ochToSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, pfac1.fac_scheme ochFromParentScheme, pfac2.fac_scheme ochToParentScheme,'STS_XC'  xcIndicator,fac1.sts_port_or_line ochFromSide, fac2.sts_port_or_line  ochToSide
            FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
            WHERE pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND
            fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%' AND
            pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND
            crs.NE_ID=fac1.NE_ID AND fac1.NE_ID=fac2.NE_ID AND CRS_STS_FROM_ID=fac1.STS_ID AND fac1.STS_PORT_OR_LINE='Port' AND fac2.STS_PORT_OR_LINE='Line' AND crs_sts_src_prot IS NULL AND CRS_STS_DEST_PROT_ID=fac2.STS_ID AND fac2.STS_ID=id

            UNION  -- Split the PR to get CRS_STS_SRC_PROT -- CRS_STS_TO_ID given CRS_STS_TO_ID
            SELECT 9 qId, crs.NE_ID neId, fac2.STS_ID  ochFromId, fac1.STS_ID ochToId,'' ochFromTimeSlot,'' ochToTimeSlot, nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochFromEqptId, nvl(card1.CARD_ID,circuit_util.getVCGCardId(fac1.STS_TTP_VCG_ID)) ochToEqptId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID)  ochFromPFId, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochToPFId, fac2.STS_AID ochFromSTSAid, fac1.STS_AID ochToSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, pfac1.fac_scheme ochFromParentScheme, pfac2.fac_scheme ochToParentScheme,'STS_XC'  xcIndicator,fac2.sts_port_or_line ochFromSide, fac1.sts_port_or_line  ochToSide
            FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
            WHERE pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND
            fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%' AND
            pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND
            crs.NE_ID=fac1.NE_ID AND fac1.NE_ID=fac2.NE_ID AND CRS_STS_TO_ID=fac1.STS_ID AND fac1.STS_PORT_OR_LINE='Port' AND fac2.STS_PORT_OR_LINE='Line' AND CRS_STS_SRC_PROT_ID=fac2.STS_ID AND crs_sts_dest_prot IS NULL AND fac1.STS_ID=id

            UNION  -- Split the PR to get CRS_STS_SRC_PROT -- CRS_STS_TO_ID given CRS_STS_FROM_ID
            SELECT 10 qId, crs.NE_ID neId, fac2.STS_ID  ochFromId, fac1.STS_ID ochToId,'' ochFromTimeSlot,'' ochToTimeSlot, nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochFromEqptId, nvl(card1.CARD_ID,circuit_util.getVCGCardId(fac1.STS_TTP_VCG_ID)) ochToEqptId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID)  ochFromPFId, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochToPFId, fac2.STS_AID ochFromSTSAid, fac1.STS_AID ochToSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, pfac1.fac_scheme ochFromParentScheme, pfac2.fac_scheme ochToParentScheme,'STS_XC'  xcIndicator,fac2.sts_port_or_line ochFromSide, fac1.sts_port_or_line  ochToSide
            FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
            WHERE pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND
            fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%' AND
            pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND
            crs.NE_ID=fac1.NE_ID AND fac1.NE_ID=fac2.NE_ID AND CRS_STS_TO_ID=fac1.STS_ID AND fac1.STS_PORT_OR_LINE='Port' AND fac2.STS_PORT_OR_LINE='Line' AND CRS_STS_SRC_PROT_ID=fac2.STS_ID  AND crs_sts_dest_prot IS NULL AND CRS_STS_FROM_ID=id

            UNION  -- Split the PR to get CRS_STS_SRC_PROT -- CRS_STS_TO_ID given CRS_STS_SRC_PROT
            SELECT 11 qId, crs.NE_ID neId, fac2.STS_ID  ochFromId, fac1.STS_ID ochToId,'' ochFromTimeSlot,'' ochToTimeSlot, nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochFromEqptId, nvl(card1.CARD_ID,circuit_util.getVCGCardId(fac1.STS_TTP_VCG_ID)) ochToEqptId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID)  ochFromPFId, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochToPFId, fac2.STS_AID ochFromSTSAid, fac1.STS_AID ochToSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, pfac1.fac_scheme ochFromParentScheme, pfac2.fac_scheme ochToParentScheme,'STS_XC'  xcIndicator,fac2.sts_port_or_line ochFromSide, fac1.sts_port_or_line  ochToSide
            FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
            WHERE pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND
            fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%' AND
            pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND
            crs.NE_ID=fac1.NE_ID AND fac1.NE_ID=fac2.NE_ID AND CRS_STS_TO_ID=fac1.STS_ID AND fac1.STS_PORT_OR_LINE='Port' AND fac2.STS_PORT_OR_LINE='Line' AND CRS_STS_SRC_PROT_ID=fac2.STS_ID  AND crs_sts_dest_prot IS NULL AND fac2.STS_ID=id

            UNION  -- Split the PR to get CRS_STS_SRC_PROT -- CRS_STS_TO_ID given CRS_STS_DEST_PROT (case with Port FFP only)
            SELECT 12 qId, crs.NE_ID neId, fac2.STS_ID  ochFromId, fac1.STS_ID ochToId,'' ochFromTimeSlot,'' ochToTimeSlot, nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochFromEqptId, nvl(card1.CARD_ID,circuit_util.getVCGCardId(fac1.STS_TTP_VCG_ID)) ochToEqptId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID)  ochFromPFId, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochToPFId, fac2.STS_AID ochFromSTSAid, fac1.STS_AID ochToSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, pfac1.fac_scheme ochFromParentScheme, pfac2.fac_scheme ochToParentScheme,'STS_XC'  xcIndicator,fac2.sts_port_or_line ochFromSide, fac1.sts_port_or_line  ochToSide
            FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2, CM_STS portSts
            WHERE pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND
            fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%' AND
            pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND
            crs.NE_ID=fac1.NE_ID AND fac1.NE_ID=fac2.NE_ID AND fac2.NE_ID=portSts.NE_ID AND CRS_STS_TO_ID=fac1.STS_ID AND fac1.STS_PORT_OR_LINE='Port' AND CRS_STS_SRC_PROT_ID=fac2.STS_ID  AND crs_sts_dest_prot IS NULL AND portSts.STS_PORT_OR_LINE='Port' AND CRS_STS_DEST_PROT_ID=portSts.STS_ID AND portSts.STS_ID=id

            UNION  -- Split the (ring inter-connect) PR to get CRS_STS_SRC_PROT -- CRS_STS_DEST_PROT given CRS_STS_TO_ID
            SELECT 13 qId, crs.NE_ID neId, fac2.STS_ID  ochFromId, fac1.STS_ID ochToId,'' ochFromTimeSlot,'' ochToTimeSlot, nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochFromEqptId, nvl(card1.CARD_ID,circuit_util.getVCGCardId(fac1.STS_TTP_VCG_ID)) ochToEqptId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID)  ochFromPFId, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochToPFId, fac2.STS_AID ochFromSTSAid, fac1.STS_AID ochToSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, pfac1.fac_scheme ochFromParentScheme, pfac2.fac_scheme ochToParentScheme,'STS_XC'  xcIndicator,fac2.sts_port_or_line ochFromSide, fac1.sts_port_or_line  ochToSide
            FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
            WHERE pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND
            fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%' AND
            pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND
            crs.NE_ID=fac1.NE_ID AND fac1.NE_ID=fac2.NE_ID AND CRS_STS_SRC_PROT_ID=fac2.STS_ID AND CRS_STS_DEST_PROT_ID=fac1.STS_ID AND fac2.STS_PORT_OR_LINE='Line' AND fac1.STS_PORT_OR_LINE='Line' AND CRS_STS_TO_ID=id

            UNION  -- Split the (ring inter-connect) PR to get CRS_STS_SRC_PROT -- CRS_STS_DEST_PROT given CRS_STS_FROM_ID
            SELECT 14 qId, crs.NE_ID neId, fac2.STS_ID  ochFromId, fac1.STS_ID ochToId,'' ochFromTimeSlot,'' ochToTimeSlot, nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochFromEqptId, nvl(card1.CARD_ID,circuit_util.getVCGCardId(fac1.STS_TTP_VCG_ID)) ochToEqptId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID)  ochFromPFId, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochToPFId, fac2.STS_AID ochFromSTSAid, fac1.STS_AID ochToSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, pfac1.fac_scheme ochFromParentScheme, pfac2.fac_scheme ochToParentScheme,'STS_XC'  xcIndicator,fac2.sts_port_or_line ochFromSide, fac1.sts_port_or_line  ochToSide
            FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
            WHERE pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND
            fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%' AND
            pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND
            crs.NE_ID=fac1.NE_ID AND fac1.NE_ID=fac2.NE_ID AND CRS_STS_SRC_PROT_ID=fac2.STS_ID AND CRS_STS_DEST_PROT_ID=fac1.STS_ID AND fac2.STS_PORT_OR_LINE='Line' AND fac1.STS_PORT_OR_LINE='Line' AND CRS_STS_FROM_ID=id

            UNION  -- Split the (ring inter-connect) PR to get CRS_STS_SRC_PROT -- CRS_STS_DEST_PROT given CRS_STS_SRC_PROT
            SELECT 15 qId, crs.NE_ID neId, fac2.STS_ID  ochFromId, fac1.STS_ID ochToId,'' ochFromTimeSlot,'' ochToTimeSlot, nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochFromEqptId, nvl(card1.CARD_ID,circuit_util.getVCGCardId(fac1.STS_TTP_VCG_ID)) ochToEqptId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID)  ochFromPFId, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochToPFId, fac2.STS_AID ochFromSTSAid, fac1.STS_AID ochToSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, pfac1.fac_scheme ochFromParentScheme, pfac2.fac_scheme ochToParentScheme,'STS_XC'  xcIndicator,fac2.sts_port_or_line ochFromSide, fac1.sts_port_or_line  ochToSide
            FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
            WHERE pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND
            fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%' AND
            pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND
            crs.NE_ID=fac1.NE_ID AND fac1.NE_ID=fac2.NE_ID AND CRS_STS_SRC_PROT_ID=fac2.STS_ID AND CRS_STS_DEST_PROT_ID=fac1.STS_ID AND fac2.STS_PORT_OR_LINE='Line' AND fac1.STS_PORT_OR_LINE='Line' AND fac2.STS_ID=id

            UNION  -- Split the (ring inter-connect) PR to get CRS_STS_SRC_PROT -- CRS_STS_DEST_PROT given CRS_STS_DEST_PROT
            SELECT 16 qId, crs.NE_ID neId, fac2.STS_ID  ochFromId, fac1.STS_ID ochToId,'' ochFromTimeSlot,'' ochToTimeSlot, nvl(card2.CARD_ID,circuit_util.getVCGCardId(fac2.STS_TTP_VCG_ID)) ochFromEqptId, nvl(card1.CARD_ID,circuit_util.getVCGCardId(fac1.STS_TTP_VCG_ID)) ochToEqptId, nvl(pfac2.FAC_ID,fac2.STS_TTP_VCG_ID)  ochFromPFId, nvl(pfac1.FAC_ID,fac1.STS_TTP_VCG_ID) ochToPFId, fac2.STS_AID ochFromSTSAid, fac1.STS_AID ochToSTSAid, CRS_STS_CCTYPE xcType, CRS_STS_CKTID crsId, pfac1.fac_scheme ochFromParentScheme, pfac2.fac_scheme ochToParentScheme,'STS_XC'  xcIndicator,fac2.sts_port_or_line ochFromSide, fac1.sts_port_or_line  ochToSide
            FROM CM_CRS_STS crs, CM_CARD card1, CM_CARD card2, CM_STS fac1, CM_STS fac2, CM_FACILITY pfac1, CM_FACILITY pfac2
            WHERE pfac1.FAC_ID(+)=fac1.STS_PARENT_ID AND card1.CARD_ID(+)=pfac1.FAC_PARENT_ID AND
            fac1.STS_AID like '%'||g_sts_type||'%' AND fac2.STS_AID like '%'||g_sts_type||'%' AND
            pfac2.FAC_ID(+)=fac2.STS_PARENT_ID AND card2.CARD_ID(+)=pfac2.FAC_PARENT_ID AND
            crs.NE_ID=fac1.NE_ID AND fac1.NE_ID=fac2.NE_ID AND CRS_STS_SRC_PROT_ID=fac2.STS_ID AND CRS_STS_DEST_PROT_ID=fac1.STS_ID AND fac2.STS_PORT_OR_LINE='Line' AND fac1.STS_PORT_OR_LINE='Line' AND fac1.STS_ID=id

            UNION  -- Fake any cross-connects from OTNM port facilities
            SELECT 17 qId, fac.NE_ID neId, circuit_util.getFacilityID(fac.NE_ID,circuit_util.getOTNMXCedLineFacility(Nvl(fac.FAC_STS1MAP,'0'), fac.NE_ID,card.CARD_AID))  ochFromId, fac.FAC_ID ochToId, fac.FAC_STS1MAP ochFromTimeSlot, fac.FAC_STS1MAP ochToTimeSlot, card.CARD_ID ochFromEqptId, card.CARD_ID ochToEqptId, 0  ochFromPFId, 0 ochToPFId, circuit_util.getOTNMXCedAllLineFacility(fac.FAC_STS1MAP,fac.NE_ID,card.CARD_ID,card.CARD_AID) ochFromSTSAid,  fac.FAC_AID ochToSTSAid, '2WAY' xcType, '' crsId, '' ochFromParentScheme,'' ochToParentScheme,'OTNM_XC'  xcIndicator,'Line' ochFromSide,'Port' ochToSide
            FROM CM_CARD card, CM_FACILITY fac, CM_CHANNEL_OCH och, CM_CRS crs
            WHERE card.NE_ID = fac.NE_ID AND Nvl(fac.FAC_STS1MAP,'None') != 'None' AND fac.FAC_PARENT_ID=card.CARD_ID AND card.CARD_AID LIKE 'OTNM%'
            AND fac.FAC_AID_TYPE != 'ODU1-C' AND fac.FAC_AID_TYPE != 'GOPT-W' AND fac.FAC_AID_TYPE != 'GOPT-P'
            AND fac.FAC_ID = id AND och.NE_ID = fac.NE_ID AND crs.NE_ID = fac.NE_ID AND och.och_parent_id = fac.FAC_PARENT_ID AND (crs.CRS_FROM_ID = och.OCH_ID OR crs.CRS_TO_ID = och.OCH_ID)
            AND (crs.CRS_CCPATH = 'DROP')

            UNION  -- Fake any cross-connects from OTNM port facilities, Just discover from line facility
            SELECT 18 qId, fac.NE_ID neId, fac.FAC_ID  ochFromId, circuit_util.getFacilityID(fac.NE_ID,circuit_util.getOTNMXCedLineFacility(Nvl(fac.FAC_STS1MAP,'0'),fac.NE_ID,card.CARD_AID)) ochToId, fac.FAC_STS1MAP ochFromTimeSlot, fac.FAC_STS1MAP ochToTimeSlot, card.CARD_ID ochFromEqptId, card.CARD_ID ochToEqptId, 0  ochFromPFId, 0 ochToPFId, fac.FAC_AID ochFromSTSAid, circuit_util.getOTNMXCedAllLineFacility(fac.FAC_STS1MAP,fac.NE_ID,card.CARD_ID,card.CARD_AID) ochToSTSAid, '2WAY' xcType, '' crsId, '' ochFromParentScheme,'' ochToParentScheme,'OTNM_XC'  xcIndicator,'Port' ochFromSide,'Line' ochToSide
            FROM CM_CARD card, CM_FACILITY fac, CM_CHANNEL_OCH och, CM_CRS crs
            WHERE card.NE_ID = fac.NE_ID AND Nvl(fac.FAC_STS1MAP,'None') != 'None' AND fac.FAC_PARENT_ID=card.CARD_ID AND card.CARD_AID LIKE 'OTNM%'
            AND fac.FAC_AID_TYPE != 'ODU1-C' AND fac.FAC_AID_TYPE != 'GOPT-W' AND fac.FAC_AID_TYPE != 'GOPT-P'
            AND fac.FAC_ID = id AND och.NE_ID = fac.NE_ID AND crs.NE_ID = fac.NE_ID AND och.och_parent_id = fac.FAC_PARENT_ID AND (crs.CRS_FROM_ID = och.OCH_ID OR crs.CRS_TO_ID = och.OCH_ID)
            AND (crs.CRS_CCPATH = 'ADD' OR crs.CRS_CCPATH = 'ADD/DROP')

            UNION  -- FGTMM Subrate simple ADD cross-connect
            SELECT 19 qId, crs.NE_ID neId, CRS_ODU_FROM_ID  ochFromId, CRS_ODU_TO_ID ochToId,'' ochFromTimeSlot,'' ochToTimeSlot, card1.CARD_ID ochFromEqptId, card2.CARD_ID ochToEqptId, pfac1.FAC_ID  ochFromPFId, pfac2.OCH_ID ochToPFId, fac1.FAC_AID ochFromSTSAid, fac2.FAC_AID ochToSTSAid, CRS_ODU_CCTYPE xcType, CRS_ODU_CKTID crsId, pfac1.fac_scheme ochFromParentScheme, pfac2.OCH_SCHEME ochToParentScheme,'FGTMM_XC'  xcIndicator,'Line' ochFromSide,'Line'  ochToSide
            FROM CM_CRS_ODU crs, CM_CARD card1, CM_CARD card2, CM_FACILITY fac1, CM_FACILITY fac2, CM_FACILITY pfac1, CM_CHANNEL_OCH pfac2
            WHERE pfac1.FAC_ID=fac1.FAC_PARENT_ID AND card1.CARD_ID=pfac1.FAC_PARENT_ID AND
            fac1.FAC_AID like '%'||g_sts_type||'%' AND fac2.FAC_AID like '%'||g_sts_type||'%' AND
            pfac2.OCH_ID=fac2.FAC_PARENT_ID AND card2.CARD_ID=pfac2.OCH_PARENT_ID AND
            crs.NE_ID=fac1.NE_ID AND fac1.NE_ID=fac2.NE_ID AND CRS_ODU_FROM_ID=fac1.FAC_ID AND CRS_ODU_TO_ID=fac2.FAC_ID AND (CRS_ODU_FROM_ID=id OR CRS_ODU_TO_ID=id) AND
            card1.card_aid_type='FGTMM' AND card2.card_aid_type='FGTMM'

            UNION  -- FGTMM Subrate simple DROP cross-connect
            SELECT 20 qId, crs.NE_ID neId, CRS_ODU_FROM_ID  ochFromId, CRS_ODU_TO_ID ochToId,'' ochFromTimeSlot,'' ochToTimeSlot, card1.CARD_ID ochFromEqptId, card2.CARD_ID ochToEqptId, pfac1.OCH_ID  ochFromPFId, pfac2.FAC_ID ochToPFId, fac1.FAC_AID ochFromSTSAid, fac2.FAC_AID ochToSTSAid, CRS_ODU_CCTYPE xcType, CRS_ODU_CKTID crsId, pfac1.OCH_SCHEME ochFromParentScheme, pfac2.fac_scheme ochToParentScheme,'FGTMM_XC'  xcIndicator,'Line' ochFromSide,'Line'  ochToSide
            FROM CM_CRS_ODU crs, CM_CARD card1, CM_CARD card2, CM_FACILITY fac1, CM_FACILITY fac2, CM_CHANNEL_OCH pfac1, CM_FACILITY pfac2
            WHERE pfac1.OCH_ID=fac1.FAC_PARENT_ID AND card1.CARD_ID=pfac1.OCH_PARENT_ID AND
            fac1.FAC_AID like '%'||g_sts_type||'%' AND fac2.FAC_AID like '%'||g_sts_type||'%' AND
            pfac2.FAC_ID=fac2.FAC_PARENT_ID AND card2.CARD_ID=pfac2.FAC_PARENT_ID AND
            crs.NE_ID=fac1.NE_ID AND fac1.NE_ID=fac2.NE_ID AND CRS_ODU_FROM_ID=fac1.FAC_ID AND CRS_ODU_TO_ID=fac2.FAC_ID AND (CRS_ODU_FROM_ID=id OR CRS_ODU_TO_ID=id) AND
            card1.card_aid_type='FGTMM' AND card2.card_aid_type='FGTMM'

            UNION  -- OSM40/OSM20 simple ADD/DROP corss-connect
            SELECT 21 qId, crs.NE_ID neId, fac1.fac_id  ochFromId, fac2.fac_id ochToId,'' ochFromTimeSlot,'' ochToTimeSlot, nvl(card1.CARD_ID, 0) ochFromEqptId, nvl(card2.CARD_ID, 0) ochToEqptId, nvl(mapFac1.FAC_ID, 0)  ochFromPFId, nvl(mapFac2.FAC_ID, 0) ochToPFId, fac1.FAC_AID ochFromSTSAid, fac2.FAC_AID ochToSTSAid, CRS_ODU_CCTYPE xcType, CRS_ODU_CKTID crsId, '' ochFromParentScheme, '' ochToParentScheme,'OSM_XC'  xcIndicator,'Line' ochFromSide,'Line'  ochToSide
            FROM CM_CRS_ODU crs
            inner join CM_FACILITY fac1
            on crs.NE_ID=fac1.NE_ID AND CRS_ODU_FROM_ID=fac1.FAC_ID
            inner join CM_FACILITY fac2
            on crs.NE_ID=fac2.NE_ID AND CRS_ODU_TO_ID=fac2.FAC_ID
            inner join CM_CARD card1
            on card1.ne_id=fac1.ne_id and card1.card_aid_shelf=fac1.fac_aid_shelf and card1.card_aid_slot=fac1.fac_aid_slot and card1.card_aid_type in ('OSM20','OSM2S','OSM1S','OSM2C','OMMX','HGTMM','HGTMMS')
            inner join CM_CARD card2
            on card2.ne_id=fac2.ne_id and card2.card_aid_shelf=fac2.fac_aid_shelf and card2.card_aid_slot=fac2.fac_aid_slot and card2.card_aid_type in ('OSM20','OSM2S','OSM1S','OSM2C','OMMX','HGTMM','HGTMMS')
            left join CM_FACILITY mapFac1
            on fac1.NE_ID=mapFac1.NE_ID and fac1.fac_aid_shelf = mapFac1.fac_aid_shelf and fac1.fac_aid_slot = mapFac1.fac_aid_slot and fac1.fac_aid_port = mapFac1.fac_aid_port AND fac1.fac_aid_type like 'ODU%' AND circuit_util.getodumuxnum( fac1.fac_aid ) = circuit_util.trimaidtype(mapFac1.FAC_AID)
            left join CM_FACILITY mapFac2
            on fac2.NE_ID=mapFac2.NE_ID and fac2.fac_aid_shelf = mapFac2.fac_aid_shelf and fac2.fac_aid_slot = mapFac2.fac_aid_slot and fac2.fac_aid_port = mapFac2.fac_aid_port AND fac2.fac_aid_type like 'ODU%' AND circuit_util.getodumuxnum( fac2.fac_aid ) = circuit_util.trimaidtype(mapFac2.FAC_AID)
            WHERE (CRS_ODU_FROM_ID=id OR CRS_ODU_TO_ID=id OR CRS_ODU_SRC_PROT_ID=id OR CRS_ODU_DEST_PROT_ID=id)

            UNION  -- OSM40/20 ODU1 WAYPR corss-connect: CRS_ODU_DEST_PROT_ID
            SELECT 22 qId, crs.NE_ID neId, fac1.fac_id  ochFromId, fac2.fac_id ochToId,'' ochFromTimeSlot,'' ochToTimeSlot, nvl(card1.CARD_ID, 0) ochFromEqptId, nvl(card2.CARD_ID, 0) ochToEqptId, nvl(mapFac1.FAC_ID, 0)  ochFromPFId, nvl(mapFac2.FAC_ID, 0) ochToPFId, fac1.FAC_AID ochFromSTSAid, fac2.FAC_AID ochToSTSAid, CRS_ODU_CCTYPE xcType, CRS_ODU_CKTID crsId, '' ochFromParentScheme, '' ochToParentScheme,'OSM_XC'  xcIndicator,'Line' ochFromSide,'Line'  ochToSide
            FROM CM_CRS_ODU crs
            inner join CM_FACILITY fac1
            on crs.NE_ID=fac1.NE_ID AND CRS_ODU_FROM_ID=fac1.FAC_ID
            inner join CM_FACILITY fac2
            on crs.NE_ID=fac2.NE_ID AND CRS_ODU_DEST_PROT_ID=fac2.FAC_ID
            inner join CM_CARD card1
            on card1.ne_id=fac1.ne_id and card1.card_aid_shelf=fac1.fac_aid_shelf and card1.card_aid_slot=fac1.fac_aid_slot and card1.card_aid_type in ('OSM20','OSM2S','OSM1S','OSM2C','OMMX','HGTMM','HGTMMS')
            inner join CM_CARD card2
            on card2.ne_id=fac2.ne_id and card2.card_aid_shelf=fac2.fac_aid_shelf and card2.card_aid_slot=fac2.fac_aid_slot and card2.card_aid_type in ('OSM20','OSM2S','OSM1S','OSM2C','OMMX','HGTMM','HGTMMS')
            left join CM_FACILITY mapFac1
            on fac1.NE_ID=mapFac1.NE_ID and fac1.fac_aid_shelf = mapFac1.fac_aid_shelf and fac1.fac_aid_slot = mapFac1.fac_aid_slot and fac1.fac_aid_port = mapFac1.fac_aid_port AND fac1.fac_aid_type like 'ODU%' AND circuit_util.getodumuxnum( fac1.fac_aid ) = circuit_util.trimaidtype(mapFac1.FAC_AID)
            left join CM_FACILITY mapFac2
            on fac2.NE_ID=mapFac2.NE_ID and fac2.fac_aid_shelf = mapFac2.fac_aid_shelf and fac2.fac_aid_slot = mapFac2.fac_aid_slot and fac2.fac_aid_port = mapFac2.fac_aid_port AND fac2.fac_aid_type like 'ODU%' AND circuit_util.getodumuxnum( fac2.fac_aid ) = circuit_util.trimaidtype(mapFac2.FAC_AID)
            WHERE (CRS_ODU_FROM_ID=id OR CRS_ODU_TO_ID=id OR CRS_ODU_SRC_PROT_ID=id OR CRS_ODU_DEST_PROT_ID=id)

            UNION  -- OSM40/20 ODU1 WAYPR corss-connect: CRS_ODU_SRC_PROT_ID
            SELECT 23 qId, crs.NE_ID neId, fac1.fac_id  ochFromId, fac2.fac_id ochToId,'' ochFromTimeSlot,'' ochToTimeSlot, nvl(card1.CARD_ID, 0) ochFromEqptId, nvl(card2.CARD_ID, 0) ochToEqptId, nvl(mapFac1.FAC_ID, 0)  ochFromPFId, nvl(mapFac2.FAC_ID, 0) ochToPFId, fac1.FAC_AID ochFromSTSAid, fac2.FAC_AID ochToSTSAid, CRS_ODU_CCTYPE xcType, CRS_ODU_CKTID crsId, '' ochFromParentScheme, '' ochToParentScheme,'OSM_XC'  xcIndicator,'Line' ochFromSide,'Line'  ochToSide
            FROM CM_CRS_ODU crs
            inner join CM_FACILITY fac1
            on crs.NE_ID=fac1.NE_ID AND CRS_ODU_SRC_PROT_ID=fac1.FAC_ID
            inner join CM_FACILITY fac2
            on crs.NE_ID=fac2.NE_ID AND CRS_ODU_TO_ID=fac2.FAC_ID
            inner join CM_CARD card1
            on card1.ne_id=fac1.ne_id and card1.card_aid_shelf=fac1.fac_aid_shelf and card1.card_aid_slot=fac1.fac_aid_slot and card1.card_aid_type in ('OSM20','OSM2S','OSM1S','OSM2C','OMMX','HGTMM','HGTMMS')
            inner join CM_CARD card2
            on card2.ne_id=fac2.ne_id and card2.card_aid_shelf=fac2.fac_aid_shelf and card2.card_aid_slot=fac2.fac_aid_slot and card2.card_aid_type in ('OSM20','OSM2S','OSM1S','OSM2C','OMMX','HGTMM','HGTMMS')
            left join CM_FACILITY mapFac1
            on fac1.NE_ID=mapFac1.NE_ID and fac1.fac_aid_shelf = mapFac1.fac_aid_shelf and fac1.fac_aid_slot = mapFac1.fac_aid_slot and fac1.fac_aid_port = mapFac1.fac_aid_port AND fac1.fac_aid_type like 'ODU%' AND circuit_util.getodumuxnum( fac1.fac_aid ) = circuit_util.trimaidtype(mapFac1.FAC_AID)
            left join CM_FACILITY mapFac2
            on fac2.NE_ID=mapFac2.NE_ID and fac2.fac_aid_shelf = mapFac2.fac_aid_shelf and fac2.fac_aid_slot = mapFac2.fac_aid_slot and fac2.fac_aid_port = mapFac2.fac_aid_port AND fac2.fac_aid_type like 'ODU%' AND circuit_util.getodumuxnum( fac2.fac_aid ) = circuit_util.trimaidtype(mapFac2.FAC_AID)
            WHERE (CRS_ODU_FROM_ID=id OR CRS_ODU_TO_ID=id OR CRS_ODU_SRC_PROT_ID=id OR CRS_ODU_DEST_PROT_ID=id)

            UNION  -- OSM40/20 ODU1 WAYPR corss-connect: CRS_ODU_SRC_PROT_ID CRS_ODU_DEST_PROT_ID
            SELECT 24 qId, crs.NE_ID neId, fac1.fac_id  ochFromId, fac2.fac_id ochToId,'' ochFromTimeSlot,'' ochToTimeSlot, nvl(card1.CARD_ID, 0) ochFromEqptId, nvl(card2.CARD_ID, 0) ochToEqptId, nvl(mapFac1.FAC_ID, 0)  ochFromPFId, nvl(mapFac2.FAC_ID, 0) ochToPFId, fac1.FAC_AID ochFromSTSAid, fac2.FAC_AID ochToSTSAid, CRS_ODU_CCTYPE xcType, CRS_ODU_CKTID crsId, '' ochFromParentScheme, '' ochToParentScheme,'OSM_XC'  xcIndicator,'Line' ochFromSide,'Line'  ochToSide
            FROM CM_CRS_ODU crs
            inner join CM_FACILITY fac1
            on crs.NE_ID=fac1.NE_ID AND CRS_ODU_SRC_PROT_ID=fac1.FAC_ID
            inner join CM_FACILITY fac2
            on crs.NE_ID=fac2.NE_ID AND CRS_ODU_DEST_PROT_ID=fac2.FAC_ID
            inner join CM_CARD card1
            on card1.ne_id=fac1.ne_id and card1.card_aid_shelf=fac1.fac_aid_shelf and card1.card_aid_slot=fac1.fac_aid_slot and card1.card_aid_type in ('OSM20','OSM2S','OSM1S','OSM2C','OMMX','HGTMM','HGTMMS')
            inner join CM_CARD card2
            on card2.ne_id=fac2.ne_id and card2.card_aid_shelf=fac2.fac_aid_shelf and card2.card_aid_slot=fac2.fac_aid_slot and card2.card_aid_type in ('OSM20','OSM2S','OSM1S','OSM2C','OMMX','HGTMM','HGTMMS')
            left join CM_FACILITY mapFac1
            on fac1.NE_ID=mapFac1.NE_ID and fac1.fac_aid_shelf = mapFac1.fac_aid_shelf and fac1.fac_aid_slot = mapFac1.fac_aid_slot and fac1.fac_aid_port = mapFac1.fac_aid_port AND fac1.fac_aid_type like 'ODU%' AND circuit_util.getodumuxnum( fac1.fac_aid ) = circuit_util.trimaidtype(mapFac1.FAC_AID)
            left join CM_FACILITY mapFac2
            on fac2.NE_ID=mapFac2.NE_ID and fac2.fac_aid_shelf = mapFac2.fac_aid_shelf and fac2.fac_aid_slot = mapFac2.fac_aid_slot and fac2.fac_aid_port = mapFac2.fac_aid_port AND fac2.fac_aid_type like 'ODU%' AND circuit_util.getodumuxnum( fac2.fac_aid ) = circuit_util.trimaidtype(mapFac2.FAC_AID)
            WHERE (CRS_ODU_FROM_ID=id OR CRS_ODU_TO_ID=id OR CRS_ODU_SRC_PROT_ID=id OR CRS_ODU_DEST_PROT_ID=id)

        );

        IF ochFromIdList IS NOT NULL THEN
            ochCount:=ochFromIdList.COUNT;
            circuit_util.print_line('Total STS connections found: '||ochCount);
        ELSE
            circuit_util.print_line('Selected STS is not involved in CRS.');
        END IF;

        -- added for Fiber link case from EMS FP11.0
        if ochCount=0 then
          facId := circuit_util.getMappingFacFromOdu(neId, id);
          if facId <> 0 then
            facId := findFiberLinkFromOCH(facId, 'BOTH', 0, 'OCH', v_fiberlink);
          end if;
          if facId = 0 then
             circuit_util.print_line('No Fiber Link found!');
          end if;
        end if;

        FOR i IN 1..ochCount LOOP
            IF circuit_util.g_log_enable THEN
                circuit_util.print_line('('||qIdList(i)||')'||neIdList(i)||','||ochFromIdList(i)||','||ochToIdList(i)||','||ochFromTimeSlotList(i)||','||ochToTimeSlotList(i)||','||ochFromEqptIdList(i)||','||ochToEqptIdList(i)||','||ochFromPFIdList(i)||','||ochToPFIdList(i)||','||ochFromSTSAidList(i)||','||ochToSTSAidList(i)||','||xcTypeList(i)||','||crsIdList(i)||','||ochFromParentSchemeList(i)||','||ochToParentSchemeList(i)||','||xcIndicatorList(i)||','||ochFromSideList(i)||','||ochToSideList(i));
            END IF;
            -- loop here to include all OTNM line facilities on the source side that are part of the xc
            l_idx1 := INSTR(ochFromSTSAidList(i),facility_token);
            IF l_idx1 > 0 THEN
                facilityString := ochFromSTSAidList(i);
                LOOP
                    l_idx1 := INSTR(facilityString,facility_token);
                    IF l_idx1 > 0 THEN
                        addFacilityToList(neIdList(i), circuit_util.getFacilityID(neIdList(i), substr( facilityString, 0, l_idx1-1)));
                        facilityString := SUBSTR(facilityString,l_idx1+LENGTH(facility_token));
                    ELSE
                        addFacilityToList(neIdList(i), circuit_util.getFacilityID(neIdList(i), facilityString));
                        EXIT;
                    END IF;
                END LOOP;
                addFacilityToList(neIdList(i), circuit_util.getFacilityID(neIdList(i), ochToSTSAidList(i)));
            ELSE
                addFacilityToList(neIdList(i), ochFromIdList(i));
            END IF;

            -- loop here to include all OTNM line facilities on the destination side that are part of the xc
            l_idx1 := INSTR(ochToSTSAidList(i),facility_token);
            IF l_idx1 > 0 THEN
                facilityString := ochToSTSAidList(i);
                LOOP
                    l_idx1 := INSTR(facilityString,facility_token);
                    IF l_idx1 > 0 THEN
                        addFacilityToList(neIdList(i), circuit_util.getFacilityID(neIdList(i), substr( facilityString, 0, l_idx1-1)));
                        facilityString := SUBSTR(facilityString,l_idx1+LENGTH(facility_token));
                    ELSE
                        addFacilityToList(neIdList(i), circuit_util.getFacilityID(neIdList(i), facilityString));
                        EXIT;
                    END IF;
                END LOOP;
                addFacilityToList(neIdList(i), circuit_util.getFacilityID(neIdList(i), ochFromSTSAidList(i)));
            ELSE
                addFacilityToList(neIdList(i), ochToIdList(i));
            END IF;

            IF ochFromPFIdList(i) > 0 THEN
                addFacilityToList(neIdList(i), ochFromPFIdList(i));
            END IF;
            IF ochToPFIdList(i) > 0 THEN
                addFacilityToList(neIdList(i), ochToPFIdList(i));
            END IF;

            IF ochFromIdList(i)=id THEN
              addSTSConnectionToList(neIdList(i), ochFromIdList(i), ochToIdList(i), vcgttpMap, g_sts1map);
              l_idx1 := INSTR(ochToSTSAidList(i),'ODU1');
              IF l_idx1 > 0 THEN
                  g_sts1map:= ochFromTimeSlotList(i);
                  -- Update for OSMXX Begin
                  IF nvl(g_sts1map,'0') = '0' AND (ochFromSTSAidList(i) NOT LIKE 'ODU1-C-%') THEN
                      g_sts1map := ochToTimeSlotList(i);
                  END IF;
                  -- Update for OSMXX End
              END IF;
            ELSIF ochToIdList(i)=id THEN
                addSTSConnectionToList(neIdList(i), ochFromIdList(i), ochToIdList(i), g_sts1map, vcgttpMap);
                l_idx1 := INSTR(ochFromSTSAidList(i),'ODU1');
                IF l_idx1 > 0 THEN
                    g_sts1map:= ochToTimeSlotList(i);
                    IF nvl(g_sts1map,'0') = '0' AND (ochToTimeSlotList(i) NOT LIKE 'ODU1-C-%') THEN
                        g_sts1map := ochFromTimeSlotList(i);
                    END IF;
                END IF;
            ELSE
                addSTSConnectionToList(neIdList(i), ochFromIdList(i), ochToIdList(i), NULL, NULL);
            END IF;

            getSMTMPortFFP(neIdList(i), ochFromPFIdList(i));
            getSMTMPortFFP(neIdList(i), ochToPFIdList(i));

            ycablefac := getSTSYcableFFP(neIdList(i), ochFromIdList(i));
            IF ycablefac = 0 THEN
                ycablefac := getSTSYcableFFP(neIdList(i), ochToIdList(i));
            END IF;

            IF nvl(ochFromTimeSlotList(i),'0')<>'0' AND ochFromTimeSlotList(i) <> nvl(ochToTimeSlotList(i),'0') AND
                ochFromSTSAidList(i) LIKE 'ODU1%' AND ochFromSTSAidList(i) NOT LIKE 'ODU1-C-%' THEN
                g_sts1map := ochFromTimeSlotList(i);
            END IF;

            -- discover from side
            circuit_util.print_line('discover crs from side:'||','||ochFromSTSAidList(i)||','||ochFromEqptIdList(i)||','||neIdList(i));
            IF xcTypeList(i) LIKE '%1WAY%' THEN
                g_next_och_pos_in_next_xc:='TO';
            ELSE
                g_next_och_pos_in_next_xc:='BOTH';
            END IF;

            IF ochFromEqptIdList(i)<>0 THEN
                --IF (ochFromSTSAidList(i) LIKE 'ODU1-C-%') THEN -- Use the non-ODU1-C facility
                addEquipmentToList(neIdList(i),ochFromEqptIdList(i)); --t71mr00182907
                IF ochFromSideList(i) = 'Line' THEN
                    findOCHCircuitAndOtherSideSTS(ochFromSTSAidList(i), ochFromEqptIdList(i), neIdList(i));
                END IF;
            END IF;

            IF nvl(ochToTimeSlotList(i),'0')<>'0' AND ochToTimeSlotList(i) <> nvl(ochFromSTSAidList(i),'0') AND
                ochToSTSAidList(i) LIKE 'ODU1%' AND ochToSTSAidList(i) NOT LIKE 'ODU1-C-%' THEN
                g_sts1map := ochToTimeSlotList(i);
            END IF;

            -- discover to side
            circuit_util.print_line('discover crs to side:'||','||ochToSTSAidList(i)||','||ochToEqptIdList(i)||','||neIdList(i));
            IF xcTypeList(i) LIKE '%1WAY%' THEN
                g_next_och_pos_in_next_xc:='FROM';
            ELSE
                g_next_och_pos_in_next_xc:='BOTH';
            END IF;

            --IF ochToEqptIdList(i)<>0 AND (INSTR(ochToSTSAidList(i),facility_token) = 0) AND ochToSideList(i) = 'Line'  THEN
            IF ochToEqptIdList(i)<>0 THEN
                addEquipmentToList(neIdList(i),ochToEqptIdList(i)); --t71mr00182907
                IF ochToSideList(i) = 'Line'  THEN
                   findOCHCircuitAndOtherSideSTS(ochToSTSAidList(i), ochToEqptIdList(i), neIdList(i));
                END IF;
            END IF;
            circuit_util.print_line('::: Executed findOCHCircuitAndOtherSideSTS()');

            IF xcIndicatorList(i)='STS_XC' THEN
                findPPGFromSts(neIdList(i), ochFromIdList(i));
            END IF;

            -- to add client facility for OSMXX
              /*IF (ochFromSTSAidList(i) LIKE 'ODU1%' AND ochToSTSAidList(i) LIKE 'ODU1%')
              OR (ochFromSTSAidList(i) LIKE 'ODU0%' AND ochToSTSAidList(i) LIKE 'ODU0%')
              OR (ochFromSTSAidList(i) LIKE 'ODUF%' AND ochToSTSAidList(i) LIKE 'ODUF%') THEN*/
              IF (ochFromSTSAidList(i) LIKE 'ODU%' AND ochToSTSAidList(i) LIKE 'ODU%') THEN
                facId := circuit_util.getMappingFacFromOdu(neIdList(i), ochFromIdList(i));
                IF facId <> 0 THEN
                    circuit_util.print_line('OCH Circuit terminated at client facility');
                    addFacilityToList(neIdList(i), facId);
                END IF;
                -- to add far-end facility
                facId := circuit_util.getMappingFacFromOdu(neIdList(i), ochToIdList(i));
                IF facId <> 0 THEN
                    circuit_util.print_line('OCH Circuit terminated at client facility');
                    addFacilityToList(neIdList(i), facId);
                END IF;
            END IF;

            --handle ycable
            IF ycablefac > 0 THEN
                OPEN v_ref_cursor FOR select f.fac_aid, c.card_id, c.card_aid_type from CM_CARD c, CM_FACILITY f
                   where f.fac_id = ycablefac AND c.ne_id = f.ne_id AND c.card_aid_shelf = f.fac_aid_shelf
                   AND c.card_aid_slot = f.fac_aid_slot AND c.card_i_parent_type = 'SHELF';
                FETCH v_ref_cursor INTO yacbleaid,ycableeqpt,ycableeqpttype;
                CLOSE v_ref_cursor;
                IF ycableeqpttype IN ('OSM20','OSM2S','OSM1S','OSM2C','OMMX','HGTMM','HGTMMS') THEN
                    findXCFromODU1(ycablefac, g_next_och_pos_in_next_xc, id, '');
                ELSE --FGTMM/OTNMD
                    g_next_och_pos_in_next_xc:='BOTH';
                    crsExists:=findXCFromSTS(ycablefac, neIdList(i), 0, FALSE, FALSE, '', '', tempNum, tempStr, tempStr1);
                END IF;
            END IF;

            --to add ESIM equipment     COMMIT; facility, IVCG has been added in adding sts cc
            stsId := 0;
            IF ochFromSTSAidList(i) LIKE 'TTP%' THEN
                stsId := ochFromIdList(i);
            ELSIF ochToSTSAidList(i) LIKE 'TTP%' THEN
                stsId := ochToIdList(i);
            END IF;

            IF stsId <> 0 THEN
                OPEN v_ref_cursor FOR select CARD_ID, CARD_AID_TYPE from CM_CARD left join CM_INTERFACE on CARD_ID = INTF_PARENT_ID left join CM_STS on INTF_ID = STS_PARENT_ID where STS_ID = stsId;
                FETCH v_ref_cursor INTO esimId,cardType;
                CLOSE v_ref_cursor;
                IF cardType IS NOT NULL AND cardType = 'ESIM' THEN
                    addEquipmentToList(neIdList(i), esimId);
                    IF g_discover_vcg THEN
                        FOR l_fac IN ( SELECT NE_ID, FAC_ID FROM CM_FACILITY WHERE (FAC_AID_TYPE = 'DS3' OR FAC_AID_TYPE = 'E3') AND FAC_PARENT_ID =stsId
                        )LOOP
                            addFacilityToList(l_fac.ne_id, l_fac.fac_id);
                        END LOOP;
                    END IF;
                END IF;
            END IF;
        END LOOP;
        circuit_util.print_end('discoverSTSX');
    END discoverSTSX;

    PROCEDURE discoverSTS(
        id IN VARCHAR2,                       links OUT NOCOPY V_B_TEXT,            connections OUT NOCOPY V_B_TEXT,
        expresses OUT NOCOPY V_B_STRING,      facilities OUT NOCOPY V_B_STRING,     equipments OUT NOCOPY V_B_STRING,
        ffps OUT NOCOPY V_B_STRING,           min_x_left OUT NOCOPY NUMBER,         max_x_right OUT NOCOPY NUMBER,
        min_y_top OUT NOCOPY NUMBER,          max_y_bottom OUT NOCOPY NUMBER,       wavelength OUT NOCOPY VARCHAR2,
        signalRate OUT NOCOPY VARCHAR2,       stsFacilities OUT NOCOPY V_B_STRING,  stsConnections OUT NOCOPY V_B_EXTEXT,
        compLinks OUT NOCOPY V_B_TEXT,        error OUT NOCOPY VARCHAR2,            childSts IN VARCHAR2,
        reportId NUMBER DEFAULT -1
    ) AS
        facType   VARCHAR2(20);
        facId     VARCHAR2(50);
        parentId  VARCHAR2(50);
        v_ref_cursor     EMS_REF_CURSOR;
        neId      NUMBER;
        DSId      NUMBER;
    BEGIN circuit_util.print_start('discoverSTS');
        g_sts_discovery := 'TRUE';
        FOR x IN (
            SELECT 1 FROM system_config WHERE config_type ='NM' AND config_name = 'CircuitCache' AND config_value='true'
        )LOOP
            g_rpt_id :=  reportId;
        END LOOP;

        IF childSts IS NULL OR childSts='NO' THEN
            g_child_sts:=FALSE;
        ELSE
            g_child_sts:=TRUE;
        END IF;

        -- Initialze vectors.
        initGlobalVariable();
        g_rpt_init_id := id;

        links          := V_B_TEXT();
        compLinks      := V_B_TEXT();
        connections    := V_B_TEXT();
        stsConnections := V_B_EXTEXT();
        expresses      := V_B_STRING();
        facilities     := V_B_STRING();
        stsFacilities  := V_B_STRING();
        equipments     := V_B_STRING();
        ffps           := V_B_STRING();

        g_sts_aid:='';
        g_ne_id:=0;
        g_other_card_id:=0;
        g_other_sts_id:=0;
        g_other_ne_id:=0;
        g_other_sts_aid:='';

        facId := id;
        facType := '0';
        OPEN v_ref_cursor FOR SELECT NE_ID,nvl(FAC_AID_TYPE,'0'),FAC_PARENT_ID FROM CM_FACILITY WHERE FAC_ID = facId;
        FETCH v_ref_cursor  INTO neId,facType,parentId;
        IF v_ref_cursor%FOUND AND (facType = 'DS3' OR facType = 'E3') THEN
            DSId := TO_NUMBER(facId);
            facId := parentId;
            addFacilityToList(neId, DSId);
        END IF;
        CLOSE v_ref_cursor;

        discoverSTSX(facId, links, connections,
            expresses, facilities, equipments,
            ffps,      min_x_left, max_x_right,
            min_y_top, max_y_bottom,  wavelength,
            signalRate,stsFacilities, stsConnections);
        /*IF facType = 'ODU1' OR facType = 'ODU0' OR facType = 'ODUF'
           OR facType = 'ODU2' -- added for FiberLink case to support otu2 from EMS FP11.0, not sure why not have it before
           OR (g_odu_tribslots(3) is not null and g_odu_tribslots(3)<>'0') */
        --THEN
           --TODO need to judge whether it should build com xc
           buildCompositeConnections();
        --END IF;

        links:=g_link_list;
        connections:=g_conn_List;
        stsConnections:=g_sts_conn_list;
        expresses:=g_exp_link_list;
        facilities:=g_fac_List;
        stsFacilities:=g_sts_Fac_List;
        equipments:=g_eqpt_List;
        ffps:=g_ffp_List;

        min_x_left := g_min_x;
        max_x_right := g_max_x;
        min_y_top := g_min_y;
        max_y_bottom := g_max_y;
        error:=g_error;

        print_discover_result('DISCOVERY FROM STS RESULT');
        circuit_util.print_end('discoverSTS');
    END discoverSTS;

    PROCEDURE discoverVCG(
        id IN VARCHAR2,                       links OUT NOCOPY V_B_TEXT,            connections OUT NOCOPY V_B_TEXT,
        expresses OUT NOCOPY V_B_STRING,      facilities OUT NOCOPY V_B_STRING,     equipments OUT NOCOPY V_B_STRING,
        ffps OUT NOCOPY V_B_STRING,           min_x_left OUT NOCOPY NUMBER,         max_x_right OUT NOCOPY NUMBER,
        min_y_top OUT NOCOPY NUMBER,          max_y_bottom OUT NOCOPY NUMBER,       wavelength OUT NOCOPY VARCHAR2,
        signalRate OUT NOCOPY VARCHAR2,       stsFacilities OUT NOCOPY V_B_STRING,  stsConnections OUT NOCOPY V_B_EXTEXT,
        compLinks OUT NOCOPY V_B_TEXT,        error OUT NOCOPY VARCHAR2,            reportId NUMBER DEFAULT -1
    ) AS
        v_ref_cursor                EMS_REF_CURSOR;
        childFacIdList       IntTable;
        ttpFacIdList         IntTable;
        timeSlotList         IntTable;
        vcgttpMapList        StringTable800;
        i                    NUMBER;
        timeSlot             NUMBER;
        vcgttpMap            VARCHAR2(800);
        circuitDir           VARCHAR2(10);
        tempNum              NUMBER;
        tempStr              VARCHAR2(50);
        tempStr1              VARCHAR2(50);
        firstTTP             NUMBER DEFAULT 0;
        neId                 NUMBER;
        vcgId                 NUMBER;
        crsExists            BOOLEAN;

    BEGIN circuit_util.print_start('discoverVCG');
        g_discover_vcg:=TRUE;

        -- Initialze vectors.
        initGlobalVariable();
        g_rpt_init_id := id;

        links          := V_B_TEXT();
        compLinks      := V_B_TEXT();
        connections    := V_B_TEXT();
        stsConnections := V_B_EXTEXT();
        expresses      := V_B_STRING();
        facilities     := V_B_STRING();
        stsFacilities  := V_B_STRING();
        equipments     := V_B_STRING();
        ffps           := V_B_STRING();
        FOR x IN (
            SELECT 1 FROM system_config WHERE config_type ='NM' AND config_name = 'CircuitCache' AND config_value='true'
        )LOOP
            g_rpt_id :=  reportId;
        END LOOP;

        g_sts_aid:='';
        g_ne_id:=0;
        g_other_card_id:=0;
        g_other_sts_id:=0;
        g_other_ne_id:=0;
        g_other_sts_aid:='';

        IF circuitDir IS NULL THEN
            g_next_och_pos_in_next_xc:='BOTH';
        ELSE
            g_next_och_pos_in_next_xc:=circuitDir;
        END IF;

        vcgId := id;
        SELECT childFacId, ttpFacId, timeSlot, vcgttpMap
          BULK COLLECT INTO childFacIdList, ttpFacIdList, timeSlotList,vcgttpMapList
        FROM (
            SELECT s.ID childFacId, t.ID ttpFacId, s.TIMESLOT timeSlot, v.ttpmap vcgttpMap FROM VCG_CM_VW v LEFT JOIN STS_CM_VW t ON v.ID=t.VCG_ID LEFT JOIN CRS_STS_CM_VW c ON t.ID=c.FROM_ID LEFT JOIN STS_CM_VW s ON s.ID=c.TO_ID WHERE c.FROM_AID_TYPE LIKE 'TTP%' AND v.ID=vcgId
            UNION ALL
            SELECT s.ID childFacId, t.ID ttpFacId, s.TIMESLOT timeSlot, v.ttpmap vcgttpMap FROM VCG_CM_VW v LEFT JOIN STS_CM_VW t ON v.ID=t.VCG_ID LEFT JOIN CRS_STS_CM_VW c ON t.ID=c.TO_ID LEFT JOIN STS_CM_VW s ON s.ID=c.FROM_ID WHERE c.TO_AID_TYPE LIKE 'TTP%' AND v.ID=vcgId
            UNION ALL
            ( SELECT s.ID childFacId, t.ID ttpFacId, s.TIMESLOT timeSlot, v.ttpmap vcgttpMap FROM VCG_CM_VW v LEFT JOIN FACILITY_CM_VW f ON v.ID=f.VCG_ID LEFT JOIN STS_CM_VW t ON t.ID=f.parent_id LEFT JOIN CRS_STS_CM_VW c ON t.ID=c.FROM_ID LEFT JOIN STS_CM_VW s ON s.ID=c.TO_ID WHERE c.FROM_AID_TYPE LIKE 'TTP%' AND v.ID=vcgId
              UNION
              SELECT s.ID childFacId, t.ID ttpFacId, s.TIMESLOT timeSlot, v.ttpmap vcgttpMap FROM VCG_CM_VW v LEFT JOIN FACILITY_CM_VW f ON v.ID=f.VCG_ID LEFT JOIN STS_CM_VW t ON t.ID=f.parent_id LEFT JOIN CRS_STS_CM_VW c ON t.ID=c.TO_ID LEFT JOIN STS_CM_VW s ON s.ID=c.FROM_ID WHERE c.TO_AID_TYPE LIKE 'TTP%' AND v.ID=vcgId
            ) ORDER BY timeSlot
        );
        IF childFacIdList IS NOT NULL THEN
            SELECT NE_ID INTO neId FROM CM_VCG WHERE vcg_id=id;
            FOR i IN 1..childFacIdList.COUNT LOOP
                circuit_util.print_line('Line STS id('||i||')='||childFacIdList(i));
                IF i=1 THEN
                    g_sts1map:=timeSlotList(1);
                    OPEN v_ref_cursor FOR SELECT FAC_PARENT_ID, s.NE_ID, s.STS_AID, s.STS_AID_STS, t.STS_ID FROM CM_STS s, CM_STS t, CM_FACILITY, CM_CRS_STS WHERE FAC_ID=s.STS_PARENT_ID AND ((t.STS_ID=CRS_STS_FROM_ID AND CRS_STS_TO_ID=s.STS_ID) OR (t.STS_ID=CRS_STS_TO_ID AND CRS_STS_FROM_ID=s.STS_ID)) AND s.STS_ID=childFacIdList(1);
                    FETCH v_ref_cursor INTO g_card_id, g_ne_id, g_sts_aid, timeSlot, firstTTP;
                    CLOSE v_ref_cursor;
                    g_sts_type:=substr(g_sts_aid, 1, instr(g_sts_aid,'-')-1);
                    IF g_sts_type LIKE '%CNV%' THEN
                        g_sts_type:=substr(g_sts_type, 1, instr(g_sts_type,'CNV')-1);
                    ELSIF g_sts_type LIKE '%NV%' THEN
                        g_sts_type:=substr(g_sts_type, 1, instr(g_sts_type,'NV')-1);
                    END IF;
                    vcgttpMap := vcgttpMapList(i);
                ELSE
                    g_sts1map:=g_sts1map||'&'||timeSlotList(i);
                END IF;
            END LOOP;
            IF circuit_util.g_log_enable THEN
                circuit_util.print_line('Line timeslot map g_sts1map='||g_sts1map);
                circuit_util.print_line('g_ne_id='||g_ne_id||',g_card_id='||g_card_id||',g_sts_aid='||g_sts_aid||',g_next_och_pos_in_next_xc='||g_next_och_pos_in_next_xc||',g_sts_type='||g_sts_type||', g_sts1map='||g_sts1map);
            END IF;
            -- discover from first TTP and line side sts1map
            IF firstTTP<>0 THEN
                discoverSTSX(firstTTP, links, connections,
                    expresses, facilities,   equipments,
                    ffps,      min_x_left,   max_x_right,
                    min_y_top, max_y_bottom, wavelength,
                    signalRate, stsFacilities, stsConnections, vcgttpMap=>vcgttpMap);
                -- add the other start connections
                g_next_och_pos_in_next_xc:='BOTH'; -- we just want to add the CRS, no importance to dir
                FOR i IN 2..childFacIdList.COUNT LOOP
                    crsExists:=findXCFromSTS(ttpFacIdList(i), neId, 0, TRUE/*dont process*/, FALSE/*add*/, '', '',tempNum, tempStr, tempStr1);
                END LOOP;
            END IF;

            stsConnections:=g_sts_conn_list;
            links:=g_link_list;
            connections:=g_conn_List;
            stsConnections:=g_sts_conn_list;
            expresses:=g_exp_link_list;
            facilities:=g_fac_List;
            stsFacilities:=g_sts_Fac_List;
            equipments:=g_eqpt_List;
            ffps:=g_ffp_List;
            error:=g_error;
            min_x_left := g_min_x;
            max_x_right := g_max_x;
            min_y_top := g_min_y;
            max_y_bottom := g_max_y;
        END IF;
        print_discover_result('DISCOVERY FROM VCG RESULT');
        circuit_util.print_end('discoverVCG');
    END discoverVCG;

    PROCEDURE discoverProtectionSwitch(
        id IN VARCHAR2,                       links OUT NOCOPY V_B_TEXT,            connections OUT NOCOPY V_B_TEXT,
        expresses OUT NOCOPY V_B_STRING,      facilities OUT NOCOPY V_B_STRING,     equipments OUT NOCOPY V_B_STRING,
        ffps OUT NOCOPY V_B_STRING,           min_x_left OUT NOCOPY NUMBER,         max_x_right OUT NOCOPY NUMBER,
        min_y_top OUT NOCOPY NUMBER,          max_y_bottom OUT NOCOPY NUMBER,       wavelength OUT NOCOPY VARCHAR2,
        signalRate OUT NOCOPY VARCHAR2
    ) AS
        v_ref_cursor          EMS_REF_CURSOR;
        neId           NUMBER;
        channel        NUMBER;
        equipmentId    NUMBER;
        ochFromId      NUMBER;
        ochToId        NUMBER;
        ochFromIdw     NUMBER;
        ochToIdw       NUMBER;
        ochFromIdp     NUMBER;
        ochToIdp       NUMBER;
        facFromId      NUMBER;
        facToId        NUMBER;
        trnFacIdw      NUMBER;
        trnFacIdp      NUMBER;
        ochpId         NUMBER;
        i              NUMBER;
        side           VARCHAR2(2);
        ochFromAid     VARCHAR2(70);
        ochToAid       VARCHAR2(70);
        wavelengthX    VARCHAR2(70);
        signalRateX    VARCHAR2(70);
        linksX          V_B_TEXT;
        connectionsX    V_B_TEXT;
        expressesX      V_B_STRING;
        facilitiesX     V_B_STRING;
        equipmentsX     V_B_STRING;
        ffpsX           V_B_STRING;
        tempStr         VARCHAR2(1000);
    BEGIN circuit_util.print_start('discoverProtectionSwitch');

        -- initialize o/p vectors
        links          := V_B_TEXT();
        connections    := V_B_TEXT();
        expresses      := V_B_STRING();
        facilities     := V_B_STRING();
        equipments     := V_B_STRING();
        ffps           := V_B_STRING();
        g_rpt_init_id := id;

        -- initialize local temp vectors
        linksX          := V_B_TEXT();
        connectionsX    := V_B_TEXT();
        expressesX      := V_B_STRING();
        facilitiesX     := V_B_STRING();
        equipmentsX     := V_B_STRING();
        ffpsX           := V_B_STRING();

        -- initialize local vectors
        initGlobalVariable();

        --circuit_util.print_line('Circuit discovery started from OPSM Protection Switch:'||id||' ...');

        OPEN v_ref_cursor FOR SELECT intf.NE_ID, CONN_FROMPORT, CONN_DWDMSIDE FROM CM_INTERFACE intf, CM_FIBR_CONN fibr, CM_CARD card
          WHERE fibr.NE_ID=intf.NE_ID AND card.NE_ID = intf.NE_ID AND INTF_ID=id AND CONN_TO_ID=INTF_PARENT_ID AND CONN_TOPORT=(INTF_AID_PORT*3)
            AND card.CARD_ID = intf.INTF_PARENT_ID AND card.CARD_AID_TYPE NOT LIKE 'OTNM%'
        UNION
        SELECT intf.NE_ID, card.CARD_CHAN, CONN_DWDMSIDE FROM CM_INTERFACE intf, CM_FIBR_CONN fibr, CM_CARD card
          WHERE fibr.NE_ID=intf.NE_ID AND card.NE_ID = intf.NE_ID AND INTF_ID=id AND CONN_TO_ID=INTF_PARENT_ID AND CONN_TOPORT=INTF_AID_PORT
            AND card.CARD_ID = intf.INTF_PARENT_ID AND card.CARD_AID_TYPE LIKE 'OTNM%';
        FETCH v_ref_cursor INTO neId, channel, side;
        IF v_ref_cursor%FOUND THEN -- OPSM DPRING found
            CLOSE v_ref_cursor;
            circuit_util.print_line('OPSM DPRING found with data: neId='||neId||',channel='||channel||',side='||side||'.');
            OPEN v_ref_cursor FOR SELECT CRS_FROM_ID, CRS_TO_ID, ochFrom.OCH_AID, ochTo.OCH_AID FROM CM_CRS crs, CM_CHANNEL_OCH och, CM_CHANNEL_OCH ochFrom, CM_CHANNEL_OCH ochTo WHERE crs.NE_ID=neId AND och.NE_ID=neId AND och.OCH_DWDMSIDE=side AND och.OCH_CHANNUM=channel AND och.OCH_TYPE = 'L' AND (och.OCH_ID=CRS_FROM_ID OR och.OCH_ID=CRS_TO_ID OR och.OCH_AID=CRS_PROTECTION) AND ochFrom.OCH_ID=CRS_FROM_ID AND ochTo.OCH_ID=CRS_TO_ID AND
                ((ochFrom.OCH_TYPE = 'P' OR ochFrom.OCH_TYPE = 'CP' OR ochFrom.OCH_TYPE = '1') OR  (ochTo.OCH_TYPE = 'P' OR ochTo.OCH_TYPE = 'CP' OR ochTo.OCH_TYPE = '1'));
            FETCH v_ref_cursor INTO ochFromId, ochToId, ochFromAid, ochToAid;
            IF v_ref_cursor%FOUND THEN
                CLOSE v_ref_cursor;
                IF (ochFromAid LIKE 'OCH-P%' OR ochFromAid LIKE 'OCH-CP%' OR ochFromAid LIKE 'OCH-1%') THEN
                    ochpId:=ochFromId;
                ELSIF (ochToAid LIKE 'OCH-P%' OR ochToAid LIKE 'OCH-CP%' OR ochToAid LIKE 'OCH-1%') THEN
                    ochpId:=ochToId;
                END IF;

                OPEN v_ref_cursor FOR SELECT OCH_PARENT_ID FROM CM_CHANNEL_OCH WHERE NE_ID=neId AND OCH_ID=ochpId;
                FETCH v_ref_cursor INTO equipmentId;
                CLOSE v_ref_cursor;

                discoverEquipment(equipmentId, links, connections,
                        expresses,  facilities,   equipments,
                        ffps,       min_x_left,   max_x_right,
                        min_y_top,  max_y_bottom, wavelength,
                        signalRate, 'OCH',        '',
                        g_sts_conn_list, tempStr, '', '', '', '');
            ELSE
                CLOSE v_ref_cursor;
                circuit_util.print_line('Selected OPSM Protection Switch (DPRING CRS) not involved in any circuit. RETURNING!!');
            END if;

        ELSE
            CLOSE v_ref_cursor;

            OPEN v_ref_cursor FOR SELECT intf.NE_ID, crsw.CRS_FROM_ID, crsw.CRS_TO_ID, crsp.CRS_FROM_ID, crsp.CRS_TO_ID, facFrom.FAC_ID, facTo.FAC_ID FROM CM_INTERFACE intf, CM_CRS crsw, CM_CRS crsp, CM_FACILITY facFrom, CM_FACILITY facTo WHERE INTF_ID=id AND crsw.NE_ID=intf.NE_ID AND crsp.NE_ID=intf.NE_ID AND facFrom.NE_ID=intf.NE_ID AND facTo.NE_ID=intf.NE_ID AND facFrom.FAC_AID=intf.INTF_PROTECTEDAID AND facTo.FAC_AID=intf.INTF_PROTECTINGAID AND (crsw.CRS_FROM_ID=facFrom.FAC_ID OR crsw.CRS_TO_ID=facFrom.FAC_ID) AND (crsp.CRS_FROM_ID=facTo.FAC_ID OR crsp.CRS_TO_ID=facTo.FAC_ID);
            FETCH v_ref_cursor INTO neId, ochFromIdw, ochToIdw, ochFromIdp, ochToIdp, facFromId, facToId;
            IF v_ref_cursor%FOUND THEN -- OPSM 1+1 found
                CLOSE v_ref_cursor;
                circuit_util.print_line('OPSM 1+1 found with data: facFromId='||facFromId||',facToId='||facToId||'.');
                IF facFromId=ochFromIdw THEN
                    trnFacIdw:=ochToIdw;
                ELSIF facFromId=ochToIdw THEN
                    trnFacIdw:=ochFromIdw;
                END IF;
                IF facToId=ochFromIdp THEN
                    trnFacIdp:=ochToIdp;
                ELSIF facToId=ochToIdp THEN
                    trnFacIdp:=ochFromIdp;
                END IF;

                OPEN v_ref_cursor FOR SELECT FAC_PARENT_ID FROM CM_FACILITY WHERE FAC_ID=trnFacIdw;
                FETCH v_ref_cursor INTO equipmentId;
                CLOSE v_ref_cursor;
                discoverEquipment(equipmentId, links, connections,
                        expresses,  facilities,      equipments,
                        ffps,       min_x_left,      max_x_right,
                        min_y_top,  max_y_bottom,    wavelength,
                        signalRate, 'OCH', '',
                        g_sts_conn_list, tempStr, '', '', '', '');

                circuit_util.print_line('wavelength:'||wavelength||',signalRate:'||signalRate||'.');
                OPEN v_ref_cursor FOR SELECT FAC_PARENT_ID FROM CM_FACILITY WHERE FAC_ID=trnFacIdp;
                FETCH v_ref_cursor INTO equipmentId;
                CLOSE v_ref_cursor;
                discoverEquipment(equipmentId,  linksX,  connectionsX,
                        expressesX, facilitiesX,    equipmentsX,
                        ffpsX,      min_x_left,     max_x_right,
                        min_y_top,  max_y_bottom,   wavelengthX,
                        signalRateX, 'OCH', '',
                        g_sts_conn_list, tempStr, '', '', '', '');
                circuit_util.print_line('wavelength:'||wavelengthX||',signalRate:'||signalRateX||'.');

                IF wavelength<>wavelengthX THEN
                    IF wavelength IS NOT NULL THEN
                        wavelength:=wavelength||'/'||wavelengthX;
                    ELSE
                        wavelength:=wavelengthX;
                    END IF;
                END IF;

                IF signalRate<>signalRateX THEN
                    IF signalRate IS NOT NULL THEN
                        signalRate:=signalRate||'/'||signalRateX;
                    ELSE
                        signalRate:=signalRateX;
                    END IF;
                END IF;

                -- copy temp to output vectors
                FOR i IN 1..linksX.COUNT LOOP
                    links.extend(1);
                    links(links.COUNT):=linksX(i);
                END LOOP;
                FOR i IN 1..connectionsX.COUNT LOOP
                    connections.extend(1);
                    connections(connections.COUNT):=connectionsX(i);
                END LOOP;
                FOR i IN 1..expressesX.COUNT LOOP
                    expresses.extend(1);
                    expresses(expresses.COUNT):=expressesX(i);
                END LOOP;
                FOR i IN 1..facilitiesX.COUNT LOOP
                    facilities.extend(1);
                    facilities(facilities.COUNT):=facilitiesX(i);
                END LOOP;
                FOR i IN 1..equipmentsX.COUNT LOOP
                    equipments.extend(1);
                    equipments(equipments.COUNT):=equipmentsX(i);
                END LOOP;
                FOR i IN 1..ffpsX.COUNT LOOP
                    ffps.extend(1);
                    ffps(ffps.COUNT):=ffpsX(i);
                END LOOP;
            ELSE
                CLOSE v_ref_cursor;
               circuit_util.print_line('Selected OPSM Protection Switch (INTF) not involved in any circuit. RETURNING!!');
            END if;
        END IF;
    circuit_util.print_end('discoverProtectionSwitch');
    END discoverProtectionSwitch;

    PROCEDURE discoverRPR(
        id IN VARCHAR2,                       links OUT NOCOPY V_B_TEXT,            connections OUT NOCOPY V_B_TEXT,
        expresses OUT NOCOPY V_B_STRING,      facilities OUT NOCOPY V_B_STRING,     equipments OUT NOCOPY V_B_STRING,
        ffps OUT NOCOPY V_B_STRING,           min_x_left OUT NOCOPY NUMBER,         max_x_right OUT NOCOPY NUMBER,
        min_y_top OUT NOCOPY NUMBER,          max_y_bottom OUT NOCOPY NUMBER,       wavelength OUT NOCOPY VARCHAR2,
        signalRate OUT NOCOPY VARCHAR2,       neId IN VARCHAR2
    ) AS
        cardId         NUMBER;
        v_ref_cursor          EMS_REF_CURSOR;
        tempStr        VARCHAR2(1000);
     BEGIN
        circuit_util.print_start('discoverRPR');
        /* Initialze vectors. */
        initGlobalVariable();
        g_rpt_init_id := id;

        links          := V_B_TEXT();
        connections    := V_B_TEXT();
        expresses      := V_B_STRING();
        facilities     := V_B_STRING();
        equipments     := V_B_STRING();
        ffps           := V_B_STRING();
        cardId := 0;

        -- get card ID from RPR name
        OPEN v_ref_cursor FOR SELECT CARD_ID FROM CM_CARD WHERE (CARD_AID LIKE 'SMTMP-'||SUBSTR(id, INSTR(id,'-',1,1)+1, 3) OR CARD_AID LIKE 'TGIMP-'||SUBSTR(id, INSTR(id,'-',1,1)+1, 3)) AND NE_ID=neId;
        FETCH v_ref_cursor INTO cardId;
        CLOSE v_ref_cursor;
        IF cardId IS NOT NULL THEN
            /*This is an Add/Drop with TRN/CPM*/
            circuit_util.print_line('Selected TRN/CPM is at add/drop point.');
            discoverEquipment(cardId, links, connections,
                    expresses, facilities, equipments,
                    ffps,      min_x_left, max_x_right,
                    min_y_top, max_y_bottom, wavelength,
                    signalRate, 'OCH', '',
                    g_sts_conn_list, tempStr, '', '', '', '');
        END IF;

        IF neId>0 THEN
            updateCircuitBounds(neId);
        END IF;

        links:=g_link_list;
        connections:=g_conn_List;
        expresses:=g_exp_link_list;
        facilities:=g_fac_List;
        equipments:=g_eqpt_List;
        ffps:=g_ffp_List;
        min_x_left := g_min_x;
        max_x_right := g_max_x;
        min_y_top := g_min_y;
        max_y_bottom := g_max_y;

        print_discover_result('DISCOVERY FROM RPR RESULT');
        circuit_util.print_end('discoverRPR');
    END discoverRPR;
END circuit_discovery;
/
set define on;


select SZBHGLDR.SZBHGLDR_PIDM,
       adminsu.f_format_pname(SZBHGLDR.SZBHGLDR_PIDM, 'FL') "NAME",
       adminsu.f_get_email(SZBHGLDR.SZBHGLDR_PIDM, 'SU') "EMAIL",
       decode(SZBHGLDR.SZBHGLDR_STATUS,
       'A', 'ACTIVE',
       'I', 'INACTIVE',
       NULL, 'PENDING',
       'OTHER') "STATUS",
       f_class_calc_fnc(sgbstdn_pidm, sgbstdn_LEVL_code, :SqlVariable1.CURRENT_TERM) "CLASS",
       SGBSTDN.SGBSTDN_EXP_GRAD_DATE "ExpectGradDate",
       SZBHGLDR.SZBHGLDR_DAYS_AVAIL "DAYS_AVAIL",
       SZBHGLDR.SZBHGLDR_GROUP_CODE "GRP_ASSIGNED",
       adminsu.f_format_pname(SZBHGgrp.SZBHGgrp_host_PIDM, 'FL')  + SZBHGGRP.SZBHGGRP_EXTERNAL_NAME "HOSTS",
       decode(SZBHGGRP.SZBHGGRP_MEET_DAY,
       'S', 'Sunday, ' || SZBHGGRP.SZBHGGRP_MEET_TIME,
       'M', 'Monday, ' || SZBHGGRP.SZBHGGRP_MEET_TIME,
       'T', 'Tuesday, ' || SZBHGGRP.SZBHGGRP_MEET_TIME,
       'W', 'Wednesday, ' || SZBHGGRP.SZBHGGRP_MEET_TIME,
       'H', 'Thursday, ' || SZBHGGRP.SZBHGGRP_MEET_TIME,
       'F', 'Friday, ' || SZBHGGRP.SZBHGGRP_MEET_TIME,
       'Other') "MEET_DAY_TIME",
       SZBHGGRP.SZBHGGRP_CATHOLIC "CATHOLIC",
       DECODE(SZBHGLDR.SZBHGLDR_PARTNER_REQUEST,
       NULL, 'NONE',
       adminsu.f_format_pname(SZBHGLDR.SZBHGLDR_PARTNER_REQUEST, 'FL')) "PARTNER_REQUEST",
       DECODE(SZBHGLDR.SZBHGLDR_PARTNER_REQUEST,
       NULL, 'NONE',
       adminsu.f_get_email(SZBHGLDR.SZBHGLDR_PARTNER_REQUEST, 'SU')) "PARTNER_EMAIL",
       SZBHGLDR.SZBHGLDR_TEAM_LDR_WILLING "T_LEAD_WILLING",
       SZBHGLDR.SZBHGLDR_TEAM_LDR_IND "T_LEADER",
       SZBHGLDR.SZBHGLDR_COMMENTS "STUDENT_COMMENTS",
       SZBHGLDR.SZBHGLDR_OBLIGATIONS,
       SZBHGLDR.SZBHGLDR_ALIGNMENT,
       SZBHGLDR.SZBHGLDR_CALLING,
       SZBHGLDR.SZBHGLDR_EXPERIENCE,
       SZBHGLDR.SZBHGLDR_OTHER_RESP,
       SZBHGLDR.SZBHGLDR_CLARIFY,
       SZBHGLDR.SZBHGLDR_COMMENTS,
       SZBHGLDR.SZBHGLDR_BEFORE,
       SPBPERS.SPBPERS_SEX "SEX",
       fz_get_phone(SZBHGLDR.SZBHGLDR_PIDM, 'CE') "Cell",
       adminsu.f_d_avail_print_string(SZBHGLDR.SZBHGLDR_DAYS_AVAIL) "D_AVAIL_PRINT"
  from ADMINSU.SZBHGLDR SZBHGLDR,
       ADMINSU.SZBHGGRP SZBHGGRP,
       SATURN.SGBSTDN SGBSTDN,
       SATURN.SPBPERS SPBPERS,
       ADMINSU.SZBHGREG SZBHGREG
 where ( SZBHGREG.SZBHGREG_GROUP_CODE = SZBHGGRP.SZBHGGRP_GROUP_CODE (+)
         and SGBSTDN.SGBSTDN_PIDM = SZBHGLDR.SZBHGLDR_PIDM
         and SPBPERS.SPBPERS_PIDM = SZBHGLDR.SZBHGLDR_PIDM
         and SZBHGLDR.SZBHGLDR_PIDM = SZBHGREG.SZBHGREG_PIDM )
   and ( SGBSTDN.SGBSTDN_TERM_CODE_EFF = (select max(sgbstdn_term_code_eff)
         from saturn.sgbstdn S
         where S.sgbstdn_pidm = SGBSTDN.sgbstdn_pidm
         and S.sgbstdn_term_code_eff <= :SqlVariable1.CURRENT_TERM)
         and ( ((:RadioButtonPanel1.BUTTON_VALUE = szbhgldr_status AND :RadioButtonPanel1.BUTTON_VALUE in ('A', 'I'))
           or
           (:RadioButtonPanel1.BUTTON_VALUE = 'P' and szbhgldr_status IS NULL)
           or
           (:RadioButtonPanel1.BUTTON_VALUE = '*')
           ) ) )

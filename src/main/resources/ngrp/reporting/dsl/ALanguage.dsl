## Common DSL Template



#########################################################################################################################################################
## FCTG NGRP DSL HISTORY:
## - 2019-02-07 - v1.0 - Initial DSL language for standardisation, validation and reporting rules (financial and reservation container)
#########################################################################################################################################################

#########################################################################################################################################################
## KEYWORDS AND IMPORTS
#########################################################################################################################################################

## Imports
[keyword]^package {package}=
package {package}
import java.time.*
import java.util.Objects
import java.math.BigDecimal
import javax.naming.InitialContext
import com.fctg.ngrp.model.*
import com.fctg.ngrp.drools.common.*
import com.fctg.ngrp.drools.services.QueryService
import java.time.temporal.ChronoUnit
import static java.time.LocalDate.now
import static com.fctg.ngrp.drools.common.MathFns.*
import static com.fctg.ngrp.drools.common.StringFns.*
import static com.fctg.ngrp.drools.common.SafeFns.safe
import static com.fctg.ngrp.drools.common.SafeFns.strOrEmpty
import static com.fctg.ngrp.drools.common.SafeFns.str
import static com.fctg.ngrp.drools.common.SafeFns.equiv
import static com.fctg.ngrp.drools.common.QueryFns.query
import static com.fctg.ngrp.drools.common.PhoneFns.standardisePhone

## Global variables and functions
global QueryService queryService

## Setup PHREAK EAGER mode by default
[keyword]^rule {mode:IMMEDIATE|EAGER|LAZY} "{name:[^"]+}"=rule "{name}"\n    @Propagation({mode})

## Registers always a rule
[keyword]^end=/**/    Trace rule\n end

#########################################################################################################################################################
## CONVERSIONS (Up to 10 words to Camel/Pascal case)
#########################################################################################################################################################

## Convert entity and field business names up to 10 words to technical names (camel case)
[*]'{a:[^'\s]*} +{b:\w?}{c:[^']*}'='{a}{b!uc}{c}'
[*]'{a:[^'\s]*} +{b:\w?}{c:[^']*}'='{a}{b!uc}{c}'
[*]'{a:[^'\s]*} +{b:\w?}{c:[^']*}'='{a}{b!uc}{c}'
[*]'{a:[^'\s]*} +{b:\w?}{c:[^']*}'='{a}{b!uc}{c}'
[*]'{a:[^'\s]*} +{b:\w?}{c:[^']*}'='{a}{b!uc}{c}'
[*]'{a:[^'\s]*} +{b:\w?}{c:[^']*}'='{a}{b!uc}{c}'
[*]'{a:[^'\s]*} +{b:\w?}{c:[^']*}'='{a}{b!uc}{c}'
[*]'{a:[^'\s]*} +{b:\w?}{c:[^']*}'='{a}{b!uc}{c}'
[*]'{a:[^'\s]*} +{b:\w?}{c:[^']*}'='{a}{b!uc}{c}'
[*]'{a:[^'\s]*} +{b:\w?}{c:[^']*}'='{a}{b!uc}{c}'

## Fix fields names with multiple consecutive initials (can start with ' or .)
[*]{name:beenIn|shouldGoTo}QaStewardship'={name}QAStewardship'
[*]{name:submission|submitter|sourceSystem|serviceProviderThirdParty|legacy|serviceInternal}Id'={name}ID'
[*]{name:traveller}Guid'={name}GUID'
[*]{name:invoicedG|g}stvat'={name}STVAT'
[*]iataNumber'=iATANumber'

## Field names alias (to improve rules readability)
[*]firstName'=firstNames'
[*]rank'=customerReportingRank'

## Math function alias
[*]{op:eras|millennia|centuries|decades|years|months|weeks|days|half_days|hours|minutes|seconds|millis|micros|nanos} between=ChronoUnit.{op!uc}.between

#########################################################################################################################################################
## CONDITIONS (When case) - There is
#########################################################################################################################################################

[when]There is( an?)=There is

## Support for entity naming (financial)
[when]There is financial 'Container'.*=                                         There-is 'FinancialDataContainer' named @'Container'
[when]There is '{entity:SourceSystem}{num:\d*}'{rest:.*}=                       There-is '{entity}' named @'{entity}{num}'{rest} from 'sourceSystem' in 'Container'
[when]There is '{entity:ValidationError}{num:\d*}'{rest:.*}=                    There-is '{entity}' named @'{entity}{num}'{rest} from 'getValidationErrors()' in 'Container'
[when]There is '{entity:QualityStatus}{num:\d*}'{rest:.*}=                      There-is '{entity}' named @'{entity}{num}'{rest} from 'getQualityStatuses()' in 'Container'
[when]There is '{entity:Document}{num:\d*}'{rest:.*}=                           There-is '{entity}' named @'{entity}{num}'{rest} from 'document' in 'QualityStatus'
[when]There is '{entity:QualityMetrics}{num:\d*}'{rest:.*}=                     There-is '{entity}' named @'{entity}{num}'{rest} from 'qualityMetrics' in 'QualityStatus'
[when]There is '{entity:Booking}{num:\d*}' before standardisation{rest:.*}=     There-is '{entity}' named @'{entity}{num}'{rest} from 'initialBooking' in 'Container'
[when]There is '{entity:Booking}{num:\d*}'{rest:.*}=                            There-is '{entity}' named @'{entity}{num}'{rest} from 'standardisedBooking' in 'Container'
[when]There is '{entity:Invoice}{num:\d*}'{rest:.*}=                            There-is '{entity}' named @'{entity}{num}'{rest} from 'invoices' in 'Booking'
[when]There is '{entity:InvoiceRef}{num:\d*}'{rest:.*}=                         There-is '{entity}' named @'{entity}{num}'{rest} from 'invoiceRefs' in 'Invoice'
[when]There is '{entity:InvoiceLine}{num:\d*}'{rest:.*}=                        There-is '{entity}' named @'{entity}{num}'{rest} from 'invoiceLines' in 'Invoice'
[when]There is '{entity:InvoiceService}{num:\d*}'{rest:.*}=                     There-is '{entity}' named @'{entity}{num}'{rest} from 'invoiceServices' in 'InvoiceLine'
[when]There is '{entity:InvoiceServiceDetail}{num:\d*}'{rest:.*}=               There-is '{entity}' named @'{entity}{num}'{rest} from 'invoiceServiceDetails' in 'InvoiceService'
[when]There is '{entity:Traveller}{num:\d*}'{rest:.*}=                          There-is '{entity}' named @'{entity}{num}'{rest} from 'travellers' in 'InvoiceService'
[when]There is '{entity:TravellerRef}{num:\d*}'{rest:.*}=                       There-is '{entity}' named @'{entity}{num}'{rest} from 'travellerRefs' in 'Traveller'
[when]There is '{entity:ReportingRef}{num:\d*}'{rest:.*}=                    	There-is '{entity}' named @'{entity}{num}'{rest} from 'getReportingRefs()' in 'Container'

## Support for entity naming (reservation)
[when]There is reservation 'Container'.*=                                       There-is 'ReservationDataContainer' named @'Container'
[when]There is '{entity:Reservation}{num:\d*}' before standardisation{rest:.*}= There-is '{entity}' named @'{entity}{num}'{rest} from 'initialReservation' in 'Container'
[when]There is '{entity:Reservation}{num:\d*}'{rest:.*}=                        There-is '{entity}' named @'{entity}{num}'{rest} from 'standardisedReservation' in 'Container'
[when]There is '{entity:ReservationRef}{num:\d*}'{rest:.*}=                     There-is '{entity}' named @'{entity}{num}'{rest} from 'reservationRefs' in 'Reservation'
[when]There is '{entity:ReservationService}{num:\d*}'{rest:.*}=                 There-is '{entity}' named @'{entity}{num}'{rest} from 'reservationServices' in 'Reservation'
[when]There is '{entity:ReservationServiceDetail}{num:\d*}'{rest:.*}=           There-is '{entity}' named @'{entity}{num}'{rest} from 'reservationServiceDetails' in 'ReservationService'

## Fix multiple named and/or from
[when]There-is '{entity:\w+}' {mid1:.+ |}named @'{ignored:[^']+}' {mid2:.+ |}named @'{name:\w+}'=                                       There-is '{entity}' named @'{name}' {mid1} {mid2}
[when]There-is '{entity:\w+}' named @'{name:\w+}' from '{field:[^']+}' in '{parent:[^']+}' from '{ignore1:[^']+}' in '{ignore2:[^']+}'= There-is '{entity}' named @'{name}' from '{field}' in '{parent}'
[when]There-is '{entity:\w+}' named @'{name:\w+}' from '{parent:[^']+}' from '{field:[^']+}' in '{ignore1:[^']+}'=                      There-is '{entity}' named @'{name}' from '{field}' in '{parent}'

## Rename InvoiceService and ReservationService name to support Travellers
[*]in '{ignore:Invoice|Reservation}Service{num:\d*}'=in 'Service{num}'
[*]named @'{ignore:Invoice|Reservation}Service{num:\d*}'=named @'Service{num}'

## Generate final drools special entity definitions
[when]\sThere-is '{entity:FinancialDataContainer}'   named @'{name:Container}'=${name}:{entity}($company_name:ModelFns.companyName(standardisedBooking))
[when]\sThere-is '{entity:ReservationDataContainer}' named @'{name:Container}'=${name}:{entity}($company_name:ModelFns.companyName(standardisedReservation))

## Generate final drools entity definitions
[when]\sThere-is '{entity:\w+}' named @'{name:\w+}' from '{field:[^']+}' in '{parent:[^']+}'=${name}:{entity}() from ${parent}.{field}
[when]\sThere-is '{entity:\w+}' named @'{name:\w+}'=${name}:{entity}()

#########################################################################################################################################################
## CONDITIONS (When case) - with ...
#########################################################################################################################################################

## Shortcuts for invoice, reservation and traveller refs
[when]{op:- with|OR|AND|&&|\|\|} 'invoiceRef{num:\d+}'={op} 'getInvoiceRefValue({num})'
[when]{op:- with|OR|AND|&&|\|\|} 'reservationRef{num:\d+}'={op} 'getReservationRefValue({num})'
[when]{op:- with|OR|AND|&&|\|\|} 'travellerRef{num:\d+}'={op} 'getTravellerRefValue({num})'
[when]{op:- with|OR|AND|&&|\|\|} 'reportingRef{num:\d+}'={op} 'getReportingRef({num})'
[when]'invoiceRef{num:\d+}' in='getInvoiceRefValue({num})' in
[when]'reservationRef{num:\d+}' in='getReservationRefValue({num})' in
[when]'travellerRef{num:\d+}' in='getTravellerRefValue({num})' in
[when]'reportingRef{num:\d+}' in='getReportingRef({num})' in


## ----------------------------------------------------------------------------------------------------------------------
## - with '<field>' named/as '<name>'
## ----------------------------------------------------------------------------------------------------------------------
[when]'{field:[^']+}' (as|named) @{name:\w+}=${name}:{field}
[when]'{field:[^']+}' (as|named) @'{name:\w+}'=${name}:{field}
[when]'{field:[^']+}' named=${field}:{field}

## Reference <field> in <entity>
[when]'{field:[^']+}' in '{entity:\w+}'='${entity}.{field}'
[when]@{name:\w+}='${name}'
[when]@'{name:\w+}'='${name}'

## ----------------------------------------------------------------------------------------------------------------------
## - with '<field>' available - For unit test only purposes
## ----------------------------------------------------------------------------------------------------------------------
[when]'{field:[^']+}' available={field} == {field}

## ----------------------------------------------------------------------------------------------------------------------
## - with '<field>' debug - For debug purposes
## ----------------------------------------------------------------------------------------------------------------------
[when]'{field:[^']+}' debug "{message}"=safe("{message}").debugAndTrue
[when]'{field:[^']+}' debug=safe({field}).debugAndTrue

## ----------------------------------------------------------------------------------------------------------------------
## - with '<field>' [not] present
## ----------------------------------------------------------------------------------------------------------------------
[when]'{field:[^']+}' not present={field} == null
[when]'{field:[^']+}' present={field} != null

## ----------------------------------------------------------------------------------------------------------------------
## - with '<field>' [not] empty
## ----------------------------------------------------------------------------------------------------------------------
[when]'{field:[^']+}' not empty=!safe({field}).empty
[when]'{field:[^']+}' empty=safe({field}).empty

## ----------------------------------------------------------------------------------------------------------------------
## - with '<field>' [not] flagged
## ----------------------------------------------------------------------------------------------------------------------
[when]'{field:[^']+}' not flagged=!safe({field}).toBooleanOr(false)
[when]'{field:[^']+}' flagged=safe({field}).toBooleanOr(false)

## ----------------------------------------------------------------------------------------------------------------------
## - with '<field>' [not] future
## ----------------------------------------------------------------------------------------------------------------------
[when]'{field:[^']+}' not future=str({field}) <= OffsetDateTime.now().toString
[when]'{field:[^']+}' future=str({field}) > OffsetDateTime.now().toString

## ----------------------------------------------------------------------------------------------------------------------
## - support basic math functions
## ----------------------------------------------------------------------------------------------------------------------
[when]{op:abs|max|min}\('{field:[^']+}'\)='{op}({field})'
[when]len\('{field:[^']+}'\)='{field}.length'
[when]size\('{field:[^']+}'\)='{field}.size'

## ----------------------------------------------------------------------------------------------------------------------
## - with '<field>' <op> '<field>' (in '<entity>')
## ----------------------------------------------------------------------------------------------------------------------
[when]'{field:[^']+}' not equals='{field}' !=
[when]'{field:[^']+}' (equals|\=\=|\=)='{field}' ==
[when]'{field:[^']+}' {op:<|>|<\=|>\=|\=\=|!\=} '{field2:[^']+}'={field} {op} {field2}

## ----------------------------------------------------------------------------------------------------------------------
## - with '<field>' <op> <value>
## ----------------------------------------------------------------------------------------------------------------------
[when]'{field:[^']+}' {op:<|>|<\=|>\=|\=\=|!\=} {num:[-]?(\d+[.]\d*|[.]\d+)}=safe({field}).toDouble {op} {num}
[when]'{field:[^']+}' {op:<|>|<\=|>\=|\=\=|!\=} {num:[-]?\d+}={field} {op} {num}
[when]'{field:[^']+}' {op:<|>|<\=|>\=|\=\=|!\=} "{text:[^"]*}"={field} {op} "{text}"
[when]'{field:[^']+}' {op:<|>|<\=|>\=|\=\=|!\=} \{{date:\d{4}-\d{2}-\d{2}}\}=str({field}) {op} "{date}"
[when]'{field:[^']+}' {op:<|>|<\=|>\=|\=\=|!\=}={field} {op}

## ----------------------------------------------------------------------------------------------------------------------
## - with '<field>' between <value> and <value>
## ----------------------------------------------------------------------------------------------------------------------
[when]'{field:[^']+}' between {num1:[-]?\d+[.]?\d*} and {num2:[-]?\d+(\d+[.]\d*|[.]\d+)}=safe({field}).toDouble >= {num1} && <= {num2}
[when]'{field:[^']+}' between {num1:[-]?\d+(\d+[.]\d*|[.]\d+)} and {num2:[-]?\d+[.]?\d*}=safe({field}).toDouble >= {num1} && <= {num2}
[when]'{field:[^']+}' between {num1:[-]?\d+} and {num2:[-]?\d+}={field} >= {num1} && <= {num2}
[when]'{field:[^']+}' between "{text1:[^"]*}" and "{text2:[^"]*}"=str({field}) >= "{text1}" && <= "{text2}"
[when]'{field:[^']+}' between \{{date1:\d{4}-\d{2}-\d{2}}\} and \{{date2:\d{4}-\d{2}-\d{2}}\}={field}!.toString >= "{date1}" && <= "{date2}"

## ----------------------------------------------------------------------------------------------------------------------
## - with '<field>' [not] in (<value>,<value>,...)
## ----------------------------------------------------------------------------------------------------------------------
[when]'{field:[^']+}' {op:in|not in} \({texts:"[^"]*"\s*(,\s*"[^"]*")*}\)=str({field}) {op} ({texts})
[when]'{field:[^']+}' {op:in|not in} \({nums:[-]?\d+\s*(,\s*[-]?\d+)*}\)={field} {op} ({nums})
[when]'{field:[^']+}' {op:in|not in} \({nums:[-]?\d+[.]?\d*\s*(,\s*[-]?\d+[.]?\d*)*}\)=safe({field}).toDouble {op} ({nums})

## Transform dates to strings
[when]\{{date:\d{4}-\d{2}-\d{2}}\}="{date}"
[when]'{field:[^']+}' {op:in|not in} \({dates:"\d{4}-\d{2}-\d{2}"\s*(,\s*"\d{4}-\d{2}-\d{2}")*}\)=str({field}) {op} ({dates})

## ----------------------------------------------------------------------------------------------------------------------
## - with '<field>' length/words/age <op> <num>
## ----------------------------------------------------------------------------------------------------------------------
[when]'{field:[^']+}' {op:length|words|age} not equals='{field}' {op} !=
[when]'{field:[^']+}' {op:length|words|age} (equals|\=\=|\=)='{field}' {op} ==
[when]'{field:[^']+}' length {op:<|>|<\=|>\=|\=\=|!\=} {num:[-]?\d+}=safe({field}).length {op} {num}
[when]'{field:[^']+}' words {op:<|>|<\=|>\=|\=\=|!\=} {num:[-]?\d+}=safe({field}).numberOfWords {op} {num}
[when]'{field:[^']+}' age {op:<|>|<\=|>\=|\=\=|!\=} {num:[-]?\d+}=safe({field}).age {op} {num}

## ----------------------------------------------------------------------------------------------------------------------
## - with '<field>' length/words/age between <num> and <num>
## ----------------------------------------------------------------------------------------------------------------------
[when]'{field:[^']+}' length between {num1:[-]?\d+} and {num2:[-]?\d+}=safe({field}).length >= {num1} && <= {num2}
[when]'{field:[^']+}' words between {num1:[-]?\d+} and {num2:[-]?\d+}=safe({field}).numberOfWords >= {num1} && <= {num2}
[when]'{field:[^']+}' age between {num1:[-]?\d+} and {num2:[-]?\d+}=safe({field}).age >= {num1} && <= {num2}

## ----------------------------------------------------------------------------------------------------------------------
## - with '<field>' [not] matches/find "<regex>"
## ----------------------------------------------------------------------------------------------------------------------
[when]'{field:[^']+}' {op:matches|not matches} "{regex:[^"]+}"={field} {op} "{regex}"
[when]'{field:[^']+}' {not:not |}find "{regex:[^"]+}"={field} {not}matches ".*{regex}.*"

## ----------------------------------------------------------------------------------------------------------------------
## - with '<field>' [not] contains "<text>"
## ----------------------------------------------------------------------------------------------------------------------
[when]'{field:[^']+}' {op:contains|not contains} "{text:[^"]+}"={field} {op} "{text}"

## ----------------------------------------------------------------------------------------------------------------------
## - with '<field>' [not] starts|ends with "<text>"
## ----------------------------------------------------------------------------------------------------------------------
[when]'{field:[^']+}' {not:not |}{op:starts|ends} with "{text:[^"]+}"=strOrEmpty({field}).trim {not} str[{op}With] "{text}"

## ----------------------------------------------------------------------------------------------------------------------
## - with '<field>' exists in "Hotels" with date sensitivity '<date>' using hotel name threshold of <value>
## ----------------------------------------------------------------------------------------------------------------------
[when]'{field:firstLocation|lastLocation}' exists in "Hotels" with date sensitivity '{date:[^']+}' using hotel name threshold of {value:1[.]0*|0[.]\d+}=query(queryService).matchesLocation({date}, {field}, {value})

## ----------------------------------------------------------------------------------------------------------------------
## - with '<field>' [not] exists in "<entity-name>" [filtered by '<filter1>' [and by <filter2>]
## ----------------------------------------------------------------------------------------------------------------------
[when]'{field:[^']+}' {op:not |}exists in "{entityName:[^"]+}" with date sensitivity '{date:[^']+}' filtered by '{filter1:[^']+}' and by '{filter2:[^']+}' = {op}query(queryService).exists({date}, "{entityName}", $company_name, $Container.getMarket(), {filter1}, {filter2}, {field})
[when]'{field:[^']+}' {op:not |}exists in "{entityName:[^"]+}" with date sensitivity '{date:[^']+}' filtered by '{filter:[^']+}'                           = {op}query(queryService).exists({date}, "{entityName}", $company_name, $Container.getMarket(), {filter}, {field})
[when]'{field:[^']+}' {op:not |}exists in "{entityName:[^"]+}" with date sensitivity '{date:[^']+}'                                                        = {op}query(queryService).exists({date}, "{entityName}", $company_name, $Container.getMarket(), {field})
[when]not query=!query

## ----------------------------------------------------------------------------------------------------------------------
## - with '<field>' [not] equals translate <field2> using "<entity-name>" [filtered by '<filter1>' [and by <filter2>]
## ----------------------------------------------------------------------------------------------------------------------
[when]'{field:[^']+}' {op:not |}equals translate '{filter1:[^']+}' using "{entityName:[^"]+}" with date sensitivity '{date:[^']+}' filtered by '{filter1:[^']+}' and by '{filter2:[^']+}' = {op}equiv({field}, query(queryService).translate({date}, "{entityName}", $company_name, $Container.getMarket(), {filter1}, {filter2}, {field2})
[when]'{field:[^']+}' {op:not |}equals translate '{filter1:[^']+}' using "{entityName:[^"]+}" with date sensitivity '{date:[^']+}' filtered by '{filter:[^']+}'                           = {op}equiv({field}, query(queryService).translate({date}, "{entityName}", $company_name, $Container.getMarket(), {filter}, {field2})
[when]'{field:[^']+}' {op:not |}equals translate '{filter1:[^']+}' using "{entityName:[^"]+}" with date sensitivity '{date:[^']+}'                                                        = {op}equiv({field}, query(queryService).translate({date}, "{entityName}", $company_name, $Container.getMarket(), {field2})
[when]not equiv=!equiv

## ----------------------------------------------------------------------------------------------------------------------
## - with '<field>' any|none word member of "<entity-name>"
## ----------------------------------------------------------------------------------------------------------------------
[when]'{field:[^']+}' any word member of "{entityName:[^"]+}" with date sensitivity '{date:[^']+}'={field} != null   &&  ListFns.allMemberOf({field}.toString.trim.split("\\s+"), query(queryService).keys({date}, "{entityName}", $company_name, $Container.getMarket()))
[when]'{field:[^']+}' none word member of "{entityName:[^"]+}" with date sensitivity '{date:[^']+}'=({field} == null || !ListFns.allMemberOf({field}.toString.trim.split("\\s+"), query(queryService).keys({date}, "{entityName}", $company_name, $Container.getMarket())))

## ----------------------------------------------------------------------------------------------------------------------
## - with '<field>' contains any/none of "<entity-name>"
## ----------------------------------------------------------------------------------------------------------------------
[when]'{field:[^']+}' contains {op:any|none} of "{entityName:[^"]+}" with date sensitivity '{date:[^']+}'={field} != null && ListFns.contains{op!ucfirst}Of({field}, query(queryService).keys({date}, "{entityName}", $company_nam, $Container.getMarket()))

## ----------------------------------------------------------------------------------------------------------------------
## - with '<field>' starts|ends with any|none of "<entity-name>"
## ----------------------------------------------------------------------------------------------------------------------
[when]'{field:[^']+}' {op:starts|ends} with {op2:any|none} of "{entityName:[^"]+}" with date sensitivity '{date:[^']+}'={field} != null && ListFns.{op}With{op2!ucfirst}Of({field}, query(queryService).keys({date}, "{entityName}", $company_name, $Container.getMarket()))

## ----------------------------------------------------------------------------------------------------------------------
## - with '<field>' starts|ends with any|none of "<entity-name>"
## ----------------------------------------------------------------------------------------------------------------------
[when]'{field:[^']+}' {op:starts|ends} with {op2:any|none} of "{entityName:[^"]+}" with date sensitivity '{date:[^']+}'={field} != null && ListFns.{op}With{op2!ucfirst}Of({field}, query(queryService).keys({date}, "{entityName}", $company_name, $Container.getMarket()))

## Field operations
[when]- with=
[when]OR=||
[when]AND=&&
[when]\====
[when]{op:!|<|>}\=\=={op}=
[when]\=\=\=\====
[when]'{field:[^']+}'={field}

#########################################################################################################################################################
## ACTIONS (Then case)
#########################################################################################################################################################

## Convert field names to Pascal
[then]'{a:[a-z]}{b:[^']*}'='{a!uc}{b}'
[then]'Now\(\)'='now()'

## Prepare remove action to automatically support named parent entities without specifying the from clause
[then]{remove:Remove 'Invoice\d*'.*}=       {remove} from 'Invoices' in 'Booking'
[then]{remove:Remove 'InvoiceRef\d*'.*}=    {remove} from 'InvoiceRefs' in 'Invoice'
[then]{remove:Remove 'InvoiceLine\d*'.*}=   {remove} from 'InvoiceLines' in 'Invoice'
[then]{remove:Remove 'ServiceDetail\d*'.*}= {remove} from 'ServiceDetails' in 'InvoiceService'
[then]{remove:Remove 'Traveller\d*'.*}=     {remove} from 'Travellers' in 'InvoiceService'
[then]{remove:Remove 'TravellerRef\d*'.*}=  {remove} from 'TravellerRefs' in 'Traveller'

## Fix remove action when specify the form clause
[then]Remove '{entity:\w+}' from '{field:\w+}' in '{parent:\w+}' from '{ignored:[^']+}' in '{ignored2:\w+}'= Remove '{entity}' from '{field}' in '{parent}'
[then]Remove '{entity:\w+}' from '{parent:\w+}' from '{field:\w+}' in '{ignored:\w+}'=                       Remove '{entity}' from '{field}' in '{parent}'

## Fix implicit set action
[then]Set '{field:\w+}' with=Set '{field}' in 'Container' with
[then]{command:Replace|Transform|Translate|Standardise} '{field:\w+}' in '{entity:\w+}'=Set '{field}' in '{entity}' with {command!lc} '{field}' in '{entity}'

## Add automatic default value for translate actions
[then]Set '{field:\w+}' in '{entity:\w+}' with translate {rest:.*}=Set '{field}' in '{entity}' with translate {rest} and default '{field}' in '{entity}'
[then]{translate:Set .* with translate .* and default .*} and default '[^']+' in '[^']+'={translate}

## ==========================================================================================================================================
## = Actions that are neutral - don't use fields
## ==========================================================================================================================================

## ----------------------------------------------------------------------------------------------------------------------
## Do nothing
## ----------------------------------------------------------------------------------------------------------------------
[then]Do nothing=
        /* Nothing to do! */

## ----------------------------------------------------------------------------------------------------------------------
## Debug "<message>"
## ----------------------------------------------------------------------------------------------------------------------
[then]Debug "{message:[^"]+}"=
        safe("{message}").debugAndTrue();

## ----------------------------------------------------------------------------------------------------------------------
## Archive booking
## ----------------------------------------------------------------------------------------------------------------------
[then]Archive booking=
        $Container.setShouldBeArchived(true);

## ----------------------------------------------------------------------------------------------------------------------
## Trace rule
## ----------------------------------------------------------------------------------------------------------------------
[then]Trace rule=
        $Container.addTraceInfo(drools.getRule().getPackageName(), drools.getRule().getName());

## ==========================================================================================================================================
## = Actions that don't support named fields - must specify always '<entity>' in '<entity>'
## ==========================================================================================================================================

## ----------------------------------------------------------------------------------------------------------------------
## Swap '<field>' in '<entity>' with '<field>' in '<entity>'
## ----------------------------------------------------------------------------------------------------------------------
[then]Swap '{field1:\w+}' in '{entity1:\w+}' with '{field2:\w+}' in '{entity2:\w+}'=
        ModelFns.set(val -> ${entity2}.set{field2}(val), ${entity1}.get{field1}(), val -> ${entity1}.set{field1}(val), ${entity2}.get{field2}());

## ==========================================================================================================================================
## = Actions that support named fields - can use '<entity>' in '<entity>', @'<field>' or @<field>
## ==========================================================================================================================================

## ----------------------------------------------------------------------------------------------------------------------
## Standardise '<entity>' in '<entity>', @'<field>' or @<field>
## ----------------------------------------------------------------------------------------------------------------------
[then]{op:[a-z]+} '{field:\w+}' in '{entity:\w+}'={op} '${entity}.get{field}()'
[then]@{name:\w+}='${name}'
[then]@'{name:\w+}'='${name}'

## ----------------------------------------------------------------------------------------------------------------------
## Clear '<entity>' in '<entity>'
## ----------------------------------------------------------------------------------------------------------------------
[then]Clear '{field:\w+}' in '{entity:\w+}'=
        ${entity}.set{field}(null);

## ----------------------------------------------------------------------------------------------------------------------
## Remove '<entity-to-remove>' from '<field>'
## ----------------------------------------------------------------------------------------------------------------------
[then]Remove '{entityToRemove:\w+}' from '{field:[^']+}'=
        {field}.remove(${entityToRemove});

## ----------------------------------------------------------------------------------------------------------------------
## Set '<field>' in '<entity>' with replace '<field>' in '<entity>' using "<regex>" with "<replacement>"
## ----------------------------------------------------------------------------------------------------------------------
[then]Set '{field:\w+}' in '{entity:\w+}' with replace '{field2:[^']+}' using "{regex}" with "{replacement}"=
        ${entity}.set{field}FromString(StringFns.nullIfBlank(strOrEmpty({field2}).replaceAll("{regex}", "{replacement}")));

## ----------------------------------------------------------------------------------------------------------------------
## Set '<field>' in '<entity>' with transform '<field>' in '<entity>' to upper/lower/capital case
## ----------------------------------------------------------------------------------------------------------------------
[then]Set '{field:\w+}' in '{entity:\w+}' with transform '{field2:[^']+}' to {type:upper|lower|capital} case=
        ${entity}.set{field}FromString(StringFns.{type}({field2}));

## ----------------------------------------------------------------------------------------------------------------------
## Set '<field>' in '<entity>' with translate '<field>' in '<entity>' using "<entity-name>" [filtered by '<field>' in '<entity>'] [and default "{value}"|'<field>' in '<entity>']
## ----------------------------------------------------------------------------------------------------------------------
[then]default '{value:[^']+}'=default 'str({value})'
[then]default {value:"[^"]*"|null}=default '{value}'

[then]Set '{field:\w+}' in '{entity:\w+}' with translate '{key:[^']+}' using "{entityName}" with date sensitivity '{date:[^']+}' filtered by '{filter1:[^']+}' and by '{filter2:[^']+}' and default '{value:[^']+}'=
        ${entity}.set{field}FromString(query(queryService).translate({date}, "{entityName}", $company_name, $Container.getMarket(), {filter1}, {filter2}, {key}).orElse({value}));

[then]Set '{field:\w+}' in '{entity:\w+}' with translate '{key:[^']+}' using "{entityName}" with date sensitivity '{date:[^']+}' filtered by '{filter:[^']+}' and default '{value:[^']+}'=
        ${entity}.set{field}FromString(query(queryService).translate({date}, "{entityName}", $company_name, $Container.getMarket(), {filter}, {key}).orElse({value}));

[then]Set '{field:\w+}' in '{entity:\w+}' with translate '{key:[^']+}' using "{entityName}" with date sensitivity '{date:[^']+}' and default '{value:[^']+}'=
        ${entity}.set{field}FromString(query(queryService).translate({date}, "{entityName}", $company_name, $Container.getMarket(), {key}).orElse({value}));

## ----------------------------------------------------------------------------------------------------------------------
## Set '<field>' in '<entity>' with standardise '<field>' in '<entity>' using google-lib for "<country-code>"
## ----------------------------------------------------------------------------------------------------------------------
[then]Set '{field:\w+}' in '{entity:\w+}' with standardise '{field2:[^']+}' using google-lib for "{countryCode}"=
        ${entity}.set{field}FromString(standardisePhone({field2}, "{countryCode}"));

[then]Set '{field:\w+}' in '{entity:\w+}' with standardise '{field2:[^']+}' using google-lib=
        ${entity}.set{field}FromString(standardisePhone({field2}, $Container.getMarket()));

[then]Set '{field:FirstLocation|LastLocation}' in '{entity:\w+}' with standardise '{location:[^']+}' using "Hotels" with date sensitivity '{date:[^']+}'=
        query(queryService).standardisedLocation({date}, {location}).ifPresent(location -> ${entity}.update{field}(location));

## ----------------------------------------------------------------------------------------------------------------------
## Standardised reporting ref using EBM
## ----------------------------------------------------------------------------------------------------------------------

[then]Standardised reporting ref using EBM=
        query(queryService).standardisedEBM($Container, $Service, $Traveller, $company_name, $Container.getMarket());
        
## ----------------------------------------------------------------------------------------------------------------------
## Set '<field>' in '<entity>' with <value>
## ----------------------------------------------------------------------------------------------------------------------


[then]Set '{field:\w+}' in '{entity:\w+}' with '{value:[^']+}'=
        ${entity}.set{field}({value});

[then]Set '{field:\w+}' in '{entity:\w+}' with \{{date:\d{4}-\d{2}-\d{2}}\}=
        ${entity}.set{field}(LocalDate.parse("{date}"));

[then]Set '{field:\w+}' in '{entity:\w+}' with {num:[-]?\d+[.]\d+}=
        ${entity}.set{field}(BigDecimal.valueOf({num}));

[then]Set '{field:\w+}' in '{entity:\w+}' with {value:.*}=
        ${entity}.set{field}({value});

## ----------------------------------------------------------------------------------------------------------------------
## Mark '<field>' in '<entity>' with '<status>' [alias "<file>.<field>"] because '<message>'
## ----------------------------------------------------------------------------------------------------------------------
[then]Mark '{field:\w+}' in '{entity:\w+}' alias "{entityAlias:[A-Z]+}{point:[.]}{fieldAlias:[A-Z0-9]+}"=Mark: '{field}' in '{entity}' alias '"{entityAlias}"' '"{fieldAlias}"'
[then]Mark '{field:\w+}' in '{entity:\w+}' with                                                         =Mark: '{field}' in '{entity}' alias 'null' 'null' with
[then]Mark: '{field:\w+}' in '{entity:Container}'       =Mark:: '{field}' in '{entity}' vars 'DocumentError.of(null, $Container.getMarket())'
[then]Mark: '{field:\w+}' in '{entity:Traveller\d*}'    =Mark:: '{field}' in '{entity}' vars 'DocumentError.of($company_name, $Container.getMarket(), ${entity}.getParent())'
[then]Mark: '{field:\w+}' in '{entity:TravellerRef\d*}' =Mark:: '{field}' in '{entity}' vars 'DocumentError.of($company_name, $Container.getMarket(), ${entity}.getParent().getParent())'
[then]Mark: '{field:\w+}' in '{entity:\w+}'             =Mark:: '{field}' in '{entity}' vars 'DocumentError.of($company_name, $Container.getMarket(), ${entity})'
[then]Mark:: '{field:\w+}' in '{entity:\w+}' vars '{documentError:[^']+}' alias '{entityAlias:[^']+}' '{fieldAlias:[^']+}' with '{status}' because "{message}"=
        DocumentError documentError = {documentError};
        $Container.addValidationError(ValidationError.builder()
            .setSourceSystem($Container.getSourceSystem())
            .setDocumentNumber(documentError.getDocument().getNumber())
            .setServiceType(documentError.getType())
            .setValidationStatus(ValidationStatus.{status})
            .setEntityName("{entity}")
            .setFieldName("{field}")
            .setFieldValue(str(${entity}.get{field}()))
            .setEntityNameAlias({entityAlias})
            .setFieldNameAlias({fieldAlias})
            .setMessage("{message}" + " [" + drools.getRule().getName().replaceFirst(" .*","") + "]")
            .setEntityObj(${entity})
            .setCompanyName($company_name)
            .build());
         $Container.addQualityStatus(documentError.qualityStatus(ValidationStatus.{status}));

## ==========================================================================================================================================
## = Data model fixes
## ==========================================================================================================================================
[then]get{field:ManualSubmission|BeenInQAStewardship|ShouldGoToQAStewardship|Internal}\(\)=is{field}()
[then]get{entity:Invoice|Reservation|Traveller}Ref{num:\d+}\(\)=get{entity}RefValue({num})
[then]set{entity:Invoice|Reservation|Traveller|Reporting}Ref{num:\d+}FromString=set{entity}Ref{num}
[then]set{entity:Invoice|Reservation|Traveller}Ref{num:\d+}\({arg:[^)]*}=set{entity}RefValue({num},{arg}
[then]set{entity:Reporting}Ref{num:\d+}\({arg:[^)]*}=add{entity}Ref($Service,$Traveller,{num},{arg}

## ==========================================================================================================================================
## = If then Else statement
## ==========================================================================================================================================
[then](If|if) {value1} (!\=|not \=|not equals) {value2} then=if(!Objects.equals({value1}, {value2})) \{
[then](If|if) {value1} (\=\=|\=|equals) {value2} then=if(Objects.equals({value1}, {value2})) \{
[then](If|if) not {condition} then=if(!{condition}) \{
[then](If|if) {condition} then=if({condition}) \{
[then]Else if=\} else if
[then]Else=\} else \{
[then]End=\}

## ==========================================================================================================================================
## = Final fixes
## ==========================================================================================================================================
[then]'${name:\w+}'=${name}
[then]{type:double|int|long|boolean|String|BigDecimal|LocalDate|OffsetDateTime} {var:[$]?\w+} {default:\=.*}={type} {var} {default};
[then]OR=||
[then]AND=&&

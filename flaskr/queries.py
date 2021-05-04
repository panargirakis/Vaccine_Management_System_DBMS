
# return ssn and name from person with matching username and password
find_ssn_name_for_cred = "SELECT DISTINCT P.SSN, P.Name FROM People P " \
                        "WHERE P.username= :username AND P.password= :password"


# Find all available appointments by distribution location (support intersection with 6, 7)
find_appt_by_dist_loc = "SELECT DISTINCT A.appt_id, A.appt_date, T1.location_name FROM Appointments A, " \
                       "((SELECT DISTINCT DL.location_id, DL.location_name FROM Distribution_Location DL " \
                       "WHERE DL.location_name= :loc_name)T1) WHERE A.located=T1.location_id"

find_all_comorbidities = "SELECT DISTINCT C.Disease_Name FROM Comorbidities C"

# Find an appointment where the given search string matches the date OR time OR Distribution Location OR Vaccine Type
find_appt_by_time_or_loc_or_type = "SELECT DISTINCT A.appt_id, A.appt_date, T1.location_name FROM Appointments" \
                                  " A, ((SELECT DISTINCT DL.location_id, DL.location_name FROM Distribution_Location DL " \
                                  "WHERE DL.location_name= :loc_name )T1), " \
                                  "((SELECT DISTINCT V.vaccine_id, V.vaccine_name FROM Vaccine_Type V " \
                                  "WHERE V.vaccine_name= :vac_name )T2) WHERE A.located=T1.location_id OR " \
                                  "A.vaccine_id=T2.vaccine_id OR A.appt_date= :appt_date"

find_appt_by_date_time = "SELECT DISTINCT A.appt_id, A.appt_date FROM Appointments A " \
                         "WHERE A.appt_date = :d_date"

# Find all available appointments by vaccine type
find_appt_by_vac_type = "SELECT DISTINCT A.appt_id, A.appt_date, T.Vaccine_Name FROM Appointments A, " \
                        "((SELECT DISTINCT V.Vaccine_ID, V.vaccine_Name FROM Vaccine_Type V " \
                        "WHERE V.Vaccine_Name = :vac_name)T) WHERE A.Vaccine_ID = T.Vaccine_ID"

# Find all available appointments by vaccine type and Date
find_appt_by_vac_type_and_date = \
"SELECT DISTINCT A.appt_id, A.appt_date, T.Vaccine_Name FROM Appointments A," \
"((SELECT DISTINCT V.Vaccine_ID, V.vaccine_Name FROM Vaccine_Type V WHERE V.Vaccine_Name = :vac_name)T) " \
"WHERE A.Vaccine_ID = T.Vaccine_ID AND A.appt_date = :d_date)"

# Find all available appointments in a given distribution location and date.
find_appt_by_dist_loc_and_date = \
"SELECT ap.Appt_ID, TO_CHAR(ap.Appt_date, 'MM-DD-YYYY HH24:MI:SS'), dl.Location_name, ad.Street," \
" ad.Apartment, ad.City, ad.State, Ad.State, ad.Country, vt.Vaccine_Name FROM Appointments ap " \
"INNER JOIN Distribution_Location dl ON ap.Located = dl.location_id" \
" INNER JOIN Address ad ON ad.Address_ID = dl.Located" \
" INNER JOIN Vaccine_Type vt ON vt.Vaccine_ID = ap.Vaccine_ID " \
"WHERE dl.Location_name = :dist_loc AND TRUNC(ap.Appt_date) = :d_date"

# Find future appointments for a person
find_appt_by_person = \
"SELECT ap.Appt_ID, TO_CHAR(ap.Appt_date, 'MM-DD-YYYY HH24:MI:SS'), dl.Location_name, " \
"ad.Street, ad.Apartment, ad.City, ad.State, ad.Country, vt.Vaccine_Name " \
"FROM Appointments ap INNER JOIN Distribution_Location dl ON ap.Located = dl.location_id " \
"INNER JOIN Address ad ON ad.Address_ID = dl.Located " \
"INNER JOIN Vaccine_Type vt ON vt.Vaccine_ID = ap.Vaccine_ID " \
"WHERE ap.SSN = :ssn AND ap.Appt_date > SYSDATE"

# find_all_available_appointments = \
# "select a.appt_date, dl.location_name, a.is_part_of, v.vaccine_name"\
# "from appointments a, Distribution_Location dl, vaccine_type v"\
# "where a.ssn IS NULL and a.located = dl.Location_ID AND a.vaccine_id = v.vaccine_id"\
# "order by a.appt_id"

# Find all available appointments
all_available_appointments = "select a.appt_date, dl.location_name, a.is_part_of, v.vaccine_name from appointments a, Distribution_Location dl, vaccine_type v where a.ssn IS NULL and a.located = dl.Location_ID AND a.vaccine_id = v.vaccine_id order by a.appt_id"

available_appointments_by_user_eligibility = \
    "select distinct a.appt_date, dl.location_name, a.is_part_of, v.vaccine_name " \
    "from appointments a, Distribution_Location dl, vaccine_type v, people p " \
    "where a.ssn IS NULL and a.located = dl.Location_ID AND a.vaccine_id = v.vaccine_id " \
    "AND a.is_part_of >= (select phase_number from people where SSN = :u_ssn)"
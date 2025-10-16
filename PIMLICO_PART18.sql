BEGIN;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9b1518dc-1e68-48fb-92ef-5883782c910d', '2e89900c-bc75-43af-8cff-c9a10fcba20e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Churchill Place, London E14 5HP quoting invoice number and customer code') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0cd867d7-ec0c-4aa1-8652-fc05c0744263', '758b4843-863b-4964-b845-546edc17d373', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '22', 'other', 'Wembley Park Boulevard') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5c1999bf-187a-4018-ba85-0ccbba8a4800', '758b4843-863b-4964-b845-546edc17d373', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Churchill Place, London E14 5HP quoting invoice number and customer code') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9c5db487-924f-4d4a-a637-5a8e39ca895f', 'e7721e58-2c1a-4844-99a2-0e484c9f1a97', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '22', 'other', 'Wembley Park Boulevard') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('418ae147-9edc-48b8-9ade-391191c22d75', 'e7721e58-2c1a-4844-99a2-0e484c9f1a97', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Churchill Place, London E14 5HP quoting invoice number and customer code') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('66a11e7e-9f05-4d34-aa59-a878cb075eb4', 'a09035ba-a754-4c25-a4cd-c313d24cf7db', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '9', 'other', 'ST THOMAS STREET Quote No: 3197') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c3613e6a-1b95-4eb0-8d61-2e82b4b220f8', 'a09035ba-a754-4c25-a4cd-c313d24cf7db', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'MONTHLY FIRE ALARM SERVICE') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('149aefc5-3859-44fa-b7f5-97e491723397', 'a09035ba-a754-4c25-a4cd-c313d24cf7db', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'MONTHLY DRY RISER SERVICE') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cb0041ec-339a-4b59-8253-961292549c42', 'a09035ba-a754-4c25-a4cd-c313d24cf7db', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'MONTHLY FIRE ALARM SERVICE 2.00 £280.00 20% £560.00') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1f24bf9e-1be8-47f7-81a2-6ff654af992b', 'a09035ba-a754-4c25-a4cd-c313d24cf7db', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'MONTHLY AOV SERVICE 2.00 £375.00 20% £750.00') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('673d15dc-02a1-4fed-9de1-9affd8430f93', '2daa0ed5-1cc4-467c-9cd8-3230c2f08c3d', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fb2b39c8-e581-407d-8a3c-4cc54a2a005f', '2daa0ed5-1cc4-467c-9cd8-3230c2f08c3d', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a42c5cfe-2c3f-409c-963c-dca8f5b17562', '2daa0ed5-1cc4-467c-9cd8-3230c2f08c3d', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('79af0058-a9ef-4456-b4d9-402c00f2d995', '4369add9-927f-4734-8816-6bb6f767d106', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7bcc6855-8ea9-4d8b-a314-4bcb7831ffd5', '4369add9-927f-4734-8816-6bb6f767d106', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('73da6bd2-376b-4537-a75c-2c5191f041c6', '4369add9-927f-4734-8816-6bb6f767d106', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2723b391-ab66-460c-bca0-f13aa03291a6', '9a866f57-0715-4596-8b22-f76f09dcd512', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8e900d8d-5082-4c8e-96b3-e2a694d2c94c', '9a866f57-0715-4596-8b22-f76f09dcd512', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e68f57bd-444b-4552-b944-2778a41787e6', '9a866f57-0715-4596-8b22-f76f09dcd512', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('25a60919-437d-46a1-b921-40c58671f602', '7e53d2b4-fbef-4041-bc78-839247ee8c21', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'London Bridge http://www.graingerplc.co.uk Newcastle upon Tyne, UK') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('14649d7d-6537-4f02-a883-8041138c365d', '61637eeb-d3c2-4f63-addd-8a6bde009eab', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'use', 'Eastbourne Terrace			Merchant’s House') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f9bb86e4-2909-4f0a-89bd-73c55a58b6a8', 'fd9b0d12-b87f-4923-88a1-8788d8e4cbff', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'use', 'Eastbourne Terrace Merchant’s House') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('88abb9a8-6536-448c-a6bb-67494346497b', '77f244f2-c79d-4929-9ac1-fa757a5f98aa', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Employer (and/or plant owner) Network Homes') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bf8f6663-3172-4402-a938-56538bf9a9c4', '77f244f2-c79d-4929-9ac1-fa757a5f98aa', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'Address NETWORK HOMES LTD') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2e47f034-8c68-46a3-99c8-4d93c274751a', '77f244f2-c79d-4929-9ac1-fa757a5f98aa', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3', 'other', 'Address at which the E Block') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d7b46c2f-c17e-4595-92d8-3cf35941124e', '77f244f2-c79d-4929-9ac1-fa757a5f98aa', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4', 'other', 'Description of Lifting ELECTRIC PASSENGER/GOODS LIFT (FIREMAN LIFT)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b951b46b-9d38-48f7-b03f-d561d6d9bde6', '77f244f2-c79d-4929-9ac1-fa757a5f98aa', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5', 'other', 'Nature of Examination Thorough Examination carried out within an interval of 6 months under Regulation 9(3)(a)(i) unless') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a5e8b7bb-c7e4-4cf1-aa64-09bd4b128e51', '77f244f2-c79d-4929-9ac1-fa757a5f98aa', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'Identification of any part found None.') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('723af8cf-973b-48fc-b37e-ae3f3316578b', '77f244f2-c79d-4929-9ac1-fa757a5f98aa', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '8', 'other', 'Observations and condition of The suspension belts are worn, but remain serviceable.') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1f2034f4-75ba-4632-bfa6-f9ed10a9ec34', '77f244f2-c79d-4929-9ac1-fa757a5f98aa', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '9', 'other', 'Date of last thorough 16/07/2020') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1debc94f-8ce2-40a4-98fa-cbae8dd0db65', '7df575c1-df6c-4c6a-b593-5f9fcb631bb5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '105', 'other', 'Piccadilly 105 Piccadilly') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ab24fbcf-7274-436a-afd0-7e2e93ba42e5', '7df575c1-df6c-4c6a-b593-5f9fcb631bb5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12', 'other', 'Endeavour Square Exchange Tower') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3deca602-cfd1-4e61-bec4-72f7a13ead56', '7df575c1-df6c-4c6a-b593-5f9fcb631bb5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '15', 'other', 'St Botolph Street Wilmslow') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a9c513fa-9aa9-4958-bc7e-7e1a4143f2ff', '1bb10829-c43c-4d53-87ca-aa8a258e6bcb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Information about our regulatory status') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('572384cb-bec9-444f-ac17-2b647a250e19', '1bb10829-c43c-4d53-87ca-aa8a258e6bcb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'insurance', 'Duty of Disclosure to Insurers') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ada920e5-01db-445d-a445-903af2225fc0', '1bb10829-c43c-4d53-87ca-aa8a258e6bcb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '10', 'other', 'Interest on Client Money') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('af879dbb-803e-43f0-b998-d191605df948', '1bb10829-c43c-4d53-87ca-aa8a258e6bcb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12', 'other', 'Cancellation of this Agreement') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('74f55c98-2a56-460d-b5c4-fe5bf144c579', '1bb10829-c43c-4d53-87ca-aa8a258e6bcb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '15', 'other', 'Prevention of Financial Crime') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('253aa0ff-b194-4540-9a2d-a9e1dd6b716e', '1bb10829-c43c-4d53-87ca-aa8a258e6bcb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '17', 'other', 'Limitation of Liabilities') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('14669e5d-a43a-41e9-a4e8-e4a34e0148eb', '1bb10829-c43c-4d53-87ca-aa8a258e6bcb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '105', 'other', 'Piccadilly 105 Piccadilly') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('38c3dfd4-d954-4f48-bdf6-ea47613e3f0d', '1bb10829-c43c-4d53-87ca-aa8a258e6bcb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12', 'other', 'Endeavour Square Exchange Tower') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ce92673a-7ef0-4061-b93e-0716ca8b007c', '1bb10829-c43c-4d53-87ca-aa8a258e6bcb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '15', 'other', 'St Botolph Street Wilmslow') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('12e50850-24ee-4aa2-b16e-3ff1c99af534', 'aa818f34-e734-4d26-84b2-63d227a553a0', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '105', 'other', 'Piccadilly 105 Piccadilly') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('794d2d4c-0553-4794-82fc-ba4c580cb1f8', 'aa818f34-e734-4d26-84b2-63d227a553a0', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12', 'other', 'Endeavour Square Exchange Tower') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9736e0b9-c71e-4682-a150-db807b64fd36', 'aa818f34-e734-4d26-84b2-63d227a553a0', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '15', 'other', 'St Botolph Street Wilmslow') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('078d7e43-25a8-498a-8e3f-6b848fb12916', 'f488aaac-1e91-4f70-8056-bdff4cc58cf4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '15', 'insurance', 'Prevention of Financial Crime 21 Contact Addresses ST GILES INSURANCE& FINANCE') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c0c2ae63-71d8-48c9-aa9e-353be4218436', 'f488aaac-1e91-4f70-8056-bdff4cc58cf4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '16', 'other', 'Data Protection you. assets when it is responsible for them.') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('91cb304e-73f9-4166-8de7-d3a3019346fa', 'f488aaac-1e91-4f70-8056-bdff4cc58cf4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '17', 'other', 'Limitation of Liabilities Postal address These terms will remain in force and shall apply to will be aware of any possible conflict of interest.') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3d83a38c-15e5-4770-b67d-ee04e425fab9', 'f488aaac-1e91-4f70-8056-bdff4cc58cf4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '18', 'use', 'Arbitration Wycliffe House the administration and performance of non- include the type of cover you seek together with the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('18b6a32f-ddf6-4a54-9b58-fce8baca0ec1', 'f488aaac-1e91-4f70-8056-bdff4cc58cf4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '19', 'other', 'Law and Jurisdiction https://register.fca.org.uk/ or by contacting the FCA the progress of our negotiations.') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('711f5bb7-cfc9-4b99-9eb5-f882ae86f47a', 'f488aaac-1e91-4f70-8056-bdff4cc58cf4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4', 'rent', 'Policy Documentation Where relevant we will remit claims payments to 8 Remuneration (Cont.) 12 Cancellation of this Agreement') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('91a571b9-28aa-4893-940d-3bbc618676f1', 'f488aaac-1e91-4f70-8056-bdff4cc58cf4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '8', 'insurance', 'Remuneration cancelled forthwith, or by insurers giving notice of') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c0b68f1a-8b1a-4f12-a3ed-44708492a1be', 'f488aaac-1e91-4f70-8056-bdff4cc58cf4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5', 'other', 'Claims premium that we collect from you on their behalf. All our remuneration is due at confirmation of order We are covered by the Financial Services') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0feb81e2-d703-463a-846f-360127ede927', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'CIEA]{ING & IIAI]ITENANCE STRATEGY') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5ba49827-e72f-4f8b-b811-6c33e4a94752', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.2', 'other', 'FIRE STRATEGY DRAWIilGS') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2e178329-8523-4aa1-9664-9e24a7552191', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'other', 'EXTERNAL ENVELOPE COMPR!SES') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ad950b3c-759c-4848-ab70-05b05863d3b3', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1.1', 'other', 'Polished blocks and stone banding at ground floor - self-cleaning. Any spray') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b0f324e4-83f8-45cd-ad5a-08404b50bba3', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1.2', 'other', 'Render at ground and first floor - self-cleaning. Any spray graffiti to be removed') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3f6a7524-c93e-4189-8a79-b27855fe8670', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1.4', 'other', 'Windows at first floor - tilt and turn, cleanable from inside.') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ea4b2045-e512-45bc-9f5e-85e9339987a5', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1.5', 'other', 'Louvres at ground and first floor - self-cleaning and periodic cleaning. Any spray') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2ba644bc-e68a-4a26-bae8-e462f36016da', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1.6', 'other', 'Access Ground floor: off pavement') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0281fb67-85b5-46eb-b624-234505006bc8', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1.2', 'other', 'Walls - concrete and fairfaced blockwork. Any spray graffiti to be removed by') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('48778fa1-ce06-487f-a806-c63687a6b3c9', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1.4', 'other', 'Access via ladder - direct off floor for walls.') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0b6d365d-f850-467e-9986-9e2f759e7b4b', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.2', 'assignment', 'STORE, SUBLETS AND STAFF ACCOMMODATION') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('02e6e81b-c90d-477e-a0b8-aa55a40153d5', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.3', 'other', 'SERVICE AREAS, PIPES ETC') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9fa3f05a-91d0-41bb-aecd-0206a7eb4fb9', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'FIR.E STRATEGY STATEiIETIT') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('30d164e0-75be-4fd6-8974-789ef4160665', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'use', 'The proposed development is a mixed use building on a site with frontages to Wilton') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('64cb0369-9cce-48d0-8568-ee43472a0526', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'Statutorv Con siderations') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d3b93083-8b7b-4adc-bd43-7a783e0571af', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'other', 'Compliance wath The Building Regulations 2000') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3621b36f-5ded-4ef7-bd9d-118241dc876a', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.2', 'other', 'FIR.E STRATEGY DRAWIT{GS') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4f593ba8-0abc-4305-b373-d9ae4fc7fb3a', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '9', 'other', 'I r ro e E lw & {t s B @ to - i t! - t c r * u d 8 , 6 6 S rrd I') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d697ea1c-4185-4a06-9e88-b79c8fa36992', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '0', 'other', 'MG (AMCC. Sl ) APRTL 1999') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d90ca2a3-4b51-4c8d-b3b0-1e67878bf229', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '19', 'other', 'KEY PLAN orfmr[tIArlrro. r') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5a1d5af1-b1d6-4217-95b9-dadc54598364', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'E"-E''-tr''-T-''-''-- -''-') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9fd52483-5e69-44dd-91d4-9810b2946599', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '19', 'other', 'KEY PLAN M N H m T r A a I& ,ll P') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e9b6f217-d14c-4dbe-a081-5f9bda08b2d7', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'I 6,F --- w/c mru( r5') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fb958a5b-1f32-4044-a1d9-c2376791d23f', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'N r tr , \ ) t , r ) + 6 I o s{ r e s i lnc r c s t i l u t B l r u c rs l s8 t Y oucT l. s ''- f r,n !9d T ,l T s- {r^L strP! l[trd I t_ r g B r , c u f E U i E t $ l d t I 6 : q U E I I ( A '' E ER U @ E m qE (arcY S E -S c T EY AIfr l l - - l r L - a . l - P i ll9 - O(i -- E I tr ^ - - - - : - - S r G { E E E r o t . { u o * q t r s t t i t r E t f ^ o t f l i [ : h o 0 0 { o r @ 6 o t i $ x t a u t E i ,^ ( a v n t ^ l q t r m c u ( s r q l l r 6 A u tt c & u (s c s D r n r l a t do rFx') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('52c87e13-ba11-455b-b115-4cfd9232ce48', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '14', 'other', 'POIId IO lrr Drrr ffi il J"r:. ,1''l , ,: . D 1 I sl o * l l') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('51c2fb8f-4b6b-4293-b696-2de5eb8049dd', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '150', 'other', 'R(,: I Ltirl.l) AF''PIL ] !9Y') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0e8a6974-e2ec-47cc-a0f8-5240f5acdf9b', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'EYTERI!AL''ilALL T]''PE!,') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a40dc9b4-736c-4871-8cd5-0ccea716f665', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.50', 'other', 'FG rLE(:)t.l ;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('aa9d368a-1582-45fe-a547-4571cf98d2de', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'I ;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('505e53e2-3612-4c01-ac77-f552529e889f', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '025', 'other', 'UNIT 024 uNfr 023 BRICI iAVII VIALL') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b9338343-30f0-4dc9-98ca-d22f085d5860', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5', 'other', 'I - : RtilDtRtt ELOC| tAV|T! WALL') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1fb06df3-9455-48f7-9ea4-7e69e6a5ea67', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '150', 'other', 'Pa. /L[r ]l) APF IL I '']:I:i') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6899ebeb-900b-49d5-a33a-4e1b0b273c2f', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '140', 'other', 'Ir r i lll t l E 1 , r , - lP ! Lltl l 9') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0c73e53d-9ace-43d3-ad7f-bd07883dbaa5', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '9', 'other', 'Fll.{Lli r, ../LLA,.E t,t,.rtt.F,l.,jE|.lT" LTt)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c1922743-7fb7-4075-ada7-0883e65afdc7', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3', 'other', 'M t r c tF t5 5 c t r ! L i t lo x a n F { c^totD aR! T ti c l . a u M r& t. R M s o rr tR F c s u Io r t e r ( s t . r 0 w r r c : 5 ilr r D ir rs -6 rr') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('386f950d-5dd3-409f-96e3-34b666be9a72', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '7650', 'other', 'THI ILUSIVE CAIUEL I lr-------l') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e1294122-782e-4ba7-96da-aae0c229f29a', 'c7e584fe-88dc-44cd-b024-e548e9a86b56', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '7650', 'other', 'THt ILUSIVE CAtvtEL r lr-------r') ON CONFLICT (id) DO NOTHING;

COMMIT;
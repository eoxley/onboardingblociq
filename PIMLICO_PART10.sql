BEGIN;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('198cb214-4f94-4eb0-856a-30559ac5fc88', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d11493ed-9ce7-43ee-9d1a-251c62093781', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1413d216-5d2a-4454-adab-a7a0a0ea4654', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a357b42c-9bf0-4835-8b8e-3ecde054a8ad', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('37de473d-0b37-4bab-a9ad-bb2abdb3f81a', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6000cafc-55a3-4414-9415-88cfd7229c26', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('83d61d9f-ef16-41f1-8a4a-46e64af5d304', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c005b089-7328-4b54-9bfc-a0c7e53e9d3c', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4039438f-e453-4191-92a1-0540623b8f84', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('677ea3fc-4c22-4077-a3b0-55c0c5f6c6e1', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('89a78cce-4641-423b-833c-bc30e67813ea', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a74bb2dc-e878-4168-8eee-549673c4c6e2', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d5924501-4eee-42cc-b3b4-0465a393deae', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a0aed461-fa97-48ad-825f-2a84e9f5f728', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('203bb33d-f960-4db4-ba95-29890a481a17', '37479d30-6e05-4954-a6de-196e070f9db7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5a2991fe-53d5-4535-92e8-bec532af7dfd', '37479d30-6e05-4954-a6de-196e070f9db7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('442075ec-0f8c-4aba-bff6-0c708f6d26e9', '37479d30-6e05-4954-a6de-196e070f9db7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6d3602a1-9b0a-419f-aabf-c9839fce3075', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('64b46b88-94c4-4910-9541-e20dba5645d3', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents/Tenant’s Association') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6e5d4e80-2022-454e-88c7-741ffd640eb5', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b9edf4eb-64e1-4df6-b8ec-1ffeda7fa106', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('45e2843d-28aa-4784-8d9f-f7554501758d', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('28424f94-ed9b-487d-8743-53f268a6f871', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'insurance', 'Who collects the Buildings Insurance Premiums?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5316ab16-3061-4ab7-a5c0-d587070dad4a', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'repair', 'Who maintains the building?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e7ab6d36-885d-4f70-a5b2-01c8ac34d033', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who maintains the Common Parts?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('66ae9d98-7f49-41d6-903a-97051f34a7ec', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c2deef91-d79a-432e-9066-dfe48e7df2d9', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed including £ 100.00 + VAT') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('98734f40-4b87-403c-ba11-263b8ad2f320', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign Required? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0e3ff768-043b-4fed-8abb-c0a468a54d26', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5cc0b9da-fe03-4a69-963b-6b4c3c2436bf', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b2901af2-2487-4885-bbf5-f6658eac3f5f', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7162138d-5577-49a8-9256-f581adff020d', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('03efffdb-cfef-4720-9c27-2f1a7f9996f4', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('96275736-95f4-4558-998c-1b97779ad5da', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a certificate We do not believe this is necessary') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e90a7578-9952-4370-ada2-5b8ac378fab1', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable by this Property? £ 300.00') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3e141299-0876-4372-8add-30ce9f9d95c4', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1647aaef-a51a-462b-8c0a-ab18a3b34f80', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8516548b-574a-4e99-ad01-d616cbd207ec', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: 01/12/2020 To: 28/02/2021') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5cc99bbb-752c-4852-a218-c867de6e0cc9', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'repair', 'How many properties contribute toward the maintenance 79') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('56ad8db1-7c63-47a2-8e6e-44a553d97375', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for this £ 7,236.43') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('af4e3b22-6152-4cd7-95f7-230041751afc', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Are the Service Charges paid up to date for this Property? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1ca73a97-b0e4-43e9-a826-48e7468aad24', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6577dee8-4ee3-4a04-a330-bd598aaefd46', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any Excess Payment anticipated for this property at the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('37dc1bb5-6a42-41b9-bea9-f38b1b015f33', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details: We are unable to confirm at this time.') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e45a18a3-99e5-45d6-811a-3e28202c3f8d', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: 01/12/2020 To: 28/02/2021') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('47f4a1d1-f17b-4f18-ac8e-8e86ebec66e4', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('70e486a8-4d15-4058-b2bd-a15bd04862fc', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('44bdac6f-1594-4884-b86d-b67e676dbd5c', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to this Development? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fbb0cfa3-5c30-438e-aab9-8f60c02e65a0', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If yes, confirm the amount collected from lessees £ 295,962.53') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('74de32d9-3d33-403f-87e5-77228127443b', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8dbf9261-c8e5-41b6-9e64-cd0b12216b4d', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2.1', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('33a0df1a-9e7c-4459-bab4-46dd9c4c2bcb', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Common Parts were last Internally Date: 2004') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d002f893-dc8a-4ff8-918b-f7d47dd56841', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are there any section 20 Completed but unpaid?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1226c498-4288-4f20-9212-5a9fdc6dbec1', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2cd30b79-bf97-41cb-82ca-7f51790de6ef', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('35fad212-e8c4-47ec-be06-d790e97da6d7', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details: It is not expected but we cannot confirm this') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fc30954a-c208-4bdf-9dd9-665cbd6148e2', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('96c64a90-6c41-4af7-8575-ca72f5dc398e', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('63677db5-24d4-482b-9214-b78c41fea3f6', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.1', 'insurance', 'Are the buildings insurance premium contributions paid up Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('17e66563-c3b8-45ce-a57e-6b9d50ee2f07', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.1.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b1c78134-b8a4-43af-ba35-a3fae747b16d', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.2', 'other', 'What period is covered by the last demand? From: 01/04/2020 To: 31/03/2021') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('744d26ac-ac51-4c74-ad35-15d6c6ebe4e1', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.3', 'other', 'Confirm that the premium has been paid in full: Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('60a43b84-e1c6-47e2-9e83-3c18ee99806b', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.3.1', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7a51f0bc-2f7d-41c4-8b34-27cdae3da64b', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.4', 'other', 'Are the interests of Lessees and Mortgagees Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('71fb1934-4142-4858-a5e8-bbea0cba720b', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.5', 'other', 'Are the Common Parts covered by the policy? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0c9f23f8-1610-4bc1-a038-7853769cdc34', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.5.2', 'insurance', 'If No to either of the above, has the insurer been made Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d3269ccb-b0fb-41af-b8e0-e9456772d39b', 'cbd35f61-ad12-4295-8f87-caaf233252af', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.1', 'forfeiture', 'Are there any on-going forfeiture proceedings in relation to Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('65f10444-44ed-4479-b9a9-1da9660d9109', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('efbb57f0-8a17-4416-ab05-6ce1fe83005f', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8b2f9f40-9781-4d5a-8c0e-e2500fd68982', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2285810d-7457-41ad-b642-3ca8b71953f1', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3ac02c04-4123-4432-8276-6845d58ca996', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7d120dc0-70c6-4c58-a6bf-d8e1e1f9a486', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5128b28f-ae88-40a3-94d7-dae9bf0f7dd1', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e3de7745-12eb-46a5-9cff-a81521548703', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bba9c6c4-71bf-42df-8fc2-ce2911d5cf9a', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8e14cb72-1bda-4128-97cf-63ece7de8b37', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a8cfac26-f0ae-40f9-8567-410e2ad6af54', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e0dedba2-4c98-4f52-8925-b62b1a50ebbd', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4ddef568-0899-4878-a2e5-f2a924941db9', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('354188e0-6f76-4f91-8261-1aded16eff7c', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b76544d7-627e-4059-8961-ec35d5a78bfe', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d335c343-59de-440c-9f2d-388ef5f30b1f', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ab71721d-8325-47f3-a818-80f8ba542a2f', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4b8ade42-05a6-4e74-9216-f91e99c3370c', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('79b11343-7de5-4a34-b47b-e85dd5088333', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8ae8f6f7-64d8-447e-9f39-dee3be7ebb02', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('aa8f502b-2eb2-4670-96e1-627224c4b2d5', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8c4c48b8-22a8-47b4-a3c9-5b264ed5f844', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7c07119d-ca5d-4f5a-869d-3cb1628f72c1', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1ac2b821-d879-4c86-a18a-4065dfc77c52', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('edb415ae-071d-4056-b6f1-4abfd79f2f53', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('63c37717-4dd6-4387-938e-a6228c528d5c', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d25425d1-d5b2-4f98-aa6f-e91e419ced16', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('48dad4c6-7f0a-4c9b-9670-c5f9ef80a82c', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c593eb2f-4eb4-4866-b31c-95f5a1f88f96', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f25a339b-94da-482c-b83e-85a009ba725b', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('416f65dc-6603-4072-8685-7d78191709c8', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9d1c7c18-a281-4585-a7ac-6db260259a67', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ffa67c7b-26b1-4d6f-a2ff-d64393295417', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('681f7d5d-a327-47dc-8ec8-8e6d6a443711', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('775ddc27-4b07-43b9-ad90-26b4a5d993ee', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d872e576-8099-4ded-84ae-85601f1ff313', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a79ce4d5-6d3a-48c2-872b-18a6c09a9c96', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('121ac246-753a-4793-8263-7ddcbea5642b', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2c579686-6e88-4a85-bf3e-8ecd027fa908', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a8f32f43-41df-4e15-8515-5598db3d0dee', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('90aa1293-5c50-42f4-80ce-75c2c774b56f', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('41027b84-cf0d-493f-b6dc-1a5e02c897a7', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('632e4753-2bce-4c73-aace-378c816daa58', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f9dd1d56-f027-4d98-af30-0189bbe71228', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b55e54af-95c9-4447-90d1-3ed4608cca8e', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c2eef0af-26c1-4bc3-83f2-fc40ab1fb11f', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('25867941-7629-4444-9a5e-bf549187ba71', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.1', 'insurance', 'Are the buildings insurance premium contributions paid up Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8dcf34dd-6f5f-4e22-8119-fe681e7fa517', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.1.1', 'other', 'If No, provide details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4a9d360a-e02d-4ce4-9c82-39adc69a653a', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.2', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7d31f5d9-b531-4b13-8d41-436813523414', 'b60ba754-2094-4a12-a81e-d5c2652f1604', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.3', 'other', 'Has the premium been paid in full? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3adb3acc-8f8a-4550-8d68-fcd44b6fb344', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d95be375-8972-4c29-a264-689931595a58', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents/Tenant’s Association') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('338ee746-bea9-439e-a7d6-16a17f2ae243', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('10481e15-c205-4bee-a376-99fb8d45b7ec', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7ebf9a47-d0a6-4feb-a550-3e9dd09f7fc7', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('057a888b-4847-433f-b52b-82a5da938eba', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'insurance', 'Who collects the Buildings Insurance Premiums?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('37422b5d-a242-4512-87f9-3a9f59049d40', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'repair', 'Who maintains the building?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5b30f933-2334-444a-b522-1a9d178b2ddf', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who maintains the Common Parts?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4811b90b-62c0-4dc4-b26c-a9e5b897e0d6', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('02aebd75-6085-41d9-9f12-34d54e9661d7', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed including £ 100.00 + VAT') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0cd954ce-4e39-49bf-b42f-bb0981be322d', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign Required? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('51dfa28f-0716-4ecc-903d-92033b5bb74d', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ac571d00-e39c-4df1-8ba5-211189c80f9b', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cb973ff5-dc04-4c0f-ac5c-3e88820f90a3', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d0ac4f04-af4b-4451-999f-e6b2312ce21a', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('51b11a4e-2c2c-446d-8e38-afc45ab59eda', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('885a88df-2253-480b-9f00-bda4c05c77cb', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a certificate We do not believe this is necessary') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('59d3c871-b961-446a-9b4d-7f28c065a991', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable by this Property? £ 250.00') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0c79145f-3399-40cf-b23b-add8e2fbec25', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f4506fc7-8b73-4b79-a901-aa4703059044', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('19415f68-5a27-4a3d-b7df-042f7951278c', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: 01/12/2020 To: 28/02/2021') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('235a3311-7d81-4627-884a-09ba6ec7abd8', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'repair', 'How many properties contribute toward the maintenance 79') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cdded949-2478-4da2-baea-1a94814dbf1e', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for this £ 3,766.12') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e8dbedae-594c-4131-adbb-767153b7ac31', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Are the Service Charges paid up to date for this Property? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('805c078c-e679-4845-9ac4-4f1cba5c833f', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c39a6b97-3a74-4343-bd40-1fa15bb44717', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any Excess Payment anticipated for this property at the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5ff2910b-970a-41ec-975e-020f08c5262d', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details: We are unable to confirm at this time.') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('baf3af87-a364-4e11-828f-aac0d456a363', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: 01/12/2020 To: 28/02/2021') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8fc3b698-af19-40ed-aad6-27c5f5416ce6', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('323fd4b3-a06f-4faa-90cc-4ce19855c93b', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('39b6f290-ce6e-4974-b14b-cb08b2835750', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to this Development? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('398198ca-95c3-44a1-bdb5-f8ed7abc5e7f', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If yes, confirm the amount collected from lessees £ 295,962.53') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bc6b65f7-1a20-4d57-99f6-01a5f7efda5e', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;

COMMIT;
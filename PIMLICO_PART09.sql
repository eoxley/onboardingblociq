BEGIN;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3d7cafa9-a202-4435-9473-7f91f958e8ef', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4a19a107-6e60-4146-bc16-63bda32c3522', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('529ddb2e-34f7-4d33-bb3a-2d72c6add1ba', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4dfa501c-15dd-47d2-99c2-4fcad40559eb', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a48cb0ba-26ab-4629-9a5c-8163ff9e5642', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3e904945-26c2-4beb-8eee-0fbcbb0540a6', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bb8e959c-fc03-479e-a2df-1fbadca5c01f', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('aeb1bf3c-8ee9-4f7d-85cd-06a115750c25', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7363937d-96cc-40f3-8516-73dabf6c8247', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c72e0b5e-78d0-48dc-813f-33e90f333ade', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6d555c68-ad47-411c-847f-cda811677108', '5e103ab3-7aba-4464-8fe6-2f74cc59b0ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c1d464f1-88b8-45d0-9475-aa489a57cb3b', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5f001392-04af-423c-8e38-5823287a5eaa', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b133b268-affd-442c-8421-526ecbf0c861', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Legal Representative of one of the above') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f9696ee6-41c7-43c2-8c91-ae30420b2ab3', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bc2c9d74-0bd6-41e3-90c3-a37c05c8b3df', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3bcabb5d-7451-4d4b-84f7-ebcac59af0ce', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2d369c6d-b361-421c-94fe-36fb1f6039e1', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f860d2f4-9f78-45ba-af9b-fe8a6d112f23', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d2fd4733-ecb7-4e0e-922a-7a18d1d001c3', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a6866689-3c6c-414c-bcfd-9272f7c59fd2', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3fd2db86-68c6-4664-a765-994e86776492', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('35e5c520-a14c-476f-8c3e-6ad3ddcfa160', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('45bdbd8e-5270-4ab4-a716-ba86c102c061', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e46631b9-1958-4101-88b1-461042736c4d', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b73bf17d-1380-4e12-a1d4-c234e9be64f9', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('19768c2f-f7f3-4c86-8ccb-737aec84fe1d', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9c0b7d2e-a325-4dda-bca3-719ddae63ef5', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a9d66719-1607-4384-ad27-d1d0eb8b2b1b', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8c1fb7a9-927c-4e94-9db7-22cdd598855c', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9daaf1c5-ccae-48bc-96a1-f2fc5b31f2ae', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('055d5775-3ec5-462b-be01-256ad9aa06ac', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('adc4105f-e92e-4f26-b07e-0b937d47255f', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('dc400306-dd5f-4131-9bc8-86736e3dca42', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('898faf49-20d4-4f84-b178-44a610b75a77', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('142254fd-a2ea-478f-9d0b-b071bcd2466a', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4c9feee3-4f63-4e71-a5d9-cf8b370e2a7f', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b297aa4e-4ecb-45c1-af68-9e45d5c14eb4', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.2', 'service_charge', 'If the Service Charge has been collected on an') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('65041ee9-f17c-4e17-a4bd-8ff7f0175fe9', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('74b99e10-05cc-4a71-a0f3-e4acb201eecc', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('78b15bc4-8eee-4fd7-91b4-d0b0550cdb37', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bd1a4820-5daf-45dd-b5ce-759db4d75e93', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('37d96605-78e3-4989-9925-54cd717d49dd', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('50add190-7409-47ba-b142-20c7d3941ad8', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('00f38f1d-9aa5-43f8-b8d6-6cd62a43b1df', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8cba9d8a-aceb-41f0-b68c-1551a9061dce', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cfd241be-3d2d-4c9b-ae4d-932801de3d45', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('44578035-b5a4-4f0d-bdb0-069f94ea1732', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fa20261b-e427-4490-a7a5-5f82119cae4e', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a6ae9503-241e-4fb1-8604-a2ff2ac085df', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f0c96fbc-38c2-4d93-be7d-b14d861eab1e', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('63b550e3-84f6-4477-81e5-d1fe31bc56a9', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9beda427-a677-4d99-ad41-f5cca08eafc2', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9bf665ef-1499-4fc3-b853-3fd4a5d58f70', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('86531482-b9bb-4c9d-bf99-d448f874f00f', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bb42092e-52fb-4324-8a8c-29ec4d1b69d4', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d95d3831-b9d7-4868-a62d-b124117f98e4', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ba07d0b2-454e-4c58-ac8b-963b56a39c95', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c8f31030-28f2-46b1-a874-76d9eaf367b0', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8ce7f678-1aa7-4022-b6b0-73d0b70adec4', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cbd134a8-7686-49dd-858e-6dfd19453d60', '28b89e16-5789-4387-ba4a-e815008ec4a2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3e6714ec-2fed-43a5-be5a-7ba00b99cfe7', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('77e9c91e-d6b0-4bf1-9fc9-29bbcb5640b3', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('79f28b13-9010-4f08-b465-084d0d62a706', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Legal Representative of one of the above') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('28d56b08-b2f0-4ef5-a4b3-e5162b033fda', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('625bf9e0-1a93-4350-8415-8cbeb118d0a8', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1b4b343f-cee2-4d63-926e-21cc3f754c53', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7976087b-8db0-4279-8312-065eed4ef1ae', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9b47f0d0-9ae8-4ac7-bf16-8b8308a4c151', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bbfee56d-ef7e-460b-8092-e15efb013feb', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('61eaf9b0-a963-40af-9c75-acc8bedbbfe5', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8bad2151-4535-4989-8387-1233187c9447', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('192c7ec4-0aa0-4d29-b6c6-268adf0bff3c', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('37f66524-e66f-4963-8782-c512b85062ad', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7a013a24-89b7-472d-b32a-4c48ab237578', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b63152fe-9b16-4aa5-9ac9-851e80bee336', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('305d9c08-e1e0-4782-9cfa-dbf19909b9fe', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('58383028-16cb-4117-837e-d9b0bc29475c', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e8a1c0b2-39cb-47dd-9be0-64b3b963ea37', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ccbeac41-75e1-48f0-953d-7a5d698279b9', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0aa813a3-9f06-4e7f-82b4-998484ebd6e1', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9498963b-2d83-4e16-953f-08721577f256', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('20f55e4a-8f4f-40a7-93e5-0fbd2e62419e', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e6b74162-61f5-4d78-af77-d76603dcaa9a', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4ee5b617-2b47-4ce9-8013-fa85ae26fa6c', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bd28ee14-81fe-4a3f-a9f6-83cafc8b8613', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('aa4264b9-13e0-4592-990c-71215b21fc2d', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('33810439-e9f5-485a-8a84-62ff0eaf1d03', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.2', 'service_charge', 'If the Service Charge has been collected on an') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6d258499-8f15-4bf9-88de-e7c71ce25ea3', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('25bd00d7-83a8-49ae-8a43-fc1227982d50', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('661f2ecf-b554-4a2c-9f11-1f605b855b9b', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b41c82cb-99ee-4e57-a3d3-827887fce651', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fe3ecdfb-fcbf-41e0-95dd-ae96c8fb261a', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4d383537-af2f-45ed-89cc-2d9193801636', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b87450c8-c327-4765-9acc-74f1751f6a52', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('79b02ea2-3935-47b8-993f-61f8777cbe2f', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('553043a4-0c96-4d2e-9845-52519a49d3d9', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9eb37f84-156c-480f-8e54-f339f45f751e', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6c15334e-2e6b-407e-9102-a47844dcda2a', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d7fb4bbc-5d8c-4081-954a-917fd2916e36', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4b3d0286-ee11-4b06-91df-d6e5b991379c', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('83f63208-ff27-4347-96f1-4d8db0c8507e', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('842907c8-7217-47cc-9b20-8245eaa03258', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cfbca6ba-bd86-4d9d-838a-f831b8512f83', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7197831b-4024-4924-a28b-354f0c7f6907', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7e3c1f83-c62f-4110-ba24-15fc3657e589', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('63893f7c-e9fa-4406-9917-1b48f97f1711', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('155f7dcb-57d9-4731-b130-962a01cd393a', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7fa84514-1abf-4a25-b3f5-f9b76d5c5c3d', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0cf14347-67d2-4154-ad9e-4a555f8ff930', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('76cd42dc-a168-479d-ac42-3b9a15edd3a6', '707b72ac-d80b-48dd-847d-40be9028c6e8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('31e43b4d-4f62-40a5-a004-0b6633aa4a6b', '1135da03-0ea0-472c-83fe-707a82efde88', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e3ea1d21-60ea-4fd9-ab1e-8b3c2fb24767', '1135da03-0ea0-472c-83fe-707a82efde88', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6e59cb73-b7c5-4313-91f2-e02f6dbbee80', '1135da03-0ea0-472c-83fe-707a82efde88', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ea845b96-4334-4aaf-836b-95e82aea095c', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('82785b82-888a-4649-ba15-2a1c989997e1', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c9dc4b30-5bcb-4f02-b846-5d5d7c09c845', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Legal Representative of one of the above') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d98ea4c6-94a5-4fbb-b713-4b60f6ff474f', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ab332595-20d2-498f-8f01-9aed9bac049e', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a092e982-88a8-4a5c-85ef-3c2268f954c3', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8600f5c1-2551-42a0-a9a6-77cc1dc221c1', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ba7fd66a-29e6-4e49-b2c8-9726e934223c', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1b19bd3c-33ca-47f7-92f7-fb1ad2be3d71', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cfbe4ec6-ce4a-413c-92de-e3cd86ac7e37', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9b77a919-b980-4e89-9a7d-17eb8f19477f', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('56982915-cdea-4096-9477-dfd334ac3237', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9eb31175-2701-4c62-9b88-26958f105ae2', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b1e4f6ef-a81e-4783-b9e6-85ce103428d4', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('aa713b2e-b478-4bd8-a078-cf453da3494c', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('307b47ce-2e68-47d0-a7a1-ca6bd103de86', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b75d80c2-363c-4d22-9d3a-af106f254dd7', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('05619574-587a-42af-b7f3-46cd4be95ca5', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3edc8225-df1b-4c82-a914-400b48eae35a', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0ff5a7e4-5164-4d48-a093-084b1b64ff49', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f42a2a91-f1b6-4f1e-beb1-6bac526bfeec', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1a7a422a-42a2-41a3-a674-4775c9b635a2', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f48107dd-d31e-47c7-a13c-42da22fa7e17', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('49faec40-a177-456e-9a03-6058ff314c86', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c6c04aa5-0669-4415-9ea1-7d0eb8c46a89', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('40e15aeb-346b-43a9-8fae-5519a2698fc7', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3f2f9efd-2745-44cd-af53-3abe4861c4a2', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.2', 'service_charge', 'If the Service Charge has been collected on an') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('834cd014-75f0-40d1-baf9-8d66de90e129', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('679e2e82-db66-468e-ba2f-3d9629dba7d9', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e2aad7df-a384-4d95-a542-5dd4aea34533', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b8b9916f-5c05-46c2-a918-3c352b1d219a', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('41f167e6-a70c-4477-94df-7dd5acafcbe3', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2b8b839d-f864-4d32-a4a9-d98498ac598c', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c960ba66-9855-4085-9521-70c8c710002d', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('aecfb5b2-bf04-4847-957c-c598708488a2', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b73765f8-e984-4705-99da-31d95b03d4c2', '0cbc2764-74dc-47f2-80f9-62065e4d9582', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;

COMMIT;
BEGIN;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d95f4d35-9db4-4f39-8e08-57815e626ca1', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b16c714e-a36a-4a3f-a712-1726c7cbb2fa', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('82d95cbb-0a73-49a9-91fc-a5ed089c876d', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bd243ddf-7f4f-435e-81ba-eab510b05c31', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('27aa1538-0ceb-4ad0-ab4f-b9f2458bf4a5', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8ee8e8c6-33fa-45ac-a3a8-c194e267e2d0', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d858a4d4-99fb-42d1-bfab-fdd84262076b', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ae76a898-82b8-4221-8ef2-a4a0ba9c9600', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1a0efb1a-3624-49fa-aa75-9f44a065040f', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1e8e5743-5778-4e48-961f-80ab93a1b397', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7d62694d-8051-4d91-9a1f-4cd3cfd4f261', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('27dfc1c3-fbb4-4d33-a15e-cc3f0f703e27', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('244c5ca3-2206-41d0-bedf-2c5c19375a0c', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f4550cbe-538c-4c26-9295-d1daa1cb90a1', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('910b5d95-e9cb-4bea-a0d2-dada3497470f', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3ddca7f8-b65d-4906-85fb-28c1f9a8c918', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5377e617-bfdc-40e5-9dc2-d455f8087702', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fb259463-d45d-4fc9-893a-b576df5ba5f2', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9c9ad3af-a45d-405b-965c-44cce4ac9f4d', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fa207a41-cea7-4005-9f10-e56daee1c4d4', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c5e07459-d34f-4202-8f0b-98d66b8ab965', '7dfde090-a3dd-45af-8d7d-470c3b9d32b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fe4f162a-bcdb-4b50-a490-ba6487f3a04a', '13d64559-b75d-4e9e-a822-07b1e427bcf6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'ACCOUNTANTS REPORT OF FACTUAL FINDINGS TO THE LANDLORD OF PIMLICO PLACE FOR THE YEAR ENDED 31') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('af1bc5ed-399f-4159-bbba-04fb9fdfb1d8', '13d64559-b75d-4e9e-a822-07b1e427bcf6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Accounting convention') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b06a54b9-fd84-4239-b59f-85a241f59326', '13d64559-b75d-4e9e-a822-07b1e427bcf6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'service_charge', 'Service Charge Income') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a468ec69-8f58-4c64-be6b-eef8b6f9eb32', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('27dd17cf-ea55-4376-81af-93634757fbcf', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c26aec40-236c-465b-9d4b-8e6c9a3abb4e', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Legal Representative of one of the above') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('da6c635c-436d-40a5-9012-b249c759bf6c', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0106f7d6-8409-4e19-9f49-d2b0b4c87553', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9ed83e97-41a2-4fac-a76d-cb730dface1b', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9950d4ba-d580-428e-bbdf-ca64ebc1e380', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d11ed4be-5733-4379-b983-33b0bcb676d4', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a178ce98-b801-4ea8-8330-5321e93ae574', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('33064cdb-9077-4a14-95c7-bc9b8e36f0a8', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5ff35c9a-797a-4723-8e98-74977f60e04c', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('22641833-71ed-483b-871e-e91201bb231e', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4859b2e0-b761-4f57-8e07-79767ee16a3e', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('80b0bae9-6e1b-4377-87b9-c5b538ddc615', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('00a9414e-8c8d-470d-aea9-bd4fe3aaa6e2', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5056a4ae-c917-422d-a1e2-7685b2d49d7d', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('92089f64-ae9b-4c9c-a387-f6a4e1e5fc16', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0d72cbd8-d5e4-4d8a-b20e-816d683f0041', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8c5c74df-e748-4c6c-8cff-347a31b99d06', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a8d04663-d3c1-42a7-855f-1ddb1113d6df', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bb542b67-5590-4cac-8d12-299daeccc97a', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d6f50aad-48af-457b-ae85-6dd5b1e4f689', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7ce47f39-491b-49b8-aac9-88564cd007e6', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('89a0b827-d203-48d4-bfb3-34862c5e10e8', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('99d76852-60ad-4d23-b2f0-97bb05c897f1', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bd4ae95d-e80f-42ac-8eb4-564ecc35cf5c', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a66b2bd6-93be-489e-96a3-7e52c8599f48', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.2', 'service_charge', 'If the Service Charge has been collected on an') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2c97f11c-b1c6-4234-90f0-457abfcf45c7', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b778fec0-1c8d-496c-b2f3-61d8ed562937', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4eeeb4db-625a-44fa-947f-670fea059a77', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('79afeef2-7225-461b-9684-309f867c92b9', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('be112a09-bce4-4e3b-b69f-ad8d78121d15', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('31f80654-45ed-4ac3-a366-eab7bd6dcf71', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e679c81b-2fe8-4edd-9316-46bb276a3f52', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b5f9f96b-b642-4a5e-9b27-d91bc1f98aed', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('02b8474e-1747-4db9-9f30-31f50bdd2aef', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('64bc8ce8-cc95-49bb-8b4d-af557a4c434b', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('027c1b8d-9730-4c62-89e0-80254f794875', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('23b21945-5ac3-4aa4-9ff7-ad067f2903f2', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e43d07db-177a-4ba5-87c1-d0233eca1253', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f01fcafc-afa6-4b34-8b32-6af21d81e21e', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1544316e-26a0-43e4-9522-5027d02fe8f1', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5e4f347f-3705-4ebb-9d0f-e26c3c656e6a', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1af1d9c7-301d-4d8f-ba2c-ee58c8ef0ddd', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('dbc9169a-1387-41d7-9645-d010a73920da', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('eb960827-8e65-4309-b294-2c913c0fb8ef', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('335d0fa9-9071-4870-9ae8-a7b31dbcce5e', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8c5ccef0-0ba1-4364-883e-6a6c46296672', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('148fde85-7438-4b9b-b4a4-c9d2020b5309', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('452c01ca-1d4f-4b23-808a-a94323288115', '80709e59-bfc4-4d10-8ef8-fcfc355a2225', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('07886075-e1fc-4362-ba64-6a5dbc336192', 'e1401690-ba1c-444b-9010-01d96ef1222f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '90274', 'other', 'Dated this 12 day of August 2024') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ec2ebf94-91cd-4b2f-bf31-124bea34da2b', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3eac9485-239c-4fe8-a0b3-dde64947eb54', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('af462141-86d0-4914-8c2c-ebfde42bc592', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Legal Representative of one of the above') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3626d752-86bd-418c-af69-48f5e5f617da', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('dff634ed-91b9-4f9e-a780-be892085df59', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b4ad813b-8863-4470-8df8-90b4f5a56167', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a5771e21-b78a-4e96-9466-933b54737fa7', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fd8ffdfa-1bc5-4c57-9d98-6e02e1726177', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ca9fb9f2-432c-4640-ac39-054819621168', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c1e2829c-2edf-4583-89f1-eb5f0b3fc92a', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b3d70030-199c-4af8-87be-342da71c23ed', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('04daeb79-32da-4c1f-8a73-64c2f3d4527d', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e0dc14ae-3579-4f0a-9ba9-d2d33c0e6b34', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8497c284-27d5-42e3-871f-4ea6316dba9f', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cfe42e57-36da-4c35-8486-c1177b3e3ee4', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('86313aa3-1a87-44f3-9c8b-f8cebb1e41f3', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7d66403e-ef56-48e2-a6f5-4b098836ff7a', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('55eb300e-cf19-48cb-afeb-5c771e31c59d', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('722a9167-5f61-4b42-a7be-7e7282c1daea', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e6a5276f-265f-41e6-82f0-ffc9fdc65663', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('66c0fcb9-c28b-4c4c-955e-29a80d1b1e75', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5ae32b53-8611-4f8d-827b-6f16a02e7d4f', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ef7c352c-2e66-4f4b-bef9-d738944e2fd5', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3e361ccb-e641-4f2f-aa3d-e1bd265a8085', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0add434b-b744-4cd1-bed2-3a5639ad6505', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('59f73636-91aa-4709-b444-c7e7e18f8d0b', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.1', 'rent', 'What is the current annual Service Charge for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d0b09e85-ee78-4410-b265-a2ec269e60ae', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1.2', 'service_charge', 'If the Service Charge has been collected on an') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0ece981d-d504-465b-b254-0802d481f328', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'service_charge', 'Is the Service Charge paid up to date for the Property? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0461f3db-f24e-40b2-88ba-9c56ef7add68', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7eac3db0-c69d-4421-b577-1b0b11eff3b5', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'rent', 'Is any excess payment anticipated for the Property at the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b94820d5-92ca-4184-9a9c-aeb6b09faac1', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a1d8c62d-8d38-421e-aec8-1c41795e0d62', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.4', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('cd5a11cf-6a21-43c7-8984-d11809afb3a7', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5', 'other', 'In the last 12 months, has any inability to collect') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('42f3314c-84fd-4bca-b3ce-6714a2dc6482', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.5.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('10f34660-65ba-47af-a80e-52ad5efd00b0', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6', 'other', 'Does a Reserve Fund apply to the Managed Area? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8f7d73c8-1ed3-4136-a9e2-3d1bf219a8a3', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.1', 'other', 'If Yes, confirm the amount collected from Lessees £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1ee86914-44bc-4eb7-89c4-050c49673564', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2', 'other', 'Is the amount expected to be sufficient to cover the Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('05830da5-8b76-4e2b-a738-9c5ca60868c8', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.3', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('df46a4b3-ebfe-4a21-81e0-dadd2de451db', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Managed Areas were last Internally Date: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('276e3ca9-7132-40d5-9717-659599389cbe', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are any Section 20 completed but unpaid') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('06041480-cba7-490a-b300-edcc4ae91aa9', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('16e9f1ba-c361-436a-b717-3582acf3adf9', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('29b39693-34a3-4aec-9636-68c70e1405d5', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('85887368-6154-4b5d-9f0e-669670dc1d22', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8428744d-fbf7-4d51-a937-c14c90977f5b', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3271ccf4-994a-464d-85f6-a70b8588cff5', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11', 'other', 'Are the Managed Areas known to be affected by Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('de0c3ae4-0d39-4a66-ad01-fe216579df1e', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.11.1', 'other', 'If Yes, provide details and a copy of any Japanese') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('413ba6fc-a176-4778-bd2f-bca964e64e3a', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12', 'other', 'Are there any: Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('68f45d53-66fd-4f92-b227-27f343762a46', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.12.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b428e7f3-c570-48c9-afff-e1e8f0f44348', 'a2376f82-a304-4d6e-b3bf-549e9cb5bd55', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.13', 'other', 'Do all properties in the Managed Area contribute to Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2dec808a-7b82-46c0-9b91-dee1a0d6797d', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1', 'other', 'Landlord 1.2 Management Company') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('44591ff6-f6e3-47bf-a027-1b4b234effa2', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.3', 'other', 'Managing Agent 1.4 Residents''/Tenants'' Association') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7e0bacaf-4a48-4a86-a3a4-d6a0bc15da22', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.5', 'other', 'Legal Representative of one of the above') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0aab4370-85b9-448c-b457-e908fcf915c7', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.6', 'assignment', 'Who accepts service of the Notice of Assignment & Landlord £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('52bcc6db-952e-404d-86d9-c5023da0873d', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.7', 'rent', 'Who collects the Ground Rent?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('81a4981c-913e-44af-94bc-f37177c77f9c', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.8', 'service_charge', 'Who collects the Service Charges?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ec7f6dd2-3469-40ce-a469-7f331f58d47c', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.9', 'insurance', 'Who collects the building insurance premiums?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0f279875-510c-4d27-a81b-1431fbaaf3b7', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.10', 'repair', 'Who deals with the day to day maintenance of the building?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('984bf753-dea2-46ff-87eb-7916faf4ab99', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.11', 'repair', 'Who deals with the day to day maintenance of the Managed Area?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5989c068-ead5-4f3c-a16a-a28e476af3cb', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.12', 'insurance', 'Who organises and administers the buildings insurance?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('781ee86d-7f51-4d7b-a2f9-7fe75b816247', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'covenant', 'Is a Deed of Covenant required? Yes No Not Known') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('840d63d8-c39c-458a-b9f5-2a29e015eab5', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.1', 'other', 'If Yes, confirm the costs applicable to the Deed £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a147be8d-33de-4168-9176-93ed16cdfd72', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1.2', 'other', 'Provide details of the person who deals with the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('94fab20c-41da-478c-aafa-e2ed49850f2d', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.2', 'other', 'Is a Licence to Assign required? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0955c4c1-bbf0-437c-977f-0faf1caea5a5', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3', 'other', 'If Yes, specify requirements e.g. references, and') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('02da1a8b-76ee-44c2-ae59-0ba01d726c5c', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4', 'other', 'Are you aware of consent having been given to any Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5984c246-b7b5-48ef-a68c-ca8186ce61a5', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1', 'other', 'If Yes, provide details and copies of any consent:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e224fbc7-65f8-47f7-89c6-a4b4fb7ea5de', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5', 'other', 'Is the incoming Lessee required to take a share in, or Yes No N/A') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f7bb70b3-0600-4431-b2b6-341bd5db2f69', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1', 'other', 'If Yes, provide details of the procedure and fees:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('626eb7f1-ceb7-44ce-be6a-71edce2a7a6b', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.6', 'other', 'What is the procedure and cost for obtaining a') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('fa7ca497-ae0e-4bad-8539-a561041dc6a1', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.1', 'rent', 'What is the annual Ground Rent payable for the £') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('36ae0cf1-56e3-44ae-b18d-a10af6bed30e', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2', 'rent', 'Is the Ground Rent paid up to date? Yes No N/A ground rent') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('53649717-cf0e-41be-b108-5373c29dc3da', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.2.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c85def6d-d1db-44ab-9652-f377f51f369a', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3.3', 'other', 'What period is covered by the last demand? From: / / To: / /') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9c2cf3c9-2a52-4992-b49b-a1ebbdc2a943', '6c73b874-3132-4c22-abc0-0fdfe1ff2372', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'How many properties contribute toward the') ON CONFLICT (id) DO NOTHING;

COMMIT;
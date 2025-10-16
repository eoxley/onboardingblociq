BEGIN;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f0278825-6a74-42b4-ac24-7bdb0ff0372d', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.6.2.1', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f56a2379-a1f5-4676-9e62-29e7dad0167c', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.7', 'other', 'Confirm the date when the Common Parts were last Internally Date: 2004') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ad98cbab-e25f-42c3-8bd2-a20a85247b87', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8', 'other', 'Within the next 2 years, are there any section 20 Completed but unpaid?') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5771c4cd-573a-4d22-99e8-302a6d84bf1e', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.8.1', 'other', 'If so, provide details of the works and the contribution') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5c29c3b9-1556-4b1d-a4e8-ede9b5697c67', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9', 'service_charge', 'Is any increase in the Service Charge over 10% or £100, Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1cbc4422-6d13-464b-a906-fb5332149193', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.9.1', 'other', 'If Yes, provide details: It is not expected but we cannot confirm this') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6115f9b8-96a3-41e6-8eb6-7d3f331074d8', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10', 'service_charge', 'Are there any outstanding Service Charge consultation Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3545f8a3-82e1-4814-84c8-ff1eb5a5f1ad', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.10.1', 'other', 'If Yes, provide details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('492076f1-7f3e-4a50-8018-5171400632c9', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.1', 'insurance', 'Are the buildings insurance premium contributions paid up Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3e8eb2de-0a89-464e-8bba-28e3de50414d', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.1.1', 'other', 'If No, supply details of the arrears:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('190a0c82-430a-49da-b76c-4429ad3bb4f2', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.2', 'other', 'What period is covered by the last demand? From: 01/04/2020 To: 31/03/2021') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('833843dc-9f31-4c20-b6dd-9cded5c2d12d', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.3', 'other', 'Confirm that the premium has been paid in full: Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('21e99e86-3b4d-4084-aa17-576ce42a9400', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.3.1', 'other', 'If No, supply details:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('144ed173-3f6f-4fd4-ab5b-5f64fbe51208', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.4', 'other', 'Are the interests of Lessees and Mortgagees Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('afb71f76-9509-4c2b-8c5f-34f1781e3df1', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.5', 'other', 'Are the Common Parts covered by the policy? Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('49e02132-94ba-484a-a766-d3b2e36dd6e3', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.5.2', 'insurance', 'If No to either of the above, has the insurer been made Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7d46a54c-1764-4fa1-b24f-1c209f2cee15', 'c729f953-b92e-4c10-952d-a1ecee9ac607', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.1', 'forfeiture', 'Are there any on-going forfeiture proceedings in relation to Yes No') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9abf74b0-4df4-4a29-abac-35bd3564a095', '05f32b17-81db-4bb4-b26d-d6e6ba47b23e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0aa19752-8169-4ec4-a49b-bd56cff3e91d', '05f32b17-81db-4bb4-b26d-d6e6ba47b23e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('26aff5ea-c049-42c9-8267-e8ec9508c41b', 'ea26d40e-90d0-46bb-9ab8-3c5789c0f527', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN) CILL - T.104.50.12') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('571200db-cedd-4608-b2bb-b36422fe762d', 'ea26d40e-90d0-46bb-9ab8-3c5789c0f527', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8f7a0e39-ba36-4345-9630-7674398cd5ce', 'ea26d40e-90d0-46bb-9ab8-3c5789c0f527', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No 5.5 dia TEKS 2 No ADDITIONAL JAMB FIXINGS(MIN) CILL - T.104.50.15') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('04189c7b-2b6f-4a0e-81f3-d16bc38a0bb3', 'ea26d40e-90d0-46bb-9ab8-3c5789c0f527', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e07577be-0245-4b73-93aa-409cff5626f8', '99c72a38-4062-4236-9475-dabec59c379b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c5a2f55c-6720-443f-8eb3-7553612da2a3', '99c72a38-4062-4236-9475-dabec59c379b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('28bbd288-e61e-487e-87e0-0b2347d97c38', '99c72a38-4062-4236-9475-dabec59c379b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No PFC(125x60) USING 5.5 dia TEK') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('120bdcfc-921b-4149-a4ce-fcceed6000aa', '9af5edeb-c8ec-43f1-a15d-d46b9156a3d2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '154', 'other', 'Putney High Street PO Box 732') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3db6a0be-42d5-40a2-8880-c876db21180e', '9af5edeb-c8ec-43f1-a15d-d46b9156a3d2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'use', 'The development hereby permitted shall be carried out in accordance with the drawings and') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('846ec598-8930-4162-9372-190963e962ae', '9af5edeb-c8ec-43f1-a15d-d46b9156a3d2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'Except for piling, excavation and demolition work, you must carry out any building work which') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5ec24c81-c116-4cb3-9f0d-343d3958a23b', '9af5edeb-c8ec-43f1-a15d-d46b9156a3d2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3', 'other', 'All new work to the outside of the building must match existing original work in terms of the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c3f84dbe-d4ed-449e-9043-b9a7d26f3104', '9af5edeb-c8ec-43f1-a15d-d46b9156a3d2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4', 'other', 'You must apply to us for approval of samples (including photographs alongside existing') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b6704cd6-3c6c-40f3-b9a3-c35a5b059c53', '9af5edeb-c8ec-43f1-a15d-d46b9156a3d2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'In dealing with this application the City Council has implemented the requirement in the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('144cc03f-0781-42b7-a970-307078136562', 'ef72fa4f-ac67-485c-95fc-f53878be7f9e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'This permission fully meets condition(s) 4 of the planning permission dated 19th May 2020') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('147f863d-fe93-450c-9dd2-ff06f8362a89', '77fc649e-f888-4195-b57e-d56ab2b29c83', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'This permission fully meets condition(s) 4 of the planning permission dated 2nd November') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('12212f31-639c-4fe1-8f53-fa221e09e504', '77fc649e-f888-4195-b57e-d56ab2b29c83', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'You applied to discharge condition 3. You are advised that this condition is a ''compliance') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9bf6f28c-c047-423f-af6f-5c02952ce3b5', '7f5e32be-3f8a-4ef1-9a1a-19de3011684b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b82723f8-a0d0-47db-bc97-52d01c485e30', '7f5e32be-3f8a-4ef1-9a1a-19de3011684b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('dd1e4c55-0f96-4ddd-9939-12a75d98ea23', 'e8f96ca9-2eb6-42be-b51f-cdf247cdcf92', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN) CILL - T.104.50.12') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b5777b8d-afe5-4a31-9889-16397dd18e07', 'e8f96ca9-2eb6-42be-b51f-cdf247cdcf92', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6427b7db-c780-45ae-8ed5-7ff043c2575a', 'e8f96ca9-2eb6-42be-b51f-cdf247cdcf92', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No 5.5 dia TEKS 2 No ADDITIONAL JAMB FIXINGS(MIN) CILL - T.104.50.15') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d42d5cd7-bee4-4ac9-98df-4b41fbdc837b', 'e8f96ca9-2eb6-42be-b51f-cdf247cdcf92', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('530daa45-cc69-4f67-9bc7-19aa7e7d64ed', '3ff5283f-5a95-42df-aa4c-b9ff22694033', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('70fbdbc8-6129-4ef1-8037-c816359b121d', '3ff5283f-5a95-42df-aa4c-b9ff22694033', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('84cbc519-a353-4789-8f32-1190e4fa28e9', '3ff5283f-5a95-42df-aa4c-b9ff22694033', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No PFC(125x60) USING 5.5 dia TEK') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1dc48aa6-2b29-451c-af65-fd2a7c8f69cd', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Technical Specification') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('af2d398d-081a-4c93-aba4-6bc9af7df5c5', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.2', 'other', 'Adhesive, basecoat and primer') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3094a5ac-703d-4868-acc6-85a0226d94fd', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.2.1', 'other', 'PermaRock Adhesive and PermaRock Lamella Adhesive are polymer modified cement-based') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c133792f-f821-4316-abda-5ebf5d31a358', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.2.2', 'other', 'PermaRock Bedding Mortar is a polymer modified cement-based powder, requiring only the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('9e824ea9-56fa-4528-a291-5ebd3c55670b', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.2.3', 'use', 'PermaRock K & R Primer is used for priming surfaces before application of acrylic/silicone K') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('47a092b5-e0e5-4d39-84d4-e717ea45786a', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.3.1', 'other', 'PermaRock Mineral Fibre insulation slabs are manufactured and supplied in accordance with') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('01743bb2-65ba-4818-8f15-c8f2f5a18679', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.3.2', 'other', 'PermaRock EPS insulation is manufactured and supplied in accordance with BS EN 13163') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('588df181-8aa2-47bf-83b4-3156afec2db8', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.3.3', 'other', 'A summary of the information provided for each insulation material in terms of product') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b347274a-4fff-4843-8473-8bc32683932d', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.4.1', 'other', 'Cement based decorative finishes:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b8445e06-f4f7-4ac3-a0bd-052544ee8aab', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.4.2', 'other', 'Lime based decorative finish:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0c0a9c05-dd51-485f-82af-77c017e3f5db', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.4.3', 'other', 'Cement-free decorative finishes:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('645ed2ff-2012-4b2e-a01e-afbcc7c74769', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.4.4', 'other', 'Brick slip decorative finish:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5e454b45-4585-409a-b32e-eca9f8aca4c3', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.5', 'other', 'Fixing components for insulation') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('89b7e9ef-9718-4095-bf7f-93020e661808', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.6', 'other', 'Reinforcement materials') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('1c978124-9877-4cc4-adc3-5059ce258bdb', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.7', 'other', 'Ancillary components (outside scope of the certificate)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('784c15e9-63fd-45ec-a3f9-3701801c56a7', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3.3', 'other', 'Insulation and Render (reaction to fire)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('48a61dac-32fa-40e7-9ebc-76b720004791', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3.4', 'other', 'Fire spread on external walls') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4a533829-4293-42ed-be2f-5f8d6965433c', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3.5', 'other', 'Other fire related construction detail requirements') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3253b55b-9d17-405c-86e9-00a5470cc903', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3.5.1', 'other', 'All insulation types - As part of the fire performance requirements one fire resistant') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6224450d-8ffd-49a6-84db-29245271148f', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.3.5.2', 'other', 'Cavities - Where cavities are present, they shall be separated by horizontal and vertical fire') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('142e5a81-72b9-459c-a0ca-d9690427f5e2', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1.1', 'other', 'PEWIRS will provide a weather resistant external wall insulation cladding to new and') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d809a851-9709-4aeb-aa98-552c5ef96e17', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1.2', 'other', 'For timber frame and light gauge steel frame the systems shall comply with the appropriate') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('de849a6d-26af-4d6d-afa1-8b3344d47488', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5950', 'use', 'Structural use of steelwork in building respectively to ensure water penetration') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('44322eb2-52d5-4b48-b118-48f54b9d3154', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.1.3', 'other', 'Where the wind driven rain exposure classification is very severe (refer to BS 5628-3 Code') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3bb7710e-5def-4735-9eec-8220e6f114a1', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.2', 'other', 'Condensation Risk Assessment and Interstitial Condensation') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('df5cfc7f-6372-4073-a122-e21f682574b1', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.2.1', 'use', 'For PEWIRS used for dwellings the project designer shall determine the condensation risk') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5edfac5f-5c5f-42cf-bd07-1555c1c7c480', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.2.2', 'other', 'The condensation risk assessment shall be carried out in accordance with BS EN ISO 13788') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b7e68bc3-1a35-41eb-984d-f812113db605', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.3', 'other', 'Project specific condensation risk assessments are required for dwellings.') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('6091b9b1-930e-45d5-8ac1-a8a6625c1e34', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.3.1', 'other', 'Advice on construction detailing for thermal insulation materials is provided in BRE') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('612a5a49-169c-4218-a4bd-c2b8d8d9129d', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.3.2', 'other', 'Steel and timber framed construction shall be designed to avoid the accumulation of') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ad795ae4-a992-404d-a52f-f9a10ef8bf5d', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.4.3.3', 'other', 'For steel and timber framed construction it is essential that any vapour control layer on the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d2c279b9-7983-4c15-9617-a351ae70ca8e', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1.1', 'other', 'The ultimate wind load to be resisted by the PermaRock Insulation and Render systems has') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('08255545-85a6-40b8-8c8a-83d876f149f2', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.1.2', 'other', 'The performance of the PermaRock Mineral Fibre system using the dynamic wind uplift test') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d220697b-8cb7-46eb-bf38-be44ccdc1e7c', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.5.2.1', 'other', 'The PEWIRS has adequate resistance to impact damage in situations other than those with') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('52721840-75a5-4eb3-a1c3-1e764c13aa5a', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6946', 'other', 'Building components and building elements. Thermal resistance and thermal transmittance.') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('549730af-757f-4290-9f35-290e2d139fa8', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'U-value calculations, refer to BRE report BR 443 Conventions for U-value calculations') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e42f4b74-1745-4534-9259-da30449f849b', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'External wall construction details (from outside to inside)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d38ad8e3-faee-4a14-925e-80afab20ddba', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4', 'other', 'Installation/Practical Application') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3a2367b1-4721-45df-8d3e-a56d2d968e4b', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6', 'other', 'Conditions of Certificate Issue') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bd1862df-5a98-4d49-9a31-db033ceda691', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Yellow, Class 0 Class 0') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b7b5a12f-28b5-4fb9-98d9-12fbeb28b63a', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'Yellow, Class 0 Class 0') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a4d26d35-f45e-438e-b851-23a1332a4f89', 'f544ebd9-d97b-4292-b5f9-5247ff17f7c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3', 'other', 'Yellow, Class 0 Class 0') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ed427f58-3f6c-4b8a-9afb-337cb24075c1', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'other', 'Substance or mixture classification') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3a542441-3b87-4861-995b-c3c912855559', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2.1', 'other', 'Regulation (CE) 1272/2008 (CLP) and subsequent amendments and adjustments.') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c1cf964f-d17a-4006-b36c-0f11882c9bc6', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'Description of first aid measures') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e3d8e56d-2ae3-41bf-b158-41648603c7b3', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.1', 'other', 'Description of first aid measures (continued)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('60b992d3-7d51-40f0-99d6-5d2ea8069b67', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.2', 'other', 'Most important symptoms and effects, both acute and delayed') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2d0b2800-f6b1-4ba1-b254-3b6e8c5952a4', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4.3', 'other', 'Indication of any immediate medical attention and special treatment needed') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('01d0366a-e4eb-4e5a-b825-bdf943f7beb4', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.2', 'other', 'Special hazards arising from the substance or mixture') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8ce5ed04-4371-4ad6-8607-da492c849faf', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '5.3', 'other', 'Advise for firefighters') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('84e0d344-8222-46bc-8e16-afa0afc951c0', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.1', 'other', 'Personal precautions, protective equipment and emergency procedures') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('c8af3691-18cf-4962-b6f9-26551aa9ef40', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.2', 'other', 'Environmental precautions') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8638ef55-bd11-4bd5-a390-479a7b686747', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.3', 'other', 'Methods and materials for the containment and the decontamination') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d4c551c4-9a84-4cfd-9dee-7e59ecc21567', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '6.4', 'other', 'Reference to other sections') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5a9daeb1-5844-493c-aa0e-8bb971ccb81f', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '7.1', 'other', 'Precautions for safe handling') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b37f04e0-a8b9-4027-a937-594958d76fe6', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '7.2', 'other', 'Conditions for safe storage, including any incompatibilities') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3bff4150-ce72-4e24-85da-81c2af22fb98', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '9.1', 'other', 'Information on basic physical and chemical properties') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('19183fe6-1010-4972-9973-7fec610cf88f', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '10.3', 'other', 'Possibility of hazardous reactions') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('ff9e737d-34b6-48cc-bbe6-33e752f28636', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '10.5', 'other', 'Incompatible materials') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b3ae953e-91d7-4354-a2df-40544d3d35a2', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '10.6', 'other', 'Hazardous decomposition products') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5f96bd93-4324-43ac-baef-17cb87945fe5', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '11.1', 'other', 'Information on toxicological effects') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d1d36c95-cfd2-4298-a18b-feba4a997ec7', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12.2', 'other', 'Persistency and degradability') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('68515b64-e6e2-4e7b-9276-9cdf145bee64', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12.3', 'other', 'Bio-accumulation potential') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0a6eced4-0ca9-4b08-832a-9958cd7b348e', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12.5', 'other', 'Results of the PBT and vPvB evaluation') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d98ebf08-c10c-4ffe-ae76-5120023d52b0', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '12.6', 'other', 'Other adverse effects') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f30d62ac-5f7e-462a-a66b-1f9405b874f8', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '13.1', 'other', 'Waste treatment methods') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('327eb22f-fde3-48c8-870a-6c664902e447', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '14.2', 'other', 'ONU’s expedition name') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7a24c24f-eb71-4f28-b1b5-bf0df0cec62c', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '14.3', 'other', 'Transport hazard class(es)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('f30c1624-a92b-4592-8006-7a102c37e040', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '14.5', 'other', 'Environmental hazards') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5858e185-41af-4308-8532-c7bbf1e5923a', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '14.6', 'use', 'Special precautions for user') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5c072ee8-bc5d-4eb4-a109-f84c42a4cebd', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '14.7', 'other', 'Transport in bulk according to Annex II of MARPOL 73/78 and the IBC Code') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('5848fdd1-2552-42f2-b92f-cc1043e54632', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '15.1', 'other', 'Safety, health and environmental regulations/legislation specific for the substance or mixture') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bc6ba34a-70ad-41dc-a29c-a41525abea0d', 'e6f3d36c-6b51-4c47-a24c-a05727c3cf9c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '15.2', 'other', 'Evaluation of chemical safety') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('566a97fd-41d7-4e44-8e65-d6479a305e77', '9720e177-abee-4beb-a63b-7582113e42c0', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('974de5cb-41c5-4f4c-bfe2-374d6a87c530', '9720e177-abee-4beb-a63b-7582113e42c0', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7778e555-2d71-4360-b379-7f12636f9ea2', 'a31542e7-21a5-48c3-aa95-8af70040a4f8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN) CILL - T.104.50.12') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('0799476e-e2a0-43bb-8a19-fe563936940f', 'a31542e7-21a5-48c3-aa95-8af70040a4f8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('825a8c58-33b1-4b8c-ba37-74e334847ad4', 'a31542e7-21a5-48c3-aa95-8af70040a4f8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No 5.5 dia TEKS 2 No ADDITIONAL JAMB FIXINGS(MIN) CILL - T.104.50.15') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('634479e4-350d-4223-a646-7eac98b6af73', 'a31542e7-21a5-48c3-aa95-8af70040a4f8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('775ba182-8b4a-44bc-802b-f123dce823f5', '2c323775-676b-4d33-813b-1f5b79f0e807', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('4624751c-972f-4868-8f3a-f987951bc836', '2c323775-676b-4d33-813b-1f5b79f0e807', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No ADDITIONAL JAMB FIXINGS(MIN)') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7c01dbb9-214a-4d74-a850-93a72f9e1cf9', '2c323775-676b-4d33-813b-1f5b79f0e807', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'No PFC(125x60) USING 5.5 dia TEK') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('147c4837-5241-4c42-8c1a-e0d6384ca567', 'e98b2aa2-e504-4503-9ce8-b508550d3da4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '154', 'other', 'Putney High Street PO Box 732') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('44a8ccb1-8bdf-4791-a44c-949adc4f4a0f', 'e98b2aa2-e504-4503-9ce8-b508550d3da4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'use', 'The development hereby permitted shall be carried out in accordance with the drawings and') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d084cdce-5402-475b-be63-0c7fb4edce44', 'e98b2aa2-e504-4503-9ce8-b508550d3da4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'Except for piling, excavation and demolition work, you must carry out any building work which') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('8c6921e5-306d-45a5-a1cb-c5263d4ec5c4', 'e98b2aa2-e504-4503-9ce8-b508550d3da4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '3', 'other', 'All new work to the outside of the building must match existing original work in terms of the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b33d2401-6ce7-4502-89a3-230af8ac1a9e', 'e98b2aa2-e504-4503-9ce8-b508550d3da4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '4', 'other', 'You must apply to us for approval of samples (including photographs alongside existing') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('44e9e1cb-92ba-46b7-8b49-9ca33e65cbbc', 'e98b2aa2-e504-4503-9ce8-b508550d3da4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'In dealing with this application the City Council has implemented the requirement in the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3afdf36e-990a-414d-bfb4-2c4c9befad31', 'd6fac437-f66f-4e1d-9720-036d9486538e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'This permission fully meets condition(s) 4 of the planning permission dated 19th May 2020') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3cc137ef-f711-4f96-b096-e12f9157700b', 'af98801a-7091-473a-b16c-db393bd71200', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'This permission fully meets condition(s) 4 of the planning permission dated 2nd November') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('821d5c52-bec2-442e-818e-646b8e19dd95', 'af98801a-7091-473a-b16c-db393bd71200', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '2', 'other', 'You applied to discharge condition 3. You are advised that this condition is a ''compliance') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('bac1627b-4426-49d7-a898-387986a5af0f', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1', 'other', 'Technical Specification') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('a53590ca-8b23-42db-a880-fafbcaf61d90', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.2', 'other', 'Adhesive, basecoat and primer') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('376b2a1c-0551-47c4-bbb0-01aee29f7237', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.2.1', 'other', 'PermaRock Adhesive and PermaRock Lamella Adhesive are polymer modified cement-based') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('901d8aae-3eec-4f23-aa09-7a3e5567c261', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.2.2', 'other', 'PermaRock Bedding Mortar is a polymer modified cement-based powder, requiring only the') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('67ee5a6b-ef7b-472f-b960-41cc1f4ae8df', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.2.3', 'use', 'PermaRock K & R Primer is used for priming surfaces before application of acrylic/silicone K') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7fe788eb-7bda-47ac-8427-b36d97ad2963', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.3.1', 'other', 'PermaRock Mineral Fibre insulation slabs are manufactured and supplied in accordance with') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('12b8c1b0-cb29-4910-aa8e-3181b2b6d644', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.3.2', 'other', 'PermaRock EPS insulation is manufactured and supplied in accordance with BS EN 13163') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('b7fd5c33-a457-471f-b71f-e39a8e2f0f52', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.3.3', 'other', 'A summary of the information provided for each insulation material in terms of product') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('2c90a318-9f99-4049-aa54-beb255431a47', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.4.1', 'other', 'Cement based decorative finishes:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('3668c76c-1df9-438d-9370-91cc8387d3fc', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.4.2', 'other', 'Lime based decorative finish:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('e6e6935b-c584-4722-aed6-6a6e59858069', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.4.3', 'other', 'Cement-free decorative finishes:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('d9bd3384-ff4a-4029-9a43-55323c79d844', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.4.4', 'other', 'Brick slip decorative finish:') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('aa3ae970-658a-499d-be8d-353a8508728a', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.5', 'other', 'Fixing components for insulation') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('7478dfb0-0714-41aa-b687-d0c51d527831', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.6', 'other', 'Reinforcement materials') ON CONFLICT (id) DO NOTHING;

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text) 
VALUES ('44a7572b-3738-4212-a153-4bcc686b3b56', '299f95fc-ebb7-4e6a-8572-e676c3f3c368', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', '1.1.7', 'other', 'Ancillary components (outside scope of the certificate)') ON CONFLICT (id) DO NOTHING;

COMMIT;